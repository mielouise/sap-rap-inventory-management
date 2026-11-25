CLASS lhc_category DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE Category.
ENDCLASS.

CLASS lhc_category IMPLEMENTATION.
  METHOD precheck_delete.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE product_id
        FROM zspacc110_produc
        WHERE category = @ls_key-CategoryId
        INTO @DATA(lv_product_id).

      IF sy-subrc = 0.
        APPEND VALUE #( %tky = ls_key-%tky )
          TO failed-Category.

        APPEND VALUE #(
          %tky = ls_key-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = 'Category cannot be deleted because products use it.'
          )
        ) TO reported-Category.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
