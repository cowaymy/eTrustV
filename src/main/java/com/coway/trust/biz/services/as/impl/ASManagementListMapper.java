package com.coway.trust.biz.services.as.impl;

	import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT -------------------------------------------------------------------------------------------- 01/04/2019 ONGHC 1.0.1 - Restructure File 08/05/2019 ONGHC 1.0.2 - Add getFltNm 26/07/2019 ONGHC 1.0.3 - Add Recall Status 05/09/2019 ONGHC 1.0.4 - Create Function for In-House Repair 17/09/2019 ONGHC 1.0.5 - Create getDftTyp 21/10/2019 ONGHC 1.0.6 - Amend chkPmtMap and Un-map Payment Function 17/12/2019 ONGHC 1.0.7 - Add AS Used Filter Feature 05/10/2020 FARUQ 1.0.8 - -Add getAsDefectEntry
 *********************************************************************************************/

@Mapper("ASManagementListMapper")
public interface ASManagementListMapper {

  List<EgovMap> selectASManagementList(Map<String, Object> params);

  List<EgovMap> getAsDefectEntry(Map<String, Object> params);

  EgovMap selectOrderBasicInfo(Map<String, Object> params);

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

  int insertSVC0001D(Map<String, Object> params);

  int insertSVC0108D(Map<String, Object> params);

  int updateSVC0001D(Map<String, Object> params);

  int updateSVC0001D_RCL(Map<String, Object> params);

  int updateStateSVC0001D(Map<String, Object> params);

  int updateAS_TYPE_ID_SVC0001D(Map<String, Object> params);

  int insertSVC0003D(Map<String, Object> params);

  int updateSVC0003D(Map<String, Object> params);

  List<EgovMap> getASOrderInfo(Map<String, Object> params);

  List<EgovMap> getASRclInfo(Map<String, Object> params);

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

  EgovMap asResult_insert(Map<String, Object> params);

  int update_Filter_SAL0087D(Map<String, Object> params);

  int insertSVC0004D(Map<String, Object> params);

  int updateSVC0004DIsCur(Map<String, Object> params);

  int updateSVC0004D(Map<String, Object> params);

  int updateBasicSVC0004D(Map<String, Object> params);

  int updateBasicInhouseSVC0004D(Map<String, Object> params);

  int updateBasicInhouseSVC0001D(Map<String, Object> params);

  int insertSVC0005D(Map<String, Object> params);

  int insertCCR0006D(Map<String, Object> params);

  int insertCCR0007D(Map<String, Object> params);

  int insertAddCCR0007D(Map<String, Object> params);

  int updateCCR0006D(Map<String, Object> params);

  int updateAssignCT(Map<String, Object> params);

  Map<String, Object> callSP_LOGISTIC_REQUEST(Map<String, Object> param);

  EgovMap getASEntryDocNo(Map<String, Object> params);

  EgovMap getCCR0006D_CALL_ENTRY_ID_SEQ(Map<String, Object> params);

  EgovMap getASEntryId(Map<String, Object> params);

  EgovMap getIHREntryId(Map<String, Object> params);

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

  List<EgovMap> getResult_SVC0004D(Map<String, Object> params);

  EgovMap getResult_PAY0016D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0031D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0006D(Map<String, Object> params);

  List<EgovMap> getResult_DocNo_PAY0006D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0007D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0064D(Map<String, Object> params);

  List<EgovMap> getResult_PAY0065D(Map<String, Object> params);

  int reverse_SVC0004D(Map<String, Object> params);

  int reverse_CURR_SVC0004D(Map<String, Object> params);

  int reverse_CURR_SVC0005D(Map<String, Object> params);

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

  List<EgovMap> selectCTByDSC(Map<String, Object> params);

  int deleteInhouseSVC0005D(Map<String, Object> params);

  int updateInhouseSVC0005D(Map<String, Object> params);

  int updateInHouseSVC0004D(Map<String, Object> params);

  int updateInhouseSVC0001D_appdt(Map<String, Object> params);

  int updateState_SERIAL_NO_SVC0004D(Map<String, Object> params);

  int isAsAlreadyResult(Map<String, Object> params);

  int asResultSync(Map<String, Object> params);

  int isInHouseB8Update(Map<String, Object> params);

  String getCustAddressInfo(Map<String, Object> params);

