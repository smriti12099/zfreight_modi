CLASS lhc_zcds_r_freight DEFINITION INHERITING FROM cl_abap_behavior_handler.
  TYPES: BEGIN OF ty_fetch,
           invoice         TYPE vbeln,
           invoiceitem     TYPE posnr,
           invoicedate     TYPE budat,
           customer        TYPE kunag,
           region          TYPE regio,
           transportercode TYPE kunag,
           plant           TYPE werks_d,
           material        TYPE matnr,
           freightrate     TYPE p LENGTH 15 DECIMALS 2,
           detentionrate   TYPE p LENGTH 15 DECIMALS 2,
           othercharges    TYPE p LENGTH 15 DECIMALS 2,
         END OF ty_fetch.
  TYPES: BEGIN OF ty_item,
           billingdocument          TYPE i_billingdocumentitembasic-billingdocument,
           billingdocumentitem      TYPE i_billingdocumentitembasic-billingdocumentitem,
           product                  TYPE i_billingdocumentitembasic-product,
           plant                    TYPE i_billingdocumentitembasic-plant,
           billingquantity          TYPE i_billingdocumentitembasic-billingquantity,
           additionalmaterialgroup2 TYPE i_billingdocumentitembasic-additionalmaterialgroup2,
           division                 TYPE i_billingdocumentbasic-division,
           distributionchannel      TYPE i_billingdocumentbasic-distributionchannel,
           yy1_transportercode_bdh  TYPE i_billingdocumentbasic-yy1_transportercode_bdh,
           region                   TYPE i_customer-region,
         END OF ty_item.
  TYPES: BEGIN OF ty_costcentre,
           costcentre TYPE vbeln,
           billingqty TYPE p LENGTH 15 DECIMALS 2,
         END OF ty_costcentre.
  TYPES : BEGIN OF ty_post,
            yy1_transportercode_bdh TYPE i_billingdocumentbasic-yy1_transportercode_bdh,
            glaccount               TYPE i_accountingdocumentjournal-glaccount,
            costcenter              TYPE i_accountingdocumentjournal-costcenter,
            companycode             TYPE i_accountingdocumentjournal-companycode,
            debitvalue              TYPE i_accountingdocumentjournal-debitamountincocodecrcy,
            creditvalue             TYPE i_accountingdocumentjournal-debitamountincocodecrcy,
          END OF ty_post.
  CLASS-DATA: lt_fetch TYPE STANDARD TABLE OF ty_fetch.
  CLASS-DATA: lt_item TYPE STANDARD TABLE OF ty_item.
  CLASS-DATA: lt_costcentre TYPE STANDARD TABLE OF ty_costcentre.
  CLASS-DATA: ls_costcentre TYPE ty_costcentre.
  CLASS-DATA : gv_total_qty TYPE p LENGTH 15 DECIMALS 2.
  CLASS-DATA : gv_total_credit TYPE p LENGTH 15 DECIMALS 2.
*  CLASS-DATA : gv_total_credit TYPE decfloat34.
  CLASS-DATA : gv_total_freightrate TYPE p LENGTH 15 DECIMALS 2.
  CLASS-DATA : gv_freight_default TYPE p LENGTH 15 DECIMALS 2.
  CLASS-DATA : lt_post TYPE STANDARD TABLE OF ty_post.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR freight RESULT result.

*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR freight RESULT result.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE freight.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE freight.

*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE freight.

    METHODS read FOR READ
      IMPORTING keys FOR READ freight RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK freight.
    METHODS calculate_freight FOR MODIFY
      IMPORTING keys FOR ACTION freight~calculate_freight RESULT result.
    METHODS getdefaultsforfreight FOR READ
      IMPORTING keys FOR FUNCTION freight~getdefaultsforfreight RESULT result.

    METHODS calculate_freight_default FOR MODIFY
      IMPORTING keys FOR ACTION freight~calculate_freight_default RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR freight RESULT result.
*    METHODS calculate_freight FOR MODIFY
*      IMPORTING keys FOR ACTION freight~calculate_freight.
*    METHODS postjournalentry FOR MODIFY
*      IMPORTING keys FOR ACTION zcds_r_freight~postjournalentry RESULT result.
*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR zcds_r_freight RESULT result.

