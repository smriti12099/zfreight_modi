@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'test'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Ztest
  as select from I_BillingDocumentBasic
{
  key BillingDocument,
      SDDocumentCategory,
      BillingDocumentCategory,
      BillingDocumentType

}
