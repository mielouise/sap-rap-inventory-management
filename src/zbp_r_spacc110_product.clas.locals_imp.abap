CLASS lhc_product DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateProductName
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~validateProductName.

ENDCLASS.

CLASS lhc_product IMPLEMENTATION.

  METHOD validateproductname.
    READ ENTITIES OF zr_spacc110_product IN LOCAL MODE
      ENTITY Product
      FIELDS ( ProductId ProductName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_product).

    LOOP AT lt_product INTO DATA(ls_product).

      APPEND VALUE #(
        %tky        = ls_product-%tky
        %state_area = 'PRODUCT_NAME'
      ) TO reported-Product.

      SELECT SINGLE
        FROM zspacc110_produc
        FIELDS product_id
        WHERE product_name = @ls_product-ProductName
          AND product_id   <> @ls_product-ProductId
        INTO @DATA(lv_existing_product).

      IF sy-subrc = 0.

        APPEND VALUE #(
          %tky = ls_product-%tky
        ) TO failed-Product.

        APPEND VALUE #(
          %tky        = ls_product-%tky
          %state_area = 'PRODUCT_NAME'
          %msg        = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'A product with this name already exists.'
          )
          %element-ProductName = if_abap_behv=>mk-on
        ) TO reported-Product.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


CLASS lsc_zr_spacc110_product DEFINITION
  INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

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