ENDCLASS.

CLASS lhc_zcds_r_freight IMPLEMENTATION.


  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD get_global_authorizations.
*  ENDMETHOD.

*  METHOD create.
*
*    LOOP AT entities INTO DATA(ls_update).
*
*    ENDLOOP.
*  ENDMETHOD.

  METHOD update.
    LOOP AT entities INTO DATA(ls_entities).

    ENDLOOP.


  ENDMETHOD.

*  METHOD delete.
*  ENDMETHOD.

  METHOD read.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD calculate_freight.
    READ ENTITIES OF zcds_r_freight IN LOCAL MODE
  ENTITY freight
  ALL FIELDS WITH CORRESPONDING #( keys )
  RESULT DATA(freight)
  FAILED failed.
    CLEAR : lt_fetch[].
    LOOP AT keys INTO DATA(ls_keys).
      APPEND INITIAL LINE TO lt_fetch ASSIGNING FIELD-SYMBOL(<ls_fetch>).
      IF <ls_fetch> IS ASSIGNED.
        <ls_fetch>-invoice = ls_keys-invoice.
        <ls_fetch>-freightrate = ls_keys-%param-freightrate.
        <ls_fetch>-detentionrate = ls_keys-%param-detentionrate.
        <ls_fetch>-othercharges = ls_keys-%param-othercharges.
      ENDIF..
*      APPEND INITIAL LINE TO lt_update ASSIGNING FIELD-SYMBOL(<ls_update>).
*
*      <ls_update>-%tky = ls_keys-%tky.       " mandatory to identify row*
*      " updateable fields
*      <ls_update>-freightrate   = ls_keys-%param-freightrate * 10.
*      <ls_fetch>-detentionrate = ls_keys-%param-detentionrate.
*      <ls_fetch>-othercharges  = ls_keys-%param-othercharges.
    ENDLOOP.
*    MODIFY ENTITIES OF zcds_r_freight IN LOCAL MODE
*    ENTITY freight
*      UPDATE FIELDS ( freightrate detentionrate othercharges )
*      WITH lt_update
*    REPORTED reported
*    FAILED failed.
    CLEAR : lt_item[].
    IF lt_fetch[] IS NOT INITIAL.
      SELECT a~billingdocument,a~billingdocumentitem,a~product,a~plant,a~billingquantity,a~additionalmaterialgroup2,
      b~division,b~yy1_transportercode_bdh,c~region FROM i_billingdocumentitembasic AS a
      INNER JOIN i_billingdocumentbasic AS b ON a~billingdocument = b~billingdocument
      INNER JOIN i_customer AS c ON a~soldtoparty = c~customer
      FOR ALL ENTRIES IN @lt_fetch[]
      WHERE a~billingdocument = @lt_fetch-invoice
      INTO TABLE @lt_item.
    ENDIF.
    """"""""" Validation For Transpoter Code should be same
    DATA(lt_itemd) = lt_item[].
    SORT lt_itemd BY yy1_transportercode_bdh.
    DELETE ADJACENT DUPLICATES FROM lt_itemd COMPARING yy1_transportercode_bdh.
    DATA(lv_count) = lines( lt_itemd ).
    IF lv_count > 1.
      APPEND VALUE #(
         %msg = new_message(
                 id       = 'ZMSG_FREIGHT'
                 number   = '001'
                 v1       = 'Transporter Code should be same'
                 severity = if_abap_behv_message=>severity-error )
         %element-transportercode = if_abap_behv=>mk-on
     ) TO reported-freight.
    ENDIF.
    """" Create CostCentre
    LOOP AT lt_item INTO DATA(ls_item).
      CONCATENATE ls_item-plant ls_item-division+0(1) ls_item-region+0(2) ls_item-additionalmaterialgroup2+0(2) '0'
      INTO ls_costcentre-costcentre.
      ls_costcentre-billingqty = ls_item-billingquantity.
      COLLECT ls_costcentre INTO lt_costcentre.
      CLEAR ls_costcentre.
    ENDLOOP.

    gv_total_qty = REDUCE #(
