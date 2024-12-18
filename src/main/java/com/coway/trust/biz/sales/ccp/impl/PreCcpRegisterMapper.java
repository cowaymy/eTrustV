package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("preCcpRegisterMapper")
public interface PreCcpRegisterMapper {
  int insertPreCcpSubmission( Map<String, Object> params );

  EgovMap getExistCustomer( Map<String, Object> params );

  List<EgovMap> searchOrderSummaryList( Map<String, Object> params );

  Map<String, Object> insertNewCustomerInfo( Map<String, Object> params );

  void updateCcrisScre( Map<String, Object> params );

  void updateCcrisId( Map<String, Object> params );

  int getSeqSAL0343D();

  Map<String, Object> insertNewCustomerDetails( Map<String, Object> params );

  EgovMap getPreccpResult( Map<String, Object> params );

  List<EgovMap> getPreCcpRemark( Map<String, Object> params );

  List<EgovMap> getCustCredibility( Map<String, Object> params );

  List<EgovMap> getExistCustChs( Map<String, Object> params );

  int editRemarkRequest( Map<String, Object> params );

  void editCCPRemark( Map<String, Object> params );

  void insertCCPRemark( Map<String, Object> params );

  EgovMap getCustCreditInfo( Map<String, Object> params );

  List<EgovMap> getExistUnitHist( Map<String, Object> params );

  List<EgovMap> getNewProdElig( Map<String, Object> params );

  int insertRemarkRequest( Map<String, Object> params );

  EgovMap chkDuplicated( Map<String, Object> params );

  EgovMap getRegisteredCust( Map<String, Object> params );

  List<EgovMap> selectSmsConsentHistory( Map<String, Object> params );

  void updateSmsCount( Map<String, Object> params );

  EgovMap chkSendSmsValidTime( Map<String, Object> params );

  int resetSmsConsent();

  EgovMap chkSmsResetFlag();

  void updateResetFlag( Map<String, Object> params );

  EgovMap getCustInfo( Map<String, Object> params );

  void insertSmsHistory( Map<String, Object> params );

  int resetSmsConsent( Map<String, Object> params );

  int submitConsent( Map<String, Object> params );

  void updateCustomerScore( Map<String, Object> params );

  EgovMap checkStatus( Map<String, Object> params );

  List<EgovMap> selectPreCcpResult( Map<String, Object> params );

  List<EgovMap> selectViewHistory( Map<String, Object> params );

  int insertQuotaMaster( Map<String, Object> params );

  int getCurrVal();

  int insertQuotaDetails( Map<String, Object> params );

  void updateQuotaMaster( Map<String, Object> params );

  void updateCurrentOrgCode( Map<String, Object> params );

  List<EgovMap> selectQuota( Map<String, Object> params );

  List<EgovMap> selectQuotaDetails( Map<String, Object> params );

  int confirmForfeit( Map<String, Object> params );

  int updateRemark( Map<String, Object> params );

  EgovMap chkUpload( Map<String, Object> params );

  EgovMap chkPastMonth( Map<String, Object> params );

  EgovMap chkQuota( Map<String, Object> params );

  List<EgovMap> selectMonthList( Map<String, Object> params );

  List<EgovMap> selectYearList( Map<String, Object> params );

  List<EgovMap> selectViewQuotaDetails( Map<String, Object> params );

  List<EgovMap> selectOrganizationLevel( Map<String, Object> params );

  int confirmTransfer( Map<String, Object> params );

  int getSeqSAL0356D();

  EgovMap currentUser( Map<String, Object> params );

  EgovMap chkSmsResult( Map<String, Object> params );

  EgovMap checkNewCustomerResult( Map<String, Object> params );

  EgovMap chkAvailableQuota( Map<String, Object> params );

  String getCustId( Map<String, Object> params );
}