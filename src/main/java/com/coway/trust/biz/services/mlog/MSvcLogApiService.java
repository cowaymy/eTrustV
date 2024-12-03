package com.coway.trust.biz.services.mlog;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.services.heartService.HeartServiceResultForm;
import com.coway.trust.api.mobile.services.history.AsDetailDto;
import com.coway.trust.api.mobile.services.history.AsDetailForm;
import com.coway.trust.api.mobile.services.sales.RentalServiceCustomerDto;
import com.coway.trust.cmmn.model.SessionVO;
import com.google.gson.JsonObject;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 10/04/2019    ONGHC      1.0.1       - Amend File Format
 * 29/07/2019    ONGHC      1.0.2       - Add Function
 * 29/07/2019    ONGHC      1.0.3       - Amend productReturnResult to Add Status Checking
 * 13/08/2019    ONGHC      1.0.4       - Add updFctExch
 * 22/04/2020    ONGHC      1.0.5       - Create getRelateOrdLst
 * 23/04/2020    ONGHC      1.0.6       - Add function getOrdDetail
 * 29/04/2020    ONGHC      1.0.7       - Add function insertSVC0115D
 * 03/04/2023    FANNIE      1.0.8       - Add function updateGPS
 *********************************************************************************************/

public interface MSvcLogApiService {

  AsDetailDto selectAsDetails(AsDetailForm param) throws Exception;

  List<EgovMap> getHeartServiceJobList(Map<String, Object> params);

  List<EgovMap> getAfterServiceJobList(Map<String, Object> params);

  void saveHearLogs(List<Map<String, Object>> heartLogs);

  void updateSuccessStatus(String transactionId);

  List<EgovMap> heartServiceParts(Map<String, Object> params);

  List<EgovMap> afterServiceParts(Map<String, Object> params);

  void resultRegistration(List<Map<String, Object>> heartLogs);

  List<EgovMap> getInstallationJobList(Map<String, Object> params);

  List<EgovMap> getProductRetrunJobList(Map<String, Object> params);

  void saveAfterServiceLogs(List<Map<String, Object>> asTransLogs);

  void updateSuccessASStatus(String transactionId);

  void saveInstallServiceLogs(Map<String, Object> params);

  void updateSuccessInstallStatus(String transactionId);

  void updateSuccessErrInstallStatus(String transactionId);

  void insertInstallationResult(Map<String, Object> params);

  void aSresultRegistration(List<Map<String, Object>> asTransLogs);

  List<EgovMap> serviceHistory(Map<String, Object> params);

  List<EgovMap> getAsFilterHistoryDList(Map<String, Object> tmpMap);

  List<EgovMap> getAsPartsHistoryDList(Map<String, Object> tmpMap);

  List<EgovMap> getHsPartsHistoryDList(Map<String, Object> tmpMap);

  List<EgovMap> getHsFilterHistoryDList(Map<String, Object> tmpMap1);

  List<EgovMap> getRentalCustomerList(Map<String, Object> params);

  Map<String, Object> selectOutstandingResult(Map<String, Object> params);

  List<EgovMap> selectOutstandingResultDetailList(Map<String, Object> params);

  Map<String, Object> getAsBasic(Map<String, Object> params);

  void saveAsReServiceLogs(Map<String, Object> params);

  void updateSuccessAsReStatus(String transactionId);

  void updateSuccessHsReStatus(String transactionId);

  void updateSuccessInsReStatus(String transactionId);

  EgovMap getInstallResultByInstallEntryID(Map<String, Object> params);

  String getUseridToMemid(Map<String, Object> params);

  void savePrFailServiceLogs(Map<String, Object> params);

  void saveInsFailServiceLogs(Map<String, Object> params);

  /* Woongjin Jun */
  void updateSuccessInsFailServiceLogs(int resultSeq);

  void saveAsFailServiceLogs(Map<String, Object> params);

  void saveHsFailServiceLogs(Map<String, Object> params);

  void savePrReServiceLogs(Map<String, Object> params);

  void saveInsReServiceLogs(Map<String, Object> params);

  void saveHsReServiceLogs(Map<String, Object> params);

  Map<String, Object> getHsBasic(Map<String, Object> params);

  void saveCanSMSServiceLogs(Map<String, Object> params);

  void updateReApointResult(Map<String, Object> params);

  EgovMap selectAsBasicInfo(Map<String, Object> params);

  void updateInsReAppointmentReturnResult(Map<String, Object> params);