INIT total = 0
FOR ls IN lt_costcentre
NEXT total = total + ls-billingqty ).

    DATA(lv_freight) = VALUE #( lt_fetch[ 1 ]-freightrate OPTIONAL ) .
    DATA(lv_detentionrate) = VALUE #( lt_fetch[ 1 ]-detentionrate OPTIONAL ) .
    DATA(lv_othercharges) = VALUE #( lt_fetch[ 1 ]-othercharges OPTIONAL ) .
    DATA(lv_transportername) = VALUE #( lt_item[ 1 ]-yy1_transportercode_bdh OPTIONAL ) .
    CLEAR : lt_post[].
    DO 3 TIMES.
      IF sy-index EQ 1.
        LOOP AT lt_costcentre INTO ls_costcentre.
          APPEND INITIAL LINE TO lt_post ASSIGNING FIELD-SYMBOL(<ls_post>).
          IF <ls_post> IS ASSIGNED.
            <ls_post>-yy1_transportercode_bdh = lv_transportername.
            <ls_post>-costcenter = ls_costcentre-costcentre.
            <ls_post>-debitvalue = lv_freight * ls_costcentre-billingqty / gv_total_qty.
            <ls_post>-glaccount = '0075006046'.
          ENDIF.
        ENDLOOP..
      ELSEIF sy-index EQ 2.
        UNASSIGN <ls_post>.
        LOOP AT lt_costcentre INTO ls_costcentre.
          APPEND INITIAL LINE TO lt_post ASSIGNING <ls_post>.
          IF <ls_post> IS ASSIGNED.
            <ls_post>-yy1_transportercode_bdh = lv_transportername.
            <ls_post>-costcenter = ls_costcentre-costcentre.
            <ls_post>-debitvalue = lv_detentionrate * ls_costcentre-billingqty / gv_total_qty.
            <ls_post>-glaccount = '0063000109'.
          ENDIF.
        ENDLOOP..
      ELSEIF sy-index EQ 3.
        UNASSIGN <ls_post>.
        LOOP AT lt_costcentre INTO ls_costcentre.
          APPEND INITIAL LINE TO lt_post ASSIGNING <ls_post>.
          IF <ls_post> IS ASSIGNED.
            <ls_post>-yy1_transportercode_bdh = lv_transportername.
            <ls_post>-costcenter = ls_costcentre-costcentre.
            <ls_post>-debitvalue = lv_othercharges * ls_costcentre-billingqty / gv_total_qty.
            <ls_post>-glaccount = '0063000103'.
          ENDIF.
        ENDLOOP..
      ENDIF.
    ENDDO.
    gv_total_credit = REDUCE #(
INIT total = 0
FOR ls1 IN lt_post
NEXT total = total + ls1-debitvalue ).

  ENDMETHOD.

  METHOD getdefaultsforfreight.

    DATA lt_plantpostalcoder TYPE RANGE OF ad_pstcd1.
    DATA: lt_customerpostalcoder TYPE RANGE OF ad_pstcd1,
          lt_plantr              TYPE RANGE OF werks_d,
          lt_plantaddressr       TYPE RANGE OF vbeln_va,
          lt_salesdocr           TYPE RANGE OF vbeln_va.

    READ ENTITIES OF zcds_r_freight IN LOCAL MODE
    ENTITY freight
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_freight)
    FAILED failed.
    "" Get Plant Postal Code
    SELECT billingdocument,billingdocumentitem,plant,salesdocument FROM i_billingdocumentitembasic
    FOR ALL ENTRIES IN @keys
    WHERE billingdocument = @keys-invoice
    INTO TABLE @DATA(it_item).
    lt_plantr = VALUE #(
FOR lspp IN it_item
( sign = 'I' option = 'EQ' low = lspp-plant )
).
    IF lt_plantr IS NOT INITIAL.
      SELECT plant, addressid FROM i_plant
*        FOR ALL ENTRIES IN @it_item
        WHERE plant IN @lt_plantr
        INTO TABLE @DATA(lt_plantaddressid).
      lt_plantaddressr = VALUE #(
