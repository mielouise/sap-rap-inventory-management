@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Categories'
@Metadata.allowExtensions: true
define root view entity ZC_SPACC110_CATEGORY
  provider contract transactional_query
  as projection on ZR_SPACC110_CATEGORY
{
  key CategoryId,
      CategoryName
}
