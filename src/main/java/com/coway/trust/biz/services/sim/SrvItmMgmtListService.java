package com.coway.trust.biz.services.sim;

import java.util.List;

import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 01/04/2019    ONGHC      1.0.1       - Restructure File
 * 29/08/2019    ONGHC      1.0.2       - Enhance to Support DSC Branch
 *********************************************************************************************/

public interface SrvItmMgmtListService {
  List<EgovMap> getBchTyp(Map<String, Object> params);

  List<EgovMap> getBch(Map<String, Object> params);

  List<EgovMap> getItm(Map<String, Object> params);

  List<EgovMap> searchSrvItmLst(Map<String, Object> params);

  String getBchTypDesc(String params);

  String getBrTypId(String params);

  String getBchDesc(String params);

  String getItmCde(String params);

  String getItmDesc(String params);

  String getBrTypDesc(String params);

  List<EgovMap> getSrvItmRcd(Map<String, Object> params);

  List<EgovMap> getMovTyp(Map<String, Object> params);

  List<EgovMap> getMovDtl(Map<String, Object> params);

  EgovMap insertSrvItm(Map<String, Object> params);

  int deactivateLog91d(Map<String, Object> params);
  /*
  List<EgovMap> selectASManagementList(Map<String, Object> params);

  List<EgovMap> getASHistoryList(Map<String, Object> params);

  List<EgovMap> selectASDataInfo(Map<String, Object> params);

  List<EgovMap> getErrMstList(Map<String, Object> params);

  List<EgovMap> getErrDetilList(Map<String, Object> params);

  List<EgovMap> getSLUTN_CODE_List(Map<String, Object> params);

  List<EgovMap> getDTAIL_DEFECT_List(Map<String, Object> params);

  List<EgovMap> getDEFECT_PART_List(Map<String, Object> params);

  List<EgovMap> getDEFECT_CODE_List(Map<String, Object> params);

  List<EgovMap> getDEFECT_TYPE_List(Map<String, Object> params);

  List<EgovMap> getBSHistoryList(Map<String, Object> params);

  List<EgovMap> getBrnchId(Map<String, Object> params);

  EgovMap getMemberBymemberID(Map<String, Object> params);

  EgovMap selectOrderBasicInfo(Map<String, Object> params);

  EgovMap getASEntryId(Map<String, Object> params);

  EgovMap getResultASEntryId(Map<String, Object> params);

  EgovMap selASEntryView(Map<String, Object> params);

  EgovMap getASEntryDocNo(Map<String, Object> params);

  EgovMap saveASEntry(Map<String, Object> params);

  EgovMap saveASInHouseEntry(Map<String, Object> params);

  EgovMap spFilterClaimCheck(Map<String, Object> params);

  EgovMap updateASEntry(Map<String, Object> params);

  EgovMap updateASInHouseEntry(Map<String, Object> params);

  List<EgovMap> getASOrderInfo(Map<String, Object> params);

  List<EgovMap> getASEvntsInfo(Map<String, Object> params);

  List<EgovMap> getASHistoryInfo(Map<String, Object> params);

  List<EgovMap> getASStockPrice(Map<String, Object> params);

  List<EgovMap> getASFilterInfo(Map<String, Object> params);

  List<EgovMap> getASFilterInfoOld(Map<String, Object> params);

  List<EgovMap> getASReasonCode(Map<String, Object> params);

  List<EgovMap> getASMember(Map<String, Object> params);

  List<EgovMap> getASReasonCode2(Map<String, Object> params);

  List<EgovMap> getCallLog(Map<String, Object> params);

  List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params);

  List<EgovMap> getASRulstEditFilterInfo(Map<String, Object> params);

  boolean insertASNo(Map<String, Object> params, SessionVO sessionVO);

  EgovMap asResult_insert(Map<String, Object> params);

  EgovMap asResult_update(Map<String, Object> params);

  EgovMap asResult_update_1(Map<String, Object> params);

  int asResultBasic_update(Map<String, Object> params);

  int addASRemark(Map<String, Object> params);

  int updateAssignCT(Map<String, Object> params);

  List<EgovMap> assignCtOrderList(Map<String, Object> params);

  List<EgovMap> assignCtList(Map<String, Object> params);

  List<EgovMap> selectCTByDSC(Map<String, Object> params);

  // add by hgham mobile 중복 처리
  int isAsAlreadyResult(Map<String, Object> params);

  // add by hgham mobile 중복 처리
  int asResultSync(Map<String, Object> params);

  String getCustAddressInfo(Map<String, Object> params);

  EgovMap getSmsCTMemberById(Map<String, Object> params);

  EgovMap getSmsCTMMemberById(Map<String, Object> params);

  EgovMap getMemberByMemberIdCode(Map<String, Object> params);

  EgovMap getAsEventInfo(Map<String, Object> params);

  List<EgovMap> selectSVC0023T(Map<String, Object> params);

  List<EgovMap> selectSVC0024T(Map<String, Object> params);

  List<EgovMap> selectSVC0025T(Map<String, Object> params);

  List<EgovMap> selectSVC0026T(Map<String, Object> params);

  EgovMap getStockPricebyStkID(Map<String, Object> params);

  // ONGHC ADD FUNCTION FOR OMBAK MINERAL
  boolean insertOptFlt(Map<String, Object> params);

  List<EgovMap> getfltConfLst();

  int getFilterCount(Map<String, Object> params);

  int getSAL87ConfigId(String params);

  int insert_SAL0087D(Map<String, Object> params);

  EgovMap checkASReceiveEntry(Map<String, Object> params);

  EgovMap checkHSStatus(Map<String, Object> params);

  EgovMap checkWarrentyStatus(Map<String, Object> params);

  List<EgovMap> checkAOASRcdStat(Map<String, Object> params);

  String getInHseLmtDy();

  int selRcdTms(Map<String, Object> params);

  int chkRcdTms(Map<String, Object> params); */
}
