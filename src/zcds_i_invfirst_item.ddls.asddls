@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Freight Invoice First Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_I_INVFIRST_ITEM
  as select from I_BillingDocumentItemBasic
{
  BillingDocument,
  min( BillingDocumentItem ) as FirstItem
}
group by
  BillingDocument