  void updateHsReAppointmentReturnResult(Map<String, Object> params);

  void updatePrReAppointmentReturnResult(Map<String, Object> params);

  void saveASRequestRegistrationLogs(Map<String, Object> params);

  void updateSuccessRequestRegiStatus(String transactionId);

  void insertASRequestRegist(Map<String, Object> params);

  void insertHsFailJobResult(Map<String, Object> params);

  void insertAsFailJobResult(Map<String, Object> params);

  void insertInstallFailJobResult(Map<String, Object> params);

  List<EgovMap> getASRequestResultList(Map<String, Object> map);

  List<EgovMap> getASRequestCustList(Map<String, Object> map);

  void upDateHsFailJobResultM(Map<String, Object> params);

  void upDatetAsFailJobResultM(Map<String, Object> params);

  void upDateInstallFailJobResultM(Map<String, Object> params);

  EgovMap productReturnResult(Map<String, Object> params);

  void setPRFailJobRequest(Map<String, Object> params);

  void insertCancelSMS(Map<String, Object> params);

  String getcancReqNo(Map<String, Object> params);

  List<EgovMap> getHeartServiceJobList_b(Map<String, Object> params);

  List<EgovMap> getAfterServiceJobList_b(Map<String, Object> params);

  List<EgovMap> getInstallationJobList_b(Map<String, Object> params);

  List<EgovMap> getProductRetrunJobList_b(Map<String, Object> params);

  List<EgovMap> heartServiceParts_b(Map<String, Object> params);

  List<EgovMap> afterServiceParts_b(Map<String, Object> params);

  void SP_RETURN_BILLING_EARLY_TERMI(Map<String, Object> params);

  void updateInsFailServiceLogs(Map<String, Object> params);

  String getInstallDate(Map<String, Object> insApiresult);

  void updateErrStatus(String transactionId);

  void updateASErrStatus(String transactionId);

  void updatePRErrStatus(String transactionId);

  void updatePRStatus(String transactionId);

  int insert_SVC0066T(Map<String, Object> params);

  void insert_SVC0026T(Map<String, Object> params);

  int prdResultSync(Map<String, Object> params);

  int isPrdRtnAlreadyResult(Map<String, Object> params);

  int updFctExch(Map<String, Object> params);

  List<EgovMap> getCareServiceJob_b(Map<String, Object> params);

  List<EgovMap> getCareServiceParts_b(Map<String, Object> params);

  /* Woongjin Jun */
  List<EgovMap> getCareServiceJobList(Map<String, Object> params);

  List<EgovMap> getHcServiceJobList(Map<String, Object> params);

  void updateHTReAppointmentReturnResult(Map<String, Object> params);

  void insertHtFailJobResult(Map<String, Object> params, SessionVO sessionVO);

  void upDateHtFailJobResultM(Map<String, Object> params);

  EgovMap SP_SVC_BARCODE_SAVE(Map<String, Object> params);

  EgovMap SP_SVC_BARCODE_CHANGE(Map<String, Object> params);

  Map<String, Object> getHtBasic(Map<String, Object> params);

  List<EgovMap> hcServiceHistory(Map<String, Object> params);

  List<EgovMap> selectSerialList(Map<String, Object> params);

  EgovMap getOrdID(Map<String, Object> params);

  List<EgovMap> getDtInstallationJobList(Map<String, Object> params);

  EgovMap getFraOrdInfo(Map<String, Object> params);

  void updateInsDtReAppointmentReturnResult(Map<String, Object> params);

  EgovMap getPrdRtnDelvryNo(Map<String, Object> params);

  EgovMap getPrFraOrdInfo(Map<String, Object> params);

  String getBeforeProductSerialNo(Map<String, Object> params);
  /* Woongjin Jun */

  /* Woongjin Han */
  EgovMap getDelvryNo(Map<String, Object> params);
  /* Woongjin Han */

  List<EgovMap> getRelateOrdLst(Map<String, Object> params);

  List<EgovMap> getOrdDetail(Map<String, Object> params);

  void insertSVC0115D(Map<String, Object> params);

  //void sendSms(Map<String, Object> smsList);

  String selectSVC0115D(Map<String, Object> params);

  List<EgovMap> searchRentalCollectionByBSNewList(Map<String, Object> params);

  JsonObject updateGPS (Map<String, Object> params);

  List<EgovMap> getCustNRIC(Map<String, Object> params);

  void saveErrorToDatabase(Map<String, Object> e);
}
