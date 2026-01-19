CLASS zcl_freightrpt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FREIGHTRPT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF io_request->is_data_requested( ).
      DATA: lt_response    TYPE TABLE OF zcds_i_freight_rpt,
            lt_result      TYPE TABLE OF zcds_i_freight_rpt,
            lt_result1     TYPE TABLE OF zcds_i_freight_rpt,
            wa_result      TYPE zcds_i_freight_rpt,
            ls_response    LIKE LINE OF lt_response,
            lt_responseout LIKE lt_response,
            ls_responseout LIKE LINE OF lt_responseout.

      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).

      "  DATA(lt_clause)        = io_request->get_filter( )->get_as_ranges( ).
      DATA(lt_parameter)     = io_request->get_parameters( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
          CLEAR lt_filter_cond. " Fallback to empty filter list if no ranges are provided
      ENDTRY.
      LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).
        IF ls_filter_cond-name = 'INVOICE'.
          DATA(lt_supplier_invoice) = ls_filter_cond-range[].
        ELSEIF ls_filter_cond-name = 'POSTINGDATE'.
          DATA(lt_posting_date) = ls_filter_cond-range[].
        ENDIF.
      ENDLOOP.
    ENDIF.

    SELECT invoice,plant,transpoter_code,supplier_code,supplier_name,region,documentno,fiscalyear,company,status
     FROM zfreight_expense
    INTO TABLE @lt_response.

    lv_max_rows = lv_skip + lv_top.
    IF lv_skip > 0.
      lv_skip = lv_skip + 1.
    ENDIF.
    CLEAR lt_responseout.
    LOOP AT lt_response ASSIGNING FIELD-SYMBOL(<lfs_out_line_item>) FROM lv_skip TO lv_max_rows.
      ls_responseout = <lfs_out_line_item>.
      APPEND ls_responseout TO lt_responseout.
    ENDLOOP.

    io_response->set_total_number_of_records( lines( lt_response ) ).
    io_response->set_data( lt_responseout ).
  ENDMETHOD.
ENDCLASS.
