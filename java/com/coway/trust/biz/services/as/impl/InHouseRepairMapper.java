package com.coway.trust.biz.services.as.impl;

	import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 05/09/2019    ONGHC      1.0.1       - CREATE FOR IN-HOUSE REPAIR
 * 17/12/2019    ONGHC      1.0.2       - Add AS Used Filter Feature
 *********************************************************************************************/

@Mapper("InHouseRepairMapper")
public interface InHouseRepairMapper {

  List<EgovMap> selInhouseList(Map<String, Object> params);

  List<EgovMap> selInhouseDetailList(Map<String, Object> params);

  List<EgovMap> getASRulstSVC0109DInfo(Map<String, Object> params);

  List<EgovMap> getCallLog(Map<String, Object> params);

  List<EgovMap> getProductMasters(Map<String, Object> params);

  List<EgovMap> getProductDetails(Map<String, Object> params);

  EgovMap isAbStck(Map<String, Object> params);

  List<EgovMap> selectIHRManagementList(Map<String, Object> params);

  List<EgovMap> selectCTByDSC(Map<String, Object> params);

  EgovMap getAsEventInfo(Map<String, Object> params);

  List<EgovMap> getASOrderInfo(Map<String, Object> params);

  List<EgovMap> getASEvntsInfo(Map<String, Object> params);

  EgovMap selectOrderBasicInfo(Map<String, Object> params);

  String getSearchDtRange();

  List<EgovMap> selectAsTyp();

  List<EgovMap> selectAsStat();

  List<EgovMap> selectAsCrtStat();

  List<EgovMap> selectTimePick();

  List<EgovMap> selectLbrFeeChr(Map<String, Object> params);

  List<EgovMap> selectFltQty();

  List<EgovMap> selectFltPmtTyp();


  List<EgovMap> selectASManagementList(Map<String, Object> params);

  List<EgovMap> getErrMstList(Map<String, Object> params);

  List<EgovMap> getErrDetilList(Map<String, Object> params);

  List<EgovMap> getSLUTN_CODE_List(Map<String, Object> params);

  List<EgovMap> getDTAIL_DEFECT_List(Map<String, Object> params);

  List<EgovMap> getDEFECT_PART_List(Map<String, Object> params);

  List<EgovMap> getDEFECT_CODE_List(Map<String, Object> params);

  List<EgovMap> getDEFECT_TYPE_List(Map<String, Object> params);

  List<EgovMap> selectASDataInfo(Map<String, Object> params);

  List<EgovMap> getASHistoryList(Map<String, Object> params);

  List<EgovMap> getBSHistoryList(Map<String, Object> params);

  List<EgovMap> getBrnchId(Map<String, Object> params);

  EgovMap getMemberBymemberID(Map<String, Object> params);

  EgovMap spFilterClaimCheck(Map<String, Object> params);

  EgovMap selectStkPriceByStkID(Map<String, Object> params);

  EgovMap selASEntryView(Map<String, Object> params);

  int insertSVC0108D(Map<String, Object> params);

  int updateSVC0108D(Map<String, Object> params);

  int updateSVC0108D_RCL(Map<String, Object> params);

  int updateStateSVC0108D(Map<String, Object> params);

  int updateAS_TYPE_ID_SVC0108D(Map<String, Object> params);

  int insertSVC0003D(Map<String, Object> params);

  int updateSVC0003D(Map<String, Object> params);

  List<EgovMap> getASRclInfo(Map<String, Object> params);

  List<EgovMap> getASHistoryInfo(Map<String, Object> params);

  List<EgovMap> getIHRHistoryInfo(Map<String, Object> params);

  List<EgovMap> getASStockPrice(Map<String, Object> params);

  List<EgovMap> getASFilterInfo(Map<String, Object> params);

  List<EgovMap> getASFilterInfoOld(Map<String, Object> params);

  List<EgovMap> getASReasonCode(Map<String, Object> params);

  List<EgovMap> getASMember(Map<String, Object> params);

  List<EgovMap> getASReasonCode2(Map<String, Object> params);

  List<EgovMap> getASRulstEditFilterInfo(Map<String, Object> params);

  EgovMap asResult_insert(Map<String, Object> params);

  int update_Filter_SAL0087D(Map<String, Object> params);

  int insertSVC0109D(Map<String, Object> params);

  int updateSVC0109DIsCur(Map<String, Object> params);

  int updateSVC0109D(Map<String, Object> params);

  int updateBasicSVC0109D(Map<String, Object> params);

  int updateBasicInhouseSVC0109D(Map<String, Object> params);

  int updateBasicInhouseSVC0108D(Map<String, Object> params);

  int insertSVC0110D(Map<String, Object> params);

  int insertCCR0006D(Map<String, Object> params);

  int insertCCR0007D(Map<String, Object> params);

  int insertAddCCR0007D(Map<String, Object> params);

  int updateCCR0006D(Map<String, Object> params);

  int updateAssignCT(Map<String, Object> params);

  Map<String, Object> callSP_LOGISTIC_REQUEST(Map<String, Object> param);

  EgovMap getASEntryDocNo(Map<String, Object> params);

  EgovMap getCCR0006D_CALL_ENTRY_ID_SEQ(Map<String, Object> params);

  EgovMap getASEntryId(Map<String, Object> params);