FOR lsppa IN lt_plantaddressid
( sign = 'I' option = 'EQ' low = lsppa-addressid )
).
      IF lt_plantaddressid[] IS NOT INITIAL.
        SELECT addressid, postalcode FROM i_address_2  WITH PRIVILEGED ACCESS
*        FOR ALL ENTRIES IN @lt_plantaddressid
        WHERE addressid IN @lt_plantaddressr
        INTO TABLE @DATA(lt_plantpostalcode).
      ENDIF.
    ENDIF.

    """""" Get Customer Postal Code
    lt_salesdocr = VALUE #(
FOR lspps IN it_item
( sign = 'I' option = 'EQ' low = lspps-salesdocument )
).
    IF it_item[] IS NOT INITIAL.
      SELECT a~salesorder,a~customer,b~postalcode FROM i_salesorderitempartnertp AS a
      INNER JOIN i_customer AS b ON a~customer = b~customer
*      FOR ALL ENTRIES IN @it_item
      WHERE salesorder IN @lt_salesdocr
      AND partnerfunction = 'WE'
      INTO TABLE @DATA(lt_customerpostalcode).
    ENDIF.

    lt_plantpostalcoder = VALUE #(
FOR lsp IN lt_plantpostalcode
( sign = 'I' option = 'EQ' low = lsp-postalcode )
).

    lt_customerpostalcoder = VALUE #(
FOR lsc IN lt_customerpostalcode
( sign = 'I' option = 'EQ' low = lsc-postalcode )
).

    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    SELECT freight_rate FROM zfreightrate
    WHERE plant_pin IN @lt_plantpostalcoder
    AND customer_pin IN @lt_customerpostalcoder
    AND valid_from LE @lv_date
    AND valid_to GE @lv_date
   INTO TABLE @DATA(lt_freightrate).

    gv_total_freightrate = REDUCE #(
   INIT total = 0
   FOR lst IN lt_freightrate
   NEXT total = total + lst-freight_rate ).
    APPEND VALUE #( %param-freightrate = gv_total_freightrate
                    %tky                     = keys[ 1 ]-%tky  ) TO result.

  ENDMETHOD.

  METHOD calculate_freight_default.

    TYPES: BEGIN OF ty_sum,
             trans TYPE vbeln_va,
             value TYPE decfloat34,
           END OF ty_sum.

    DATA : lt_sum TYPE STANDARD TABLE OF ty_sum,
           ls_sum TYPE ty_sum.

    READ ENTITIES OF zcds_r_freight IN LOCAL MODE
ENTITY freight
ALL FIELDS WITH CORRESPONDING #( keys )
RESULT DATA(freight)
FAILED failed.
    CLEAR : lt_fetch[].
    LOOP AT keys INTO DATA(ls_keys).
      APPEND INITIAL LINE TO lt_fetch ASSIGNING FIELD-SYMBOL(<ls_fetch>).
      IF <ls_fetch> IS ASSIGNED.
        <ls_fetch>-invoice = ls_keys-invoice.
        <ls_fetch>-freightrate = ls_keys-%param-freightrate.
        <ls_fetch>-detentionrate = ls_keys-%param-detentionrate.
        <ls_fetch>-othercharges = ls_keys-%param-othercharges.
      ENDIF.
    ENDLOOP.

    CLEAR : lt_item[].
    IF lt_fetch[] IS NOT INITIAL.
      SELECT a~billingdocument,a~billingdocumentitem,a~product,a~plant,a~billingquantity,a~additionalmaterialgroup2,
      b~division,b~distributionchannel,b~yy1_transportercode_bdh,c~region FROM i_billingdocumentitembasic AS a
      INNER JOIN i_billingdocumentbasic AS b ON a~billingdocument = b~billingdocument
      INNER JOIN i_customer AS c ON a~soldtoparty = c~customer
      FOR ALL ENTRIES IN @lt_fetch[]
      WHERE a~billingdocument = @lt_fetch-invoice
      INTO TABLE @lt_item.
    ENDIF.
    """"""""" Validation For Transpoter Code should be same
    DATA(lt_itemd) = lt_item[].
    SORT lt_itemd BY yy1_transportercode_bdh.
    DELETE ADJACENT DUPLICATES FROM lt_itemd COMPARING yy1_transportercode_bdh.
    DATA(lv_count) = lines( lt_itemd ).
    IF lv_count > 1.
      APPEND VALUE #(
         %msg = new_message(
                 id       = 'ZMSG_FREIGHT'
                 number   = '001'
                 v1       = 'Transporter Code should be same'
                 severity = if_abap_behv_message=>severity-error )
         %element-transportercode = if_abap_behv=>mk-on
     ) TO reported-freight.
    ENDIF.
    """" Create CostCentre
    LOOP AT lt_item INTO DATA(ls_item).
      IF ls_item-distributionchannel EQ '12'.
        DATA(lv_dist) = '2'.
      ELSEIF ls_item-distributionchannel EQ '13'.
        lv_dist = '3'.
      ELSE.
        lv_dist = '1'.
      ENDIF.
      CONCATENATE ls_item-plant ls_item-division+0(1) ls_item-region+0(2) ls_item-additionalmaterialgroup2+0(2) '0'
      INTO ls_costcentre-costcentre.
      ls_costcentre-billingqty = ls_item-billingquantity.
      COLLECT ls_costcentre INTO lt_costcentre.
      CLEAR ls_costcentre.
    ENDLOOP.

    gv_total_qty = REDUCE #(
