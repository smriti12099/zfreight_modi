@EndUserText.label: 'Abstract CDS View'
@Metadata.allowExtensions: true
define abstract entity ZCDS_FREIGHT_ABSTRACT
  //with parameters parameter_name : parameter_type
{
   
  FreightRate   : abap.dec( 15, 2 );
  DetentionRate : abap.dec( 15, 2 );
  OtherCharges  : abap.dec( 15, 2 );


}
