@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Category'
define root view entity ZR_SPACC110_CATEGORY
  as select from zspacc110_categ
{
  key category_id as CategoryId,
      category_name as CategoryName
}
