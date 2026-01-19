CLASS lhc_zcds_r_invheadf DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcds_r_invheadf RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zcds_r_invheadf RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zcds_r_invheadf.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcds_r_invheadf.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zcds_r_invheadf.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcds_r_invheadf RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zcds_r_invheadf.

    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ zcds_r_invheadf\_item FULL result_requested RESULT result LINK association_links.

    METHODS cba_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE zcds_r_invheadf\_item.

ENDCLASS.

CLASS lhc_zcds_r_invheadf IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_item.
  ENDMETHOD.

  METHOD cba_item.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zcds_r_invitemf DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcds_r_invitemf.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zcds_r_invitemf.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcds_r_invitemf RESULT result.

    METHODS rba_head FOR READ
      IMPORTING keys_rba FOR READ zcds_r_invitemf\_head FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zcds_r_invitemf IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_head.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zcds_r_invheadf DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zcds_r_invheadf IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