INIT total = 0
FOR ls IN lt_costcentre
NEXT total = total + ls-billingqty ).

    DATA(lv_freight) = VALUE #( lt_fetch[ 1 ]-freightrate OPTIONAL ) .
    DATA(lv_detentionrate) = VALUE #( lt_fetch[ 1 ]-detentionrate OPTIONAL ) .
    DATA(lv_othercharges) = VALUE #( lt_fetch[ 1 ]-othercharges OPTIONAL ) .
    DATA(lv_transportername) = VALUE #( lt_item[ 1 ]-yy1_transportercode_bdh OPTIONAL ) .
    CLEAR : lt_post[].
    DO 3 TIMES.
      IF sy-index EQ 1.
        LOOP AT lt_costcentre INTO ls_costcentre.
          APPEND INITIAL LINE TO lt_post ASSIGNING FIELD-SYMBOL(<ls_post>).
          IF <ls_post> IS ASSIGNED.
            <ls_post>-yy1_transportercode_bdh = lv_transportername.
            <ls_post>-costcenter = ls_costcentre-costcentre.
            <ls_post>-debitvalue = lv_freight * ls_costcentre-billingqty / gv_total_qty.
            <ls_post>-glaccount = '0075006046'.
          ENDIF.
        ENDLOOP..
      ELSEIF sy-index EQ 2.
        UNASSIGN <ls_post>.
        LOOP AT lt_costcentre INTO ls_costcentre.
          APPEND INITIAL LINE TO lt_post ASSIGNING <ls_post>.
          IF <ls_post> IS ASSIGNED.
            <ls_post>-yy1_transportercode_bdh = lv_transportername.
            <ls_post>-costcenter = ls_costcentre-costcentre.
            <ls_post>-debitvalue = lv_detentionrate * ls_costcentre-billingqty / gv_total_qty.
            <ls_post>-glaccount = '0063000109'.
          ENDIF.
        ENDLOOP..
      ELSEIF sy-index EQ 3.
        UNASSIGN <ls_post>.
        LOOP AT lt_costcentre INTO ls_costcentre.
          APPEND INITIAL LINE TO lt_post ASSIGNING <ls_post>.
          IF <ls_post> IS ASSIGNED.
            <ls_post>-yy1_transportercode_bdh = lv_transportername.
            <ls_post>-costcenter = ls_costcentre-costcentre.
            <ls_post>-debitvalue = lv_othercharges * ls_costcentre-billingqty / gv_total_qty.
            <ls_post>-glaccount = '0063000103'.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDDO.
    gv_total_credit = REDUCE #(
INIT total = 0
FOR ls1 IN lt_post
NEXT total = total + ls1-debitvalue ).

    LOOP AT lt_post INTO DATA(ps_post).
      ls_sum-value = ps_post-debitvalue.
      COLLECT ls_sum INTO lt_sum.
    ENDLOOP.

    READ TABLE lt_sum INTO DATA(wa_sum) INDEX 1.
    gv_total_credit = wa_sum-value.
