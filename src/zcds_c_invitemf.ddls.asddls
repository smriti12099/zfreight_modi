@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View For Freight Item'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zcds_c_invitemf
  as projection on zcds_r_invitemf

{
  key Invoice,
  key InvoiceItem,
      Material,
      MaterialDescription,
      OrderQuantity,
      OpenOrderQuantity,
      BillingQuantityUnit,
      Plant,
      PlantName,
      /* Associations */
      _Head : redirected to parent zcds_c_invheadf

}
