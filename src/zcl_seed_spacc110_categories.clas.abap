CLASS zcl_seed_spacc110_categories DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_seed_spacc110_categories IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lt_product_categories
      TYPE STANDARD TABLE OF zspacc110_de_prod_category
      WITH EMPTY KEY.

    DATA lt_categories
      TYPE STANDARD TABLE OF zspacc110_categ
      WITH EMPTY KEY.

    SELECT DISTINCT category
      FROM zspacc110_produc
      WHERE category <> @space
      INTO TABLE @lt_product_categories.

    LOOP AT lt_product_categories INTO DATA(lv_category).
      APPEND VALUE #(
        client        = sy-mandt
        category_id   = lv_category
        category_name = lv_category
      ) TO lt_categories.
    ENDLOOP.

    IF lt_categories IS INITIAL.
      out->write( 'No product categories found.' ).
      RETURN.
    ENDIF.

    INSERT zspacc110_categ
      FROM TABLE @lt_categories
      ACCEPTING DUPLICATE KEYS.

    DATA(lv_inserted) = sy-dbcnt.
    COMMIT WORK.

    out->write( |Categories inserted: { lv_inserted }| ).
  ENDMETHOD.
ENDCLASS.
