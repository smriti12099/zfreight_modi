@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Gate Header'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MIXED
}
define view entity zcds_i_invheadf
  as select from I_BillingDocumentBasic
{
  key cast( BillingDocument as vbeln preserving type )     as Invoice,
      cast( BillingDocumentType as fkart preserving type ) as InvoiceType,
      CreationDate                                         as InvoiceDate,
      cast( SalesOrganization as vkorg preserving type )   as SalesOrganization,
      cast( SoldToParty as kunag preserving type )         as Customer,
      _SoldToParty.BPCustomerName                          as CustomerName,
      Region                                               as Region,
      YY1_VehicleNo_BDH                                    as VechicleNo,
      YY1_LRGCNo_BDH                                       as LrNo,
      YY1_SalesOrderNumber_BDH                             as RefNum,
      YY1_TransporterCode_BDH                              as TransporterCode

}

where
      BillingDocumentType        = 'F2'
  and BillingDocumentIsCancelled = ''