  EgovMap getResultASEntryId(Map<String, Object> params);

  List<EgovMap> assignCtList(Map<String, Object> params);

  List<EgovMap> assignCtOrderList(Map<String, Object> params);

  EgovMap geTtotalAASLeft(Map<String, Object> params);

  EgovMap geGST_CHK(Map<String, Object> params);

  int insert_Pay0031d(Map<String, Object> params);

  int insert_Pay0032d(Map<String, Object> params);

  int insert_Pay0016d(Map<String, Object> params);

  int insert_Pay0006d(Map<String, Object> params);

  int insert_Pay0007d(Map<String, Object> params);

  int insert_Ccr0001d(Map<String, Object> params);

  int updateSTATE_CCR0006D(Map<String, Object> params);

  EgovMap getPAY0017SEQ(Map<String, Object> params);

  EgovMap getLOG0015DSEQ(Map<String, Object> params);

  EgovMap getPAY0016DSEQ(Map<String, Object> params);

  EgovMap getPAY0017DSEQ(Map<String, Object> params);

  EgovMap getPAY0027DSEQ(Map<String, Object> params);

  EgovMap getPAY0069DSEQ(Map<String, Object> params);

  EgovMap getPAY0064DSEQ(Map<String, Object> params);

  EgovMap getPAY0065DSEQ(Map<String, Object> params);

  List<EgovMap> getResult_SVC0109D(Map<String, Object> params);

  EgovMap getResult_PAY0016D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0031D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0006D(Map<String, Object> params);

  List<EgovMap> getResult_DocNo_PAY0006D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0007D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0064D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0065D(Map<String, Object> params);

  int reverse_SVC0109D(Map<String, Object> params);

  int reverse_CURR_SVC0109D(Map<String, Object> params);

  int reverse_CURR_SVC0110D(Map<String, Object> params);

  int insert_LOG0015D(Map<String, Object> params);

  int insert_LOG0016D(Map<String, Object> params);

  int insert_stkCardLOG0014D(Map<String, Object> params);

  int insert_LOG0014D(Map<String, Object> params);

  int insert_PAY0069D(Map<String, Object> params);

  int insert_PAY0064D(Map<String, Object> params);

  int insert_PAY0065D(Map<String, Object> params);

  int insert_PAY0009D(Map<String, Object> params);

  int insert_Pay0018d(Map<String, Object> params);

  int insert_Pay0017d(Map<String, Object> params);

  int update_SAL0087D(Map<String, Object> params);

  int reverse_PAY0007D(Map<String, Object> params);

  int reverse_PAY0016D(Map<String, Object> params);

  int reverse_PAY0012D(Map<String, Object> params);

  int reverse_PAY0027D(Map<String, Object> params);

  int reverse_PAY0028D(Map<String, Object> params);

  int reverse_PAY0006D(Map<String, Object> params);

  int reverse_DocNo_PAY0006D(Map<String, Object> params);

  int reverse_StateUpPAY0007D(Map<String, Object> params);

  int reverse_State_CCR0001D(Map<String, Object> params);

  int reverse_updatePAY0016D(Map<String, Object> params);

  EgovMap getLog0016DCount(Map<String, Object> params);

  int deleteInhouseSVC0110D(Map<String, Object> params);

  int updateInhouseSVC0110D(Map<String, Object> params);

  int updateInHouseSVC0109D(Map<String, Object> params);

  int updateInhouseSVC0108D_appdt(Map<String, Object> params);

  int updateState_SERIAL_NO_SVC0109D(Map<String, Object> params);

  int isAsAlreadyResult(Map<String, Object> params);

  int asResultSync(Map<String, Object> params);

  int isInHouseB8Update(Map<String, Object> params);

  String getCustAddressInfo(Map<String, Object> params);

  EgovMap getSmsCTMemberById(Map<String, Object> params);

  EgovMap getSmsCTMMemberById(Map<String, Object> params);

  EgovMap getMemberByMemberIdCode(Map<String, Object> params);

  EgovMap selectTaxInvoice(Map<String, Object> params);

  void updateInHouseNOReplaceMentSVC0109D(Map<String, Object> params);

  List<EgovMap> selectSVC0023T(Map<String, Object> params);

  List<EgovMap> selectSVC0024T(Map<String, Object> params);

  List<EgovMap> selectSVC0025T(Map<String, Object> params);

  List<EgovMap> selectSVC0026T(Map<String, Object> params);

  int getFilterCount(Map<String, Object> params);

  List<EgovMap> getfltConfLst();

  int getSAL87ConfigId(String ordNo);

  int insert_SAL0087D(Map<String, Object> params);

  EgovMap checkASReceiveEntry(Map<String, Object> params);

  EgovMap checkHSStatus(Map<String, Object> params);

  EgovMap checkWarrentyStatus(Map<String, Object> params);

  List<EgovMap> checkAOASRcdStat(Map<String, Object> params);

  String getInHseLmtDy();

  int selRcdTms(Map<String, Object> params);

  int chkRcdTms(Map<String, Object> params);

  String getFltNm(String params);

  List<EgovMap> getASEntryCommission(Map<String, Object> params);

  int insertLOG0103M(Map<String, Object> params);

  int reverse_CURR_LOG0103M(Map<String, Object> params);
}
