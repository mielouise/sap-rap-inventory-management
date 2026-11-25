CLASS lhc_warehouse DEFINITION
  INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS validateWarehouseName
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR Warehouse~validateWarehouseName.
ENDCLASS.

CLASS lsc_ZR_SPACC110_WAREHOUSE DEFINITION
  INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS adjust_numbers REDEFINITION.
ENDCLASS.

CLASS lhc_warehouse IMPLEMENTATION.

  METHOD validateWarehouseName.

    READ ENTITIES OF zr_spacc110_warehouse IN LOCAL MODE
      ENTITY Warehouse
      FIELDS ( WarehouseId WarehouseName )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_warehouses).

    LOOP AT lt_warehouses INTO DATA(ls_warehouse).

      APPEND VALUE #(
        %tky        = ls_warehouse-%tky
        %state_area = 'WAREHOUSE_NAME'
      ) TO reported-Warehouse.

      DATA(lv_warehouse_name_normalized) =
        to_upper( ls_warehouse-WarehouseName ).

      SELECT SINGLE warehouse_id
        FROM zspacc110_ware
        WHERE upper( warehouse_name ) = @lv_warehouse_name_normalized
          AND warehouse_id <> @ls_warehouse-WarehouseId
        INTO @DATA(lv_existing_warehouse).

      IF sy-subrc = 0.

        APPEND VALUE #(
          %tky = ls_warehouse-%tky
        ) TO failed-Warehouse.

        APPEND VALUE #(
          %tky        = ls_warehouse-%tky
          %state_area = 'WAREHOUSE_NAME'
          %msg        = new_message_with_text(
                           severity = if_abap_behv_message=>severity-error
                           text     = 'A warehouse with this name already exists.'
                         )
          %element-WarehouseName = if_abap_behv=>mk-on
        ) TO reported-Warehouse.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.



CLASS lsc_ZR_SPACC110_WAREHOUSE IMPLEMENTATION.

  METHOD adjust_numbers.

    " Gennemgå nye lagre
    LOOP AT mapped-Warehouse
      ASSIGNING FIELD-SYMBOL(<warehouse>).

      " Hent næste Warehouse ID
      TRY.

          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr = '01'
              object      = 'ZSP110WAR'
              quantity    = 1

            IMPORTING
              number            = DATA(lv_number)
              returncode        = DATA(lv_returncode)
              returned_quantity = DATA(lv_quantity)
          ).

        CATCH cx_number_ranges INTO DATA(lx_error).

          " Kritisk fejl under save-sekvensen
          RAISE SHORTDUMP lx_error.

      ENDTRY.

      " Kontrollér at nummeret blev returneret
      ASSERT lv_quantity = 1.
      ASSERT lv_number IS NOT INITIAL.

      " Kræv en normal returstatus
      ASSERT lv_returncode = space.

      " Kontrollér grænsen for INT4
      ASSERT CONV decfloat34( lv_number )
             <= 2147483647.

      " Tildel det endelige Warehouse ID
      <warehouse>-%key-WarehouseId =
        CONV i( lv_number ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
