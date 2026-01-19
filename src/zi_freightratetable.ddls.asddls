@EndUserText.label: 'Freight Rate Table'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_FreightRateTable
  as select from ZFREIGHTRATE
  association to parent ZI_FreightRateTable_S as _FreightRateTableAll on $projection.SingletonID = _FreightRateTableAll.SingletonID
{
  key PLANT_PIN as PlantPin,
  key CUSTOMER_PIN as CustomerPin,
  key VALID_FROM as ValidFrom,
  key VALID_TO as ValidTo,
  FREIGHT_RATE as FreightRate,
  @Consumption.hidden: true
  1 as SingletonID,
  _FreightRateTableAll
}
