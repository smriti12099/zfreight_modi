@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Entiry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MIXED
}
define view entity zcds_r_invitemf
  as select from zcds_i_invitemf
  association to parent zcds_r_invheadf as _Head on $projection.Invoice = _Head.Invoice
{
  key Invoice,
  key InvoiceItem,
      Material,
      MaterialDescription,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      OrderQuantity,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      OpenOrderQuantity,
      BillingQuantityUnit,
      Plant,
      PlantName,
      _Head
}
