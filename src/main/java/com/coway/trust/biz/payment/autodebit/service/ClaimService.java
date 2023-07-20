package com.coway.trust.biz.payment.autodebit.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ClaimService {

  /**
   * Auto Debit - Claim List 리스트 조회
   *
   * @param params
   * @return
   */
  List<EgovMap> selectClaimList(Map<String, Object> params);

  /**
   * Auto Debit - Claim Result Deactivate 처리
   *
   * @param params
   */
  void updateDeactivate(Map<String, Object> params);

  /**
   * Auto Debit - Claim 조회
   *
   * @param params
   * @return
   */
  EgovMap selectClaimById(Map<String, Object> params);

  /**
   * Auto Debit - Claim Detail List 리스트 조회Auto Debit - Claim List 리스트 조회
   *
   * @param params
   * @return
   */
  List<EgovMap> selectClaimDetailById(Map<String, Object> params);

  /**
   * Auto Debit - Claim 생성 프로시저 호출
   *
   * @param params
   */
  Map<String, Object> createClaim(Map<String, Object> param);

  /**
   * Auto Debit - Claim 생성 프로시저 호출
   *
   * @param params
   */
  Map<String, Object> createClaimCreditCard(Map<String, Object> param);

  /**
   * Auto Debit - Claim Result Update
   *
   * @param params
   */
  void updateClaimResultItem(Map<String, Object> claimMap, List<Object> resultItemList);

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  EgovMap updateClaimResultItemBulk(Map<String, Object> claimMap, Map<String, Object> cvsParam) throws Exception;

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  EgovMap updateClaimResultItemBulk2(Map<String, Object> claimMap, Map<String, Object> cvsParam) throws Exception;

  /**
   * Auto Debit - Claim Result Update
   *
   * @param params
   */
  void deleteClaimResultItem(Map<String, Object> claimMap);

  /**
   * Auto Debit - Claim Result Update
   *
   * @param params
   */
  void removeItmId(Map<String, Object> claimMap);

  EgovMap selectUploadResultBank(Map<String, Object> claimMap);

  EgovMap selectUploadResultCRC(Map<String, Object> claimMap);

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  void updateClaimResultItemBulk3(Map<String, Object> claimMap, Map<String, Object> cvsParam) throws Exception;

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  void updateClaimResultItemBulk4(Map<String, Object> bulkMap) throws Exception;

  /**
   * Auto Debit - Claim Result Update : New Version
   *
   * @param params
   */
  void updateClaimResultItemArrange(Map<String, Object> claimMap) throws Exception;

  /**
   * Auto Debit - Claim Result Update LIVE
   *
   * @param params
   */
  void updateClaimResultLive(Map<String, Object> claimMap);

  /**
   * Auto Debit - Claim Result Update NEXT DAY
   *
   * @param params
   */
  void updateClaimResultNextDay(Map<String, Object> claimMap);

  /**
   * Auto Debit - CreditCard Result Update LIVE
   *
   * @param params
   */
  void updateCreditCardResultLive(Map<String, Object> claimMap);

  /**
   * Auto Debit - Claim Fail Deduction SMS 상세 리스트 조회
   *
   * @param params
   */
  List<EgovMap> selectFailClaimDetailList(Map<String, Object> param);

  /**
   * Auto Debit - Fail Deduction SMS 재발송 처리
   *
   * @param params
   */
  void sendFaileDeduction(Map<String, Object> params);

  /**
   * Claim List - Schedule Claim Batch Pop-up 리스트 조회
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  List<EgovMap> selectScheduleClaimBatchPop(Map<String, Object> params);

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  List<EgovMap> selectScheduleClaimSettingPop(Map<String, Object> params);

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  int isScheduleClaimSettingPop(Map<String, Object> params);

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 저장
   *
   * @param params
   * @param model
   * @return
   */
  void saveScheduleClaimSettingPop(Map<String, Object> params);

  /**
   * Claim List - Schedule Claim Batch Setting Pop-up 삭제
   *
   * @param params
   * @param model
   * @return
   */
  void removeScheduleClaimSettingPop(Map<String, Object> params);

  /**
   * Claim List - Regenerate CRC File 전체 카운트 조회
   *
   * @param params
   * @return
   */
  int selectClaimDetailByIdCnt(Map<String, Object> params);

  int selectClaimDetailBatchGen(Map<String, Object> params);

  /**
   *
   * @param params
   */
  void deleteClaimFileDownloadInfo(Map<String, Object> claimMap);

  /**
   *
   * @param params
   */
  void insertClaimFileDownloadInfo(Map<String, Object> claimMap);

  /**
   *
   * @param
   * @param params
   * @param model
   * @return
   */
  List<EgovMap> selectClaimFileDown(Map<String, Object> params);

  int selectCCClaimDetailByIdCnt(Map<String, Object> params);

  List<EgovMap> selectMstConf(Map<String, Object> params);

  List<EgovMap> selectSubConf(Map<String, Object> params);

  List<EgovMap> selectClmStat(Map<String, Object> param);

  List<EgovMap> selectListing(Map<String, Object> param);

  List<EgovMap> selectAccBank(Map<String, Object> param);

  String selectBnkCde(String params);

  List<EgovMap> selectVResClaimList(Map<String, Object> params);

  List<EgovMap> selectVResListing(Map<String, Object> param);

  Map<String, Object> createVResClaim(Map<String, Object> param);

  //void saveVRescueUpdate(Map<String, Object> params);

  int  saveVRescueUpdate(Map<String, Object> params);

  int saveM2Upload(Map<String, Object> params,List<Map<String, Object>> list);

  void creditCardClaimMonth2UpateFlag(Map<String, Object> params);

  List<EgovMap> orderListMonthViewPop(Map<String, Object> params);

  Map<String, Object> saveCsvVRescueBulkUpload(Map<String, Object> master, List<Map<String, Object>> detailList);

  List<EgovMap> selectVRescueBulkList(Map<String, Object> param);
  List<EgovMap> selectVRescueBulkDetails(Map<String, Object> param);

  int  saveVRescueBulkConfirm(Map<String, Object> params);
  int selectUnableBulkUploadList(List<String> param) throws Exception;
  List<EgovMap> selectUnableBulkUploadList2(Map<String, Object> params);
}
