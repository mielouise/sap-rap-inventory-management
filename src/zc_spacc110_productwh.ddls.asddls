@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Warehouse Projection View'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZC_SPACC110_PRODUCTWH
  provider contract transactional_query

  as projection on ZR_SPACC110_PRODUCTWH
{
  key ProductId,
  key WarehouseId,

      StockQuantity,
      MinimumStock,

      _Product,
      _Warehouse
}
