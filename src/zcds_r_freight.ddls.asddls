@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Freight Header and Item'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity ZCDS_R_FREIGHT
  as select from I_BillingDocumentBasic     as Head
    inner join   I_BillingDocumentItemBasic as Item  on Head.BillingDocument = Item.BillingDocument
    inner join   ZCDS_I_INVFIRST_ITEM       as First on  Head.BillingDocument     = First.BillingDocument
                                                     and Item.BillingDocumentItem = First.FirstItem
    inner join   I_Plant                    as Plant on Item.Plant = Plant.Plant
  //  left outer join zfreight_expense           as Freight on Head.BillingDocument = Freight.invoice
{
  key cast( Head.BillingDocument as vbeln preserving type ) as Invoice,
  key Item.BillingDocumentItem                              as InvoiceItem,
      Head.BillingDocumentDate                              as InvoiceDate,
      cast( Head.SoldToParty as kunag preserving type )     as Customer,
      Head._SoldToParty.BPCustomerName                      as CustomerName,
      cast(Head.Region as regio preserving type )           as Region,
      Head.YY1_VehicleNo_BDH                                as VechicleNo,
      Head.YY1_LRGCNo_BDH                                   as LrNo,
      Head.YY1_SalesOrderNumber_BDH                         as RefNum,
      Head.YY1_TransporterCode_BDH                          as TransporterCode,
      Item.Plant                                            as Plant,
      Item.Product                                          as Material,
      Plant.PlantName                                       as PlantName,
      cast( 0 as abap.dec(15,2) )                           as FreightRate,
      cast( 0 as abap.dec(15,2) )                           as DetentionRate,
      cast( 0 as abap.dec(15,2) )                           as OtherCharges

}

where
      Head.BillingDocumentType        = 'F2'
  or  Head.BillingDocumentType        = 'JSTO'
  and Head.BillingDocumentIsCancelled = ''
  and Head.YY1_TransporterCode_BDH    is not initial
//and Freight.invoice                 is null
