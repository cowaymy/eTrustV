package com.coway.trust.biz.services.as;

import java.util.List;

import java.util.Map;

import com.coway.trust.api.mobile.services.asFromCody.AsFromCodyDto;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT
 * -----------------------------------------------------------------------------
 * --------------- 01/04/2019 ONGHC 1.0.1 - Restructure File 26/07/2019 ONGHC
 * 1.0.2 - Add Recall Status 17/09/2019 ONGHC 1.0.3 - Add getDftTyp 21/10/2019
 * ONGHC 1.0.4 - Add chkPmtMap 05/10/2020 FARUQ 1.0.5 -Add getAsDefectEntry
 *********************************************************************************************/

public interface ASManagementListService {

	List<EgovMap> selectASManagementList(Map<String, Object> params);

	List<EgovMap> getAsDefectEntry(Map<String, Object> params);

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

	List<EgovMap> selectDefectEntry(Map<String, Object> params);

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

	int isAsAlreadyResult(Map<String, Object> params);

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

	EgovMap checkASCom(Map<String, Object> params);

	EgovMap checkHSStatus(Map<String, Object> params);

	EgovMap checkWarrentyStatus(Map<String, Object> params);

	EgovMap checkSpecialAgreement(Map<String, Object> params);

	List<EgovMap> checkAOASRcdStat(Map<String, Object> params);

	String getInHseLmtDy();

	int selRcdTms(Map<String, Object> params);

	int chkPmtMap(Map<String, Object> params);

	int chkRcdTms(Map<String, Object> params);

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

	int saveASEntryInHouse(Map<String, Object> params);

	List<EgovMap> getDftTyp(Map<String, Object> params);

	ReturnMessage newASInHouseAddSerial(Map<String, Object> params);

	String getSerialChk(Map<String, Object> params);

	int asResultBasic_updateSerial(Map<String, Object> params);

	EgovMap asResult_updateSerial(Map<String, Object> params);

	public int setPay17dData(Map<String, Object> params);

	public int setPay18dData(Map<String, Object> params);

	public int convertAccountToTempBasedOnPayMode(int pMode);

	public int convertTempAccountToSettlementAccount(int p);

	EgovMap selectCustomerInstallationAddress(Map<String, Object> params) throws Exception;

	// Added for INS AS by Hui Ding.
	public int insertSVC0005D(List<EgovMap> addItemList, String AS_RESULT_ID, String UPDATOR);

	public int insertInHouseSVC0004D(Map<String, Object> params);

	public Map<String, Object> setCCR000Data(Map<String, Object> params);

	List<EgovMap> selectWaterSrcType();

	List<EgovMap> selectASNotMatch();

	List<EgovMap> selectReworkProj();

	// void sendSms(Map<String, Object> smsList);

	void insertASResultLog(String params, String reqstUrl, String asId, int userId);

	EgovMap selectSubmissionRecords(Map<String, Object> params) throws Exception;

	List<EgovMap> selectInstallAccWithAsEntryId(Map<String, Object> params);

}
