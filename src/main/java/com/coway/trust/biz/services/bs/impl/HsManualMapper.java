package com.coway.trust.biz.services.bs.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hsManualMapper")
public interface HsManualMapper {

	List<EgovMap> selectHsConfigList(Map<String, Object> params);

	List<EgovMap> selectHsManualList(Map<String, Object> params);

	List<EgovMap> selectHsAssiinlList(Map<String, Object> params);

	EgovMap selectHsAssiinlList_1(Map<String, Object> params);

	List<EgovMap> selectBranchList(Map<String, Object> params);

	List<EgovMap> selectCtList(Map<String, Object> params);

	List<EgovMap> getCdList(Map<String, Object> params);

	List<EgovMap> getCdUpMemList(Map<String, Object> params);

	List<EgovMap> getCdDeptList(Map<String, Object> params);

	List<EgovMap> getCdList_1(Map<String, Object> params);

	List<EgovMap> selectHsManualListPop(Map<String, Object> params);

	EgovMap selectHSResultMList(Map<String, Object> params);

	void insertHsResult(Map<String, Object> params);

	void updateHsScheduleM(Map<String, Object> params);

	int getNextSchdulId();

	int getNextSvc006dSeq();

	EgovMap selectHsInitDetailPop(Map<String, Object> params);

	void insertHsResultfinal(Map<String, Object> params);

	void insertHsResultCopy(Map<String, Object> params);

	List<EgovMap> cmbCollectTypeComboList();

	void updateDocNo(Map<String, Object> params);

	EgovMap selectHSDocNoList(Map<String, Object> params);

	int selectHSResultMCnt(Map<String, Object> params);

	int selectHSScheduleMCnt(Map<String, Object> params);

	List<EgovMap> selectHsFilterList(Map<String, Object> params);

	List<EgovMap> cmbServiceMemList();

	EgovMap selectSrvConfiguration(Map<String, Object> params);

	EgovMap selectDetailList(Map<String, Object> params);

	void insertHsResultD(Map<String, Object> params);

	EgovMap selectHsViewBasicInfo(Map<String, Object> params);

	void updateHsSrvConfigM(EgovMap params);

	List<EgovMap> failReasonList(Map<String, Object> params);

	List<EgovMap> serMemList(Map<String, Object> params);

	List<EgovMap> selectHsViewfilterInfo(Map<String, Object> params);

	EgovMap selectSettleInfo(Map<String, Object> params);

	void updateHsResultM(EgovMap params);

	void updateHsResultD(Map<String, Object> params);

	List<EgovMap> selectFilterTransaction(Map<String, Object> params);

	List<EgovMap> selectHistoryHSResult(Map<String, Object> params);

	EgovMap selectConfigBasicInfo(Map<String, Object> params);

	int  updateHsConfigBasic(Map<String, Object> params);

	void insertHsConfigSetting(LinkedHashMap hsBasicmap);

	EgovMap selectConfigBasicInfoYn(Map<String, Object> params);

	List<EgovMap> selectConfigSettingYn(Map<String, Object> params);

	void updateHsconfigSetting(Map<String, Object> sal0089);

	EgovMap selectHSOrderView(Map<String, Object> params);

	List<EgovMap> selectOrderInactiveFilter(Map<String, Object> params);

	List<EgovMap> selectOrderActiveFilter(Map<String, Object> params);

	void updateAssignCody(Map<String, Object> updateMap);

	void updateHsSVC0006D(Map<String, Object> sal0090);

	void updateHsFilterSiriNo(Map<String, Object> docSub);

	String select0087DFilter(Map<String, Object> docSub);

	void updateHs009d(Map<String, Object> params);

	List<EgovMap> selectBranch_id(Map<String, Object> params);
	
	List<EgovMap> selectCTMByDSC_id(Map<String, Object> params);

	EgovMap selectCheckMemCode(Map<String, Object> params);

	EgovMap selectSerMember(Map<String, Object> params);

	String selectMemberId(Map<String, Object> params);

	void updateSrvCodyId(Map<String, Object> params);

}
