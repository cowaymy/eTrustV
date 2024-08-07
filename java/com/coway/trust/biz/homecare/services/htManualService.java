package com.coway.trust.biz.homecare.services;

import java.text.ParseException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface htManualService {

	List<EgovMap> selectHsConfigList(Map<String, Object> params);

	List<EgovMap> selectHsManualList(Map<String, Object> params);

	List<EgovMap> selectHsAssiinlList(Map<String, Object> params);

	List<EgovMap> selectBranchList(Map<String, Object> params);

	List<EgovMap> selectCtList(Map<String, Object> params);

	/* BY KV - Change to textBox -  txtcodyCode and below code no more used.
	List<EgovMap> getCdList(Map<String, Object> params);
	*/

	List<EgovMap> getCdUpMemList(Map<String, Object> params);

	List<EgovMap> getCdDeptList(Map<String, Object> params);

	List<EgovMap> getCdList_1(Map<String, Object> params);

	List<EgovMap> selectHsManualListPop(Map<String, Object> params);

	EgovMap selectHsInitDetailPop(Map<String, Object> params);

	List<EgovMap> cmbCollectTypeComboList(Map<String, Object> params);

	List<EgovMap> cmbCollectTypeComboList2(Map<String, Object> params);

	List<EgovMap> cmbServiceMemList(Map<String, Object> params);

	Map<String, Object> insertHsResult(Map<String, Object> params, List<Object> docType , SessionVO sessionVO);

	Map<String, Object> addIHsResult(Map<String, Object> params,  List<Object> docType, SessionVO sessionVO) throws Exception  ;

	List<EgovMap> selectHsFilterList(Map<String, Object> params);

	EgovMap selectHsViewBasicInfo(Map<String, Object> params);

	List<EgovMap> failReasonList(Map<String, Object> params);

	List<EgovMap> serMemList(Map<String, Object> params);

	List<EgovMap> selectHsViewfilterInfo(Map<String, Object> params);

	EgovMap selectSettleInfo(Map<String, Object> params);

	Map<String, Object> UpdateHsResult(Map<String, Object> formMap, List<Object> docType, SessionVO sessionVO) ;

	List<EgovMap> selectFilterTransaction(Map<String, Object> params);

	List<EgovMap> selectHistoryHSResult(Map<String, Object> params);

	EgovMap selectConfigBasicInfo(Map<String, Object> params);

	int updateHsConfigBasic(Map<String, Object> params, SessionVO sessionVO);

	EgovMap selectHSOrderView(Map<String, Object> params);

	List<EgovMap> selectOrderInactiveFilter(Map<String, Object> params);

	List<EgovMap> selectOrderActiveFilter(Map<String, Object> params);

	String updateAssignCody(Map<String, Object> params);

	List<EgovMap> selectBranch_id(Map<String, Object> params);

	List<EgovMap> selectCTMByDSC_id(Map<String, Object> params);

	EgovMap selectCheckMemCode(Map<String, Object> params);

	EgovMap serMember(Map<String, Object> params);

	List<EgovMap> selectHTMemberList(Map<String, Object> params);

	String getSrvCodyIdbyMemcode(Map<String, Object> params);

	int updateSrvCodyId(Map<String, Object> params);

	List<EgovMap> selectHSAddFilterSetInfo(Map<String, Object> params);

	List<EgovMap> addSrvFilterIdCnt(Map<String, Object> params);

	int updateFilterInfo(Map<String, Object> params, SessionVO sessionVO);

	String getSrvConfigId_SAL009(Map<String, Object> params);

	String getbomPartPriod_LOG0001M(Map<String, Object> params);

	String getSalesDtSAL_0001D(Map<String, Object> params);

	EgovMap getSrvConfigFilter_SAL0087D(Map<String, Object> params);

	int saveHsFilterInfoAdd(Map<String, Object> params);

	int saveDeactivateFilter(Map<String, Object> params);

	int saveFilterUpdate(Map<String, Object> params);

	List<EgovMap> selecthSFilterUseHistorycall(Map<String, Object> params);

	Map<String, Object> UpdateHsResult2(Map<String, Object> formMap, List<Object> docType, SessionVO sessionVO) throws ParseException;


	//add by hgham  mobile 중복 처리
	int isHsAlreadyResult (Map<String, Object> params);

	// Add HS Result - Save Validation
	int saveValidation(Map<String, Object> params);

	EgovMap selectHsOrderInMonth(Map<String, Object> params);

	List<EgovMap> hSMgtResultViewResultFilter(Map<String, Object> params);

	EgovMap hSMgtResultViewResult(Map<String, Object> params);

	List<EgovMap> assignDeptMemUp(Map<String, Object> params);

	List<EgovMap> selectCMList(Map<String, Object> params);


	int hsResultSync (Map<String, Object> params);

	// OMBAK - AS ENTRY RESULT & INVOICE BILLING  -- TPY

	Map<String, Object> saveASEntryResult(Map<String, Object> params);

	EgovMap getBSFilterInfo(Map<String, Object> params);

	Map<String, Object> saveASTaxInvoice(Map<String, Object> params);

	EgovMap checkStkDuration(Map<String, Object> params);

	List<EgovMap> selectDeptCodeList(Map<String, Object> params);

	List<EgovMap> selectDscCodeList(Map<String, Object> params);

	List<EgovMap> selectInsStatusList(Map<String, Object> params);

	List<EgovMap> selectCodyCodeList(Map<String, Object> params);

	List<EgovMap> selectCodyCodeList_1(Map<String, Object> params);

	List<EgovMap> selectAreaCodeList(Map<String, Object> params);

	List<EgovMap> selectHSReportSingle(Map<String, Object> params);

	List<EgovMap> selectHSReportGroup(Map<String, Object> params);

	int updateAssignHT(Map<String, Object> params);

	List<EgovMap> selectHTCodeListByHTCode(Map<String, Object> params);

	int updateHsConfigBasicMultiple(Map<String, Object> params, SessionVO sessionVO);

	EgovMap selectHsOrder1Time(Map<String, Object> params);

	int selectHsOrderTotal1Year(Map<String, Object> params);

	int selectTotalCS(Map<String, Object> params);

	EgovMap selectCSOrderView(Map<String, Object> params);

	EgovMap checkMatOrFra(Map<String, Object> params);

}