  EgovMap getSmsCTMemberById(Map<String, Object> params);

  EgovMap getSmsCTMMemberById(Map<String, Object> params);

  EgovMap getMemberByMemberIdCode(Map<String, Object> params);

  EgovMap getAsEventInfo(Map<String, Object> params);

  EgovMap selectTaxInvoice(Map<String, Object> params);

  void updateInHouseNOReplaceMentSVC0004D(Map<String, Object> params);

  List<EgovMap> selectSVC0023T(Map<String, Object> params);

  List<EgovMap> selectSVC0024T(Map<String, Object> params);

  List<EgovMap> selectSVC0025T(Map<String, Object> params);

  List<EgovMap> selectSVC0026T(Map<String, Object> params);

  // ONGHC ADD FUNCTION FOR OMBAK MINERAL
  int getFilterCount(Map<String, Object> params);

  List<EgovMap> getfltConfLst();

  int getSAL87ConfigId(String ordNo);

  int insert_SAL0087D(Map<String, Object> params);

  // AS RECEIVED ENTRY POP UP NOTIFICATION -- TPY
  EgovMap checkASReceiveEntry(Map<String, Object> params);

  EgovMap checkASCom(Map<String, Object> params);

  EgovMap checkHSStatus(Map<String, Object> params);

  EgovMap checkWarrentyStatus(Map<String, Object> params);

  EgovMap checkSpecialAgreement(Map<String, Object> params);

  List<EgovMap> checkAOASRcdStat(Map<String, Object> params);

  String getInHseLmtDy();

  int selRcdTms(Map<String, Object> params);

  int chkPmtMap(Map<String, Object> params);

  int bckupPAY0252T(Map<String, Object> params);

  int rmvPAY0252T(Map<String, Object> params);

  int updPAY0081D(Map<String, Object> params);

  int chkRcdTms(Map<String, Object> params);

  String getFltNm(String params);

  String getSearchDtRange();

  List<EgovMap> selectAsTyp();

  List<EgovMap> selectAsStat();

  List<EgovMap> asProd();

  List<EgovMap> selectAsCrtStat();

  List<EgovMap> selectTimePick();

  List<EgovMap> selectLbrFeeChr(Map<String, Object> params);

  List<EgovMap> selectFltQty();

  List<EgovMap> selectFltPmtTyp();

  List<EgovMap> getASEntryCommission(Map<String, Object> params);

  List<EgovMap> getDftTyp(Map<String, Object> params);

  List<EgovMap> getDefectTypSCList(String params);

  List<EgovMap> selectDefectEntry(Map<String, Object> params);

  String getSerialChk(Map<String, Object> params);

  int insertLOG0103M(Map<String, Object> params);

  int reverse_CURR_LOG0103M(Map<String, Object> params);

  // 테스트 임시용.
  int selectTestChk(Map<String, Object> params);

  EgovMap selectCustomerInstallationAddress(Map<String, Object> params) throws Exception;

  int updateSVC0130D(Map<String, Object> params);

List<EgovMap> selectWaterSrcType();

List<EgovMap> selectASNotMatch();

List<EgovMap> selectReworkProj();

void insertASResultLog(Map<String, Object> p);

EgovMap selectSubmissionRecords(Map<String, Object> params);

void disbleInstallAccWithAsEntryId(Map<String, Object> params);

List<EgovMap> selectInstallAccWithAsEntryId(Map<String, Object> params);

EgovMap selectMembershipValidity(Map<String, Object> params); 	// CELESTE [20240828] - New Product External Filter Registration Enhancement

int insert_SAL0423D(Map<String, Object> params); // CELESTE [20240828] - New Product External Filter Registration Enhancement

EgovMap selectStkCatType(Map<String, Object> params);

int updateStatus_SAL0087D(Map<String, Object> params);

int selectExistingPreFilterCount(Map<String, Object> params);

EgovMap selectExistingPreFilterInfo(Map<String, Object> params);

EgovMap selectFilterSerialConfig(Map<String, Object> params) throws Exception;

int getMobileWarehouseByMemID(Map<String, Object> params);

int selectFilterSerial(Map<String, Object> params);

void updateAsFilterSerial(Map<String, Object> params);

int updateSAL0087DFilter_rev(Map<String, Object> params);
}
