@ObjectModel.dataCategory: #VALUE_HELP
@EndUserText.label: 'Category Value Help'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
define view entity ZI_SPACC110_CATEGORY
  as select from zspacc110_categ
{
  @EndUserText.label: 'Category ID'
  @UI.lineItem: [{ position: 10 }]
  key category_id as Category,

  @EndUserText.label: 'Category Name'
  @Search.defaultSearchElement: true
  @UI.lineItem: [{ position: 20 }]
  category_name as CategoryName
}
