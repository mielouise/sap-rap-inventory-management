@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Warehouse Inventory'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZR_SPACC110_PRODUCTWH
  as select from zspacc110_prodwh

  association [1..1] to ZR_SPACC110_PRODUCT as _Product
    on $projection.ProductId = _Product.ProductId

  association [1..1] to ZR_SPACC110_WAREHOUSE as _Warehouse
    on $projection.WarehouseId = _Warehouse.WarehouseId

{
  key product_id                  as ProductId,

  key warehouse_id                as WarehouseId,

      stock_quantity              as StockQuantity,

      minimum_stock               as MinimumStock,

      @Semantics.user.createdBy: true
      local_created_by            as LocalCreatedBy,

      @Semantics.systemDateTime.createdAt: true
      local_created_at            as LocalCreatedAt,

      @Semantics.user.lastChangedBy: true
      local_last_changed_by       as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at       as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at             as LastChangedAt,

      _Product,
      _Warehouse
}
