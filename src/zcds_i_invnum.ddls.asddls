@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Invoice Number'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #M,
    dataClass: #MIXED
}
define view entity ZCDS_I_INVNUM
  as select from I_BillingDocumentBasic     as Head
    inner join   I_BillingDocumentItemBasic as Item  on Head.BillingDocument = Item.BillingDocument
    inner join   I_Plant                    as Plant on Item.Plant = Plant.Plant
{
  key cast( Head.BillingDocument as vbeln preserving type ) as Invoice,
      Head.CreationDate                                     as InvoiceDate,
      Head.YY1_SalesOrderNumber_BDH                         as RefNum,
      Head.YY1_TransporterCode_BDH                          as TransporterCode,
      Head.YY1_VehicleNo_BDH                                as VechicleNo,
      Item.Plant                                            as Plant
}
where
      Head.BillingDocumentType        = 'F2'
  and Head.BillingDocumentIsCancelled = ''
