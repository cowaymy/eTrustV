package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hsManualMapper")
public interface HsManualMapper {

	List<EgovMap> selectHsManualList(Map<String, Object> params);

	List<EgovMap> selectHsAssiinlList(Map<String, Object> params);
	
	EgovMap selectHsAssiinlList_1(Map<String, Object> params);
	
	List<EgovMap> selectBranchList(Map<String, Object> params);
	
	List<EgovMap> selectCtList(Map<String, Object> params);

	List<EgovMap> getCdList(Map<String, Object> params);

	List<EgovMap> getCdUpMemList(Map<String, Object> params);

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
	


	
}
