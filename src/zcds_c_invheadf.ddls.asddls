@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View For Freight Head'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true
define root view entity zcds_c_invheadf
  provider contract transactional_query
  as projection on zcds_r_invheadf

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
      _Item : redirected to composition child zcds_c_invitemf

}