*    CLEAR gv_total_credit.
*
*    gv_total_credit = lv_freight + lv_detentionrate + lv_othercharges.


  ENDMETHOD.

  METHOD get_instance_features.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zcds_r_freight DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    CLASS-DATA  gv_pid TYPE abp_behv_pid.
    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zcds_r_freight IMPLEMENTATION.

  METHOD finalize.
    DATA(gv_qty) = lhc_zcds_r_freight=>gv_total_qty.
    DATA(lt_post) = lhc_zcds_r_freight=>lt_post.
    DATA(lv_creditvalue) = lhc_zcds_r_freight=>gv_total_credit.
    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          ls_je_deep LIKE LINE OF lt_je_deep,
          ls_gl_item LIKE LINE OF ls_je_deep-%param-_glitems,
          ls_ap_item LIKE LINE OF ls_je_deep-%param-_apitems,
          ls_amount  LIKE LINE OF ls_ap_item-_currencyamount,
          lv_cid     TYPE abp_behv_cid.
    "= VALUE #( ls_mapped_deep-journalentry[ 1 ]-%pid OPTIONAL ) .

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.
    DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    CLEAR ls_je_deep.
    ls_je_deep-%cid = lv_cid.
    ls_je_deep-%param-companycode = '2000'.
    ls_je_deep-%param-documentreferenceid = 'BKPFF'.
    ls_je_deep-%param-createdbyuser = cl_abap_context_info=>get_user_technical_name( ).
    ls_je_deep-%param-businesstransactiontype = 'RFBU'.
    ls_je_deep-%param-accountingdocumenttype = 'KR'.
    ls_je_deep-%param-documentdate = lv_date.
    ls_je_deep-%param-postingdate = lv_date.
    ls_je_deep-%param-accountingdocumentheadertext = 'RAP rules'.
    DATA lv_srno  TYPE  c LENGTH 6.
    lv_srno = 1.
    ls_ap_item-glaccountlineitem = lv_srno.
    ls_ap_item-supplier = VALUE #( lt_post[ 1 ]-yy1_transportercode_bdh OPTIONAL ) .
    SELECT SINGLE reconciliationaccount FROM i_suppliercompany
    WHERE supplier = @ls_ap_item-supplier
      AND companycode = '2000'
      INTO @DATA(lv_suppliergl).
    ls_ap_item-glaccount = lv_suppliergl."'0021100002' .
    CLEAR :ls_amount.
    ls_amount-currency = 'INR'.
    ls_amount-currencyrole = '00'.
    ls_amount-journalentryitemamount = lv_creditvalue * -1.
    APPEND ls_amount TO ls_ap_item-_currencyamount.
    APPEND ls_ap_item TO ls_je_deep-%param-_apitems.

    LOOP AT lt_post INTO DATA(ls_post).
      CLEAR ls_gl_item.
      lv_srno += 1.
      ls_gl_item-glaccountlineitem = lv_srno.
      ls_gl_item-glaccount = ls_post-glaccount.
      ls_gl_item-costcenter = ls_post-costcenter.

      CLEAR :ls_amount.
      ls_amount-currency = 'INR'.
      ls_amount-currencyrole = '00'.
      ls_amount-journalentryitemamount = ls_post-debitvalue.
      APPEND ls_amount TO ls_gl_item-_currencyamount.
      APPEND ls_gl_item TO ls_je_deep-%param-_glitems.
    ENDLOOP..


    APPEND ls_je_deep TO lt_je_deep.

