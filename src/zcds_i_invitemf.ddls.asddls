@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Gate Header'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MIXED
}
define view entity zcds_i_invitemf
  as select from I_BillingDocumentItemBasic
{
  key cast( BillingDocument as vbeln preserving type ) as Invoice,
  key BillingDocumentItem                              as InvoiceItem,
      Product                                          as Material,
      BillingDocumentItemText                          as MaterialDescription,
      BillingQuantity                                  as OrderQuantity,
      BillingQuantity                                  as OpenOrderQuantity,
      BillingQuantityUnit,
      Plant                                            as Plant,
      _Plant.PlantName                                 as PlantName

}
