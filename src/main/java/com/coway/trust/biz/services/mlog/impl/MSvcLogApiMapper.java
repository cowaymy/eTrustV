package com.coway.trust.biz.services.mlog.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 10/04/2019    ONGHC      1.0.1       - Amend File Format
 * 29/07/2019    ONGHC      1.0.2       - Add Function
 * 29/07/2019    ONGHC      1.0.3       - Amend productReturnResult to Add Status Checking
 * 13/08/2019    ONGHC      1.0.4       - Add updFctExch
 * 27/11/2019    ONGHC      1.0.5       - Add Function
 * 22/04/2020    ONGHC      1.0.6       - Create getRelateOrdLst
 * 23/04/2019    ONGHC      1.0.7       - Add function getOrdDetail
 * 29/04/2020    ONGHC      1.0.8       - Add function insertSVC0115D
 * 03/04/2023    FANNIE      1.0.9       - Add function getCustAddDtlLst and updateGPS
 *********************************************************************************************/

@Mapper("MSvcLogApiMapper")
public interface MSvcLogApiMapper {

  List<EgovMap> getHeartServiceJobList(Map<String, Object> params);

  List<EgovMap> getAfterServiceJobList(Map<String, Object> params);

  void insertHeatLog(Map<String, Object> log);

  void updateSuccessStatus(String transactionId);

  List<EgovMap> heartServiceParts(Map<String, Object> params);

  List<EgovMap> afterServiceParts(Map<String, Object> params);

  int getNextSvc006dSeq();

  void insertHsResultD(Map<String, Object> insMap);

  void insertHsResultSAL0090D(Map<String, Object> insMap);

  void insertHsResultSVC0006D(Map<String, Object> insMap);

  int selectHSScheduleMCnt(Map<String, Object> insMap);

  EgovMap selectHSResultMList(Map<String, Object> insMap);

  void updateHsSVC0008D(Map<String, Object> insMap);

  EgovMap selectSrvConfiguration(Map<String, Object> insMap);

  EgovMap selectHsAssiinlList(Map<String, Object> insMap);

  String getUseridToMemid(Object object);

  List<EgovMap> getInstallationJobList(Map<String, Object> params);

  List<EgovMap> getProductRetrunJobList(Map<String, Object> params);

  void insertAsResultLog(Map<String, Object> asTransLog);

  void updateSuccessASStatus(String transactionId);

  void updateSuccessInstallStatus(String transactionId);

  void updateSuccessErrInstallStatus(String transactionId);

  void insertInstallServiceLog(Map<String, Object> params);

  EgovMap getInstallResultByInstallEntryID(Map<String, Object> params);

  void insertInstallResult(Map<String, Object> installResult);

  List<EgovMap> getRentalCustomerList(Map<String, Object> params);

  List<EgovMap> serviceHistory(Map<String, Object> params);

  List<EgovMap> getFilterHistoryDList(Map<String, Object> params);

  List<EgovMap> getPartsHistoryDList(Map<String, Object> params);

  List<EgovMap> getHsPartsHistoryDList(Map<String, Object> params);

  List<EgovMap> getHsFilterHistoryDList(Map<String, Object> params);

  List<EgovMap> getAsPartsHistoryDList(Map<String, Object> params);

  List<EgovMap> getAsFilterHistoryDList(Map<String, Object> params);

  EgovMap selectOutstandingResult(Map<String, Object> params);

  List<EgovMap> selectOutstandingResultDetailList(Map<String, Object> params);

  Map<String, Object> getAsBasic(Map<String, Object> params);

  void insertAsReServiceLog(Map<String, Object> params);

  void insertAsReServiceLog(String transactionId);

  void insertHsReServiceLog(String transactionId);

  void insertInsReServiceLog(String transactionId);

  void insertHsReServiceLog(Map<String, Object> params);

  void insertInsReServiceLog(Map<String, Object> params);

  void insertPrReServiceLog(Map<String, Object> params);

  Map<String, Object> getHsBasic(Map<String, Object> params);

  void insertPrFailServiceLog(Map<String, Object> params);

  void insertInssFailServiceLog(Map<String, Object> params);

  void insertAsFailServiceLog(Map<String, Object> params);

  void insertHsFailServiceLog(Map<String, Object> params);

  void insertCanSMSServiceLog(Map<String, Object> params);

  void updateReApointResult(Map<String, Object> params);

  EgovMap selectAsBasicInfo(Map<String, Object> params);

  void updateInsReAppointmentReturnResult(Map<String, Object> params);

  void updateHsReAppointmentReturnResult(Map<String, Object> params);

  void updatePrReAppointmentReturnResult(Map<String, Object> params);

  void insertASRequestRegistrationLogs(Map<String, Object> params);

  void updateSuccessRequestRegiStatus(String transactionId);

  void insertASRequestRegist(Map<String, Object> params);

  void insertHsFailJobResult(Map<String, Object> params);

  void insertAsFailJobResult(Map<String, Object> params);

  void insertInstallFailJobResult(Map<String, Object> params);

  List<EgovMap> getASRequestResultList(Map<String, Object> params);

  List<EgovMap> getASRequestCustList(Map<String, Object> params);