*    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
*    <je_deep>-%cid = lv_cid.
*    <je_deep>-%param = VALUE #(
*    companycode = '2000' " Success
*    documentreferenceid = 'BKPFF'
*    createdbyuser = cl_abap_context_info=>get_user_technical_name( )
*    businesstransactiontype = 'RFBU'
*    accountingdocumenttype = 'KR'
*    documentdate = lv_date
*    postingdate = lv_date
*    accountingdocumentheadertext = 'RAP rules'
**    _glitems = VALUE #( ( glaccountlineitem = |001| costcenter = '21001UPRR0'  glaccount = '0075006046' _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '-100' currency = 'INR' ) ) )
**    ( glaccountlineitem = |002| costcenter = '21001UPRC0' glaccount = '0063000109' _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '-200' currency = 'INR' ) ) ) )
**    _apitems = VALUE #( ( glaccountlineitem = |003| supplier = '0002000000'  glaccount = '0021100002' _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '300' currency = 'INR' ) ) ) )
*
*
*  ).

    MODIFY ENTITIES OF i_journalentrytp PRIVILEGED
    ENTITY journalentry
    EXECUTE post FROM lt_je_deep
    FAILED DATA(ls_failed_deep)
    REPORTED DATA(ls_reported_deep)
    MAPPED DATA(ls_mapped_deep).

    gv_pid = VALUE #( ls_mapped_deep-journalentry[ 1 ]-%pid OPTIONAL ).

    IF ls_failed_deep IS NOT INITIAL.

      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
        ...
      ENDLOOP.
    ELSE.




    ENDIF.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    DATA(lt_fetch) = lhc_zcds_r_freight=>lt_fetch.
    DATA : ls_zfreight_expense TYPE zfreight_expense.

*    COMMIT ENTITIES BEGIN
*  RESPONSE OF i_journalentrytp
*  FAILED DATA(lt_commit_failed)
*  REPORTED DATA(lt_commit_reported).
*    ...
*    COMMIT ENTITIES END.
    CONVERT KEY OF i_journalentrytp FROM gv_pid TO FINAL(lv_key).
*    READ ENTITIES OF i_journalentrytp PRIVILEGED
*        ENTITY journalentry FIELDS ( companycode fiscalyear accountingdocument )
*         WITH VALUE #( ( %pid = gv_pid  )  )
*         RESULT DATA(lt_result)
*         FAILED DATA(lt_field)
*         REPORTED DATA(lt_reported).
    IF lv_key-accountingdocument IS NOT INITIAL.
*      SELECT a~billingdocument,a~billingdocumentitem,a~product,a~plant,a~billingquantity,a~additionalmaterialgroup2,
*        b~division,b~soldtoparty,b~distributionchannel,b~yy1_transportercode_bdh,c~region,c~customername FROM i_billingdocumentitembasic AS a
*        INNER JOIN i_billingdocumentbasic AS b ON a~billingdocument = b~billingdocument
*        INNER JOIN i_customer AS c ON a~soldtoparty = c~customer
*        FOR ALL ENTRIES IN @lt_fetch[]
*        WHERE a~billingdocument = @lt_fetch-invoice
*        INTO TABLE @DATA(lt_item).
*      SORT lt_item BY billingdocument billingdocumentitem.
*      DELETE ADJACENT DUPLICATES FROM lt_item COMPARING billingdocument.
      LOOP AT lt_fetch INTO DATA(ls_item).
        ls_zfreight_expense-invoice = ls_item-invoice.
*        ls_zfreight_expense-item = ls_item-billingdocumentitem.
*        ls_zfreight_expense-plant = ls_item-plant.
*        ls_zfreight_expense-transpoter_code = ls_item-yy1_transportercode_bdh.
*        ls_zfreight_expense-supplier_code = ls_item-soldtoparty.
*        ls_zfreight_expense-supplier_name = ls_item-customername.
*        ls_zfreight_expense-region = ls_item-region.
        ls_zfreight_expense-documentno = lv_key-accountingdocument.
        ls_zfreight_expense-fiscalyear = lv_key-fiscalyear.
        ls_zfreight_expense-company = lv_key-companycode.
        ls_zfreight_expense-status = 'X'.
        MODIFY zfreight_expense FROM @ls_zfreight_expense.
      ENDLOOP.

      APPEND VALUE #(
        %msg = new_message(
                id       = 'ZMSG_FREIGHT'
                number   = '002'
                v1       = |Document No. { lv_key-accountingdocument } Posted|
                severity = if_abap_behv_message=>severity-success )
*        %element-transportercode = if_abap_behv=>mk-on
    ) TO reported-freight.
    ENDIF.

*    SELECT * FROM zfreight_expense INTO TABLE @DATA(lt_data).

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
