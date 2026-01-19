@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View For Freight Header'
@Metadata.ignorePropagatedAnnotations: false
define root view entity zcds_r_invheadf
  as select from zcds_i_invheadf
  --Composition child for header viz Item
  composition [0..*] of zcds_r_invitemf as _Item
{

  key Invoice,
      InvoiceType,
      InvoiceDate,
      SalesOrganization,
      Customer,
      CustomerName,
      Region,
      VechicleNo,
      LrNo,
      RefNum,
      TransporterCode,
      /* Associations */
      _Item
}
