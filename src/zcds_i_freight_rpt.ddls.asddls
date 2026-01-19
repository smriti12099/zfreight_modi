@EndUserText.label: 'Freight Report'
@Search.searchable: false
@ObjectModel.query.implementedBy: 'ABAP:ZCL_FREIGHTRPT'
@UI.headerInfo: {typeName: 'Planning'}
define root custom entity zcds_i_freight_rpt

{

      @EndUserText.label: 'Invoice No.'
      @UI.selectionField: [{ position: 2 }]
      @UI.lineItem    : [{ position: 1, label: 'Invoice No.', navigationAvailable: false }]
  key invoice         : abap.char(10);
      @UI.lineItem    : [{ position: 2, label: 'Plant', navigationAvailable: false }]
      plant           : abap.char(4);
      @UI.lineItem    : [{ position: 3, label: 'Transpoter Code', navigationAvailable: false }]
      transpoter_code : abap.char( 10 );
      @UI.lineItem    : [{ position: 4, label: 'Supplier Code', navigationAvailable: false }]
      supplier_code   : abap.char( 10 );
      @UI.lineItem    : [{ position: 5, label: 'Supplier Name', navigationAvailable: false }]
      supplier_name   : abap.char( 40 );
      @UI.lineItem    : [{ position: 6, label: 'Region', navigationAvailable: false }]
      region          : abap.char( 3 );
      @UI.lineItem    : [{ position: 7, label: 'Document No.', navigationAvailable: false }]
      documentno      : abap.char( 10 );
      @UI.lineItem    : [{ position: 8, label: 'Year', navigationAvailable: false }]
      fiscalyear      : abap.char( 4 );
      @UI.lineItem    : [{ position: 9, label: 'Company Code', navigationAvailable: false }]
      company         : abap.char( 4 );
      @UI.lineItem    : [{ position: 10, label: 'Status', navigationAvailable: false }]
      status          : abap.char( 1 );
}