  void upDateHsFailJobResultM(Map<String, Object> params);

  void upDatetAsFailJobResultM(Map<String, Object> params);

  void upDateInstallFailJobResultM(Map<String, Object> params);

  void insertInsFailServiceLog(Map<String, Object> params);

  void updateInsFailServiceLog(int resultSeq);

  int updateState_LOG0038D(Map<String, Object> params);

  int updateState_SAL0001D(Map<String, Object> params);

  int insert_SAL0009D(Map<String, Object> params);

  int updateState_SAL0020D(Map<String, Object> params);

  int updateState_SAL0071D(Map<String, Object> params);

  int insert_SVC0026T(Map<String, Object> params);

  int insert_LOG0039D(Map<String, Object> params);

  int updateAppTm_LOG0038D(Map<String, Object> params);

  int insertFailed_LOG0039D(Map<String, Object> params);

  int updateFailed_LOG0038D(Map<String, Object> params);

  //EgovMap selectPRFailReason(Map<String, Object> params);

  int isPrdRtnAlreadyResult(Map<String, Object> params);

  int updFctExch(Map<String, Object> params);

  void updateSuccessPrdRtnStatus(String transactionId);

  String getRetnCrtUserId(Map<String, Object> params);

  void insertCancelSMS(Map<String, Object> params);

  String getcancReqNo(Map<String, Object> params);

  List<EgovMap> getHeartServiceJobList_b(Map<String, Object> params);

  List<EgovMap> getAfterServiceJobList_b(Map<String, Object> params);

  List<EgovMap> heartServiceParts_b(Map<String, Object> params);

  List<EgovMap> afterServiceParts_b(Map<String, Object> params);

  List<EgovMap> getInstallationJobList_b(Map<String, Object> params);

  List<EgovMap> getProductRetrunJobList_b(Map<String, Object> params);

  void SP_RETURN_BILLING_EARLY_TERMI(Map<String, Object> params);

  String getInstallDate(Map<String, Object> insApiresult);

  void insert_CCR0006D(Map<String, Object> params);

  String select_SeqCCR0006D(Map<String, Object> params);

  String select_SeqCCR0007D(Map<String, Object> params);

  void insert_CCR0007D(Map<String, Object> params);

  void updateFailed_SAL0020D(Map<String, Object> params);

  void updateErrStatus(String transactionId);

  void updateASErrStatus(String transactionId);

  void updatePRErrStatus(String transactionId);

  void updatePRStatus(String transactionId);

  int insert_SVC0066T(Map<String, Object> params);

  int prdResultSync(Map<String, Object> params);

  EgovMap newSearchCancelSAL0001D(Map<String, Object> params);

  int chkSubPromo(Map<String, Object> params);

  int chkMainPromo(Map<String, Object> params);

  EgovMap revSubCboPckage(Map<String, Object> params);

  EgovMap revMainCboPckage(Map<String, Object> params);

  void insertSAL0254D(Map<String, Object> params);

  List<EgovMap> getCareServiceJobList_b(Map<String, Object> params);

  List<EgovMap> getCareServiceParts_b(Map<String, Object> params);

  List<EgovMap> getCareServiceJobList(Map<String, Object> params);

  List<EgovMap> getHcServiceJobList(Map<String, Object> params);

  void updateHTReAppointmentReturnResult(Map<String, Object> params);

  void updateHtFailJobResult(Map<String, Object> params);

  void upDateHtFailJobResultM(Map<String, Object> params);

  Map<String, Object> getHtBasic(Map<String, Object> params);

  List<EgovMap> hcServiceHistory(Map<String, Object> params);

  int selectSVC0008DSchdulId(Map<String, Object> params);

  EgovMap SP_SVC_BARCODE_SAVE(Map<String, Object> params);

  EgovMap SP_SVC_BARCODE_CHANGE(Map<String, Object> params);

  List<EgovMap> selectSerialList(Map<String, Object> params);

  EgovMap getOrdID(Map<String, Object> params);

  List<EgovMap> getDtInstallationJobList(Map<String, Object> params);

  EgovMap getFraOrdInfo(Map<String, Object> params);

  void updateInsDtReAppointmentReturnResult(Map<String, Object> params);

  EgovMap getPrdRtnDelvryNo(Map<String, Object> params);

  EgovMap getPrFraOrdInfo(Map<String, Object> params);

  String getBeforeProductSerialNo(Map<String, Object> params);

  EgovMap getDelvryNo(Map<String, Object> params);

  List<EgovMap> getRelateOrdLst(Map<String, Object> params);

  List<EgovMap> getOrdDetail(Map<String, Object> params);

  void insertSVC0115D(Map<String, Object> params);

  String selectSVC0115D(Map<String, Object> params);

  List<EgovMap> searchRentalCollectionByBSNewList(Map<String, Object> params);

  Map<String, Object> getCustAddDtlLst(Map<String, Object> params);

  void updateGps(Map<String, Object> params);

  EgovMap selectAsDetails (Map<String, Object> params);

  List<EgovMap> getCustNRIC(Map<String, Object> params);

  void saveErrorToDatabase(Map<String, Object> e);

}
