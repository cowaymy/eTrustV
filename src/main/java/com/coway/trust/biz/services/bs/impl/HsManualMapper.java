package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hsManualMapper")
public interface HsManualMapper {

	List<EgovMap> selectHsManualList(Map<String, Object> params);

	List<EgovMap> selectHsAssiinlList(Map<String, Object> params);
	
	List<EgovMap> selectBranchList(Map<String, Object> params);
	
	List<EgovMap> selectCtList(Map<String, Object> params);

	List<EgovMap> getCdList(Map<String, Object> params);

	List<EgovMap> getCdUpMemList(Map<String, Object> params);

	List<EgovMap> getCdList_1(Map<String, Object> params);

	List<EgovMap> selectHsManualListPop(Map<String, Object> params);
	
	void insertHsResult(Map<String, Object> params);
	
	int getNextSchdulId();
	
}
