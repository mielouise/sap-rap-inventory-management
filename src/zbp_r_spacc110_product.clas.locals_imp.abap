CLASS lhc_product DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateProductName
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~validateProductName.

ENDCLASS.



CLASS lhc_product IMPLEMENTATION.

  METHOD validateProductName.

    READ ENTITIES OF ZR_SPACC110_PRODUCT IN LOCAL MODE
      ENTITY Product
      FIELDS ( ProductName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      DATA(lv_name) = product-ProductName.

      CONDENSE lv_name.

      IF lv_name IS INITIAL
         OR lv_name NA 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÆØÅæøå'.

        APPEND VALUE #(
          %tky = product-%tky
        ) TO failed-product.

        APPEND VALUE #(
          %tky = product-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text     = 'Product name must contain at least one letter.'
          )
          %element-ProductName = if_abap_behv=>mk-on
        ) TO reported-product.

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

      ASSERT lv_quantity = 1.
      ASSERT lv_number IS NOT INITIAL.
      ASSERT lv_returncode = space.

      ASSERT CONV decfloat34( lv_number )
             <= 2147483647.

      <product>-%key-ProductId =
        CONV i( lv_number ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
