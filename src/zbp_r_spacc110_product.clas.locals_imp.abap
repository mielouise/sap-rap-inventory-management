CLASS lhc_product DEFINITION
  INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS validateProductName
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~validateProductName.
ENDCLASS.

CLASS lsc_zr_spacc110_product DEFINITION
  INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS adjust_numbers REDEFINITION.
ENDCLASS.

CLASS lhc_product IMPLEMENTATION.

  METHOD validateProductName.
    READ ENTITIES OF zr_spacc110_product IN LOCAL MODE
      ENTITY Product
      FIELDS ( ProductId ProductName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_products).

    DATA lt_seen_names TYPE HASHED TABLE OF zspacc110_de_product_name
      WITH UNIQUE KEY table_line.
    DATA lv_error_text TYPE string.
    DATA lv_normalized_name TYPE zspacc110_de_product_name.
    DATA lv_existing_product TYPE zspacc110_de_prod_id.

    LOOP AT lt_products INTO DATA(ls_product).
      CLEAR lv_error_text.

      APPEND VALUE #(
        %tky        = ls_product-%tky
        %state_area = 'PRODUCT_NAME'
      ) TO reported-Product.

      IF ls_product-ProductName IS INITIAL.
        lv_error_text = 'Product name is required.'.
      ELSE.
        lv_normalized_name = to_upper( ls_product-ProductName ).

        INSERT lv_normalized_name INTO TABLE lt_seen_names.

        IF sy-subrc <> 0.
          lv_error_text = 'A product with this name already exists.'.
        ELSE.
          SELECT SINGLE product_id
            FROM zspacc110_produc
            WHERE upper( product_name ) = @lv_normalized_name
              AND product_id <> @ls_product-ProductId
            INTO @lv_existing_product.

          IF sy-subrc = 0.
            lv_error_text = 'A product with this name already exists.'.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lv_error_text IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_product-%tky )
          TO failed-Product.

        APPEND VALUE #(
          %tky                 = ls_product-%tky
          %state_area          = 'PRODUCT_NAME'
          %msg                 = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = lv_error_text
          )
          %element-ProductName = if_abap_behv=>mk-on
        ) TO reported-Product.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_spacc110_product IMPLEMENTATION.

  METHOD adjust_numbers.
    LOOP AT mapped-Product
      ASSIGNING FIELD-SYMBOL(<product>).

      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr = '01'
              object      = 'ZSP110PRD'
              quantity    = 1
            IMPORTING
              number            = DATA(lv_number)
              returncode        = DATA(lv_returncode)
              returned_quantity = DATA(lv_quantity)
          ).

        CATCH cx_number_ranges INTO DATA(lx_error).
          RAISE SHORTDUMP lx_error.
      ENDTRY.

      <product>-%key-ProductId = CONV i( lv_number ).
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
