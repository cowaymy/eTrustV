package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("sessionCapacityListMapper")
public interface SessionCapacityListMapper {
	List<EgovMap> selectOrgChartHpList(Map<String, Object> params);
	
	List<EgovMap> selectSsCapacityBrList(Map<String, Object> params);

	void insertCapacity(Map<String, Object> params);

	void updateCapacity(Map<String, Object> params);
	
	void updateCTMCapacity(Map<String, Object> params);
	
	void deleteCapacity(Map<String, Object> params);
	
	List<EgovMap> seleCtCodeSearch(Map<String, Object> params);
	
	List<EgovMap> seleCtCodeSearch2(Map<String, Object> params);

	List<EgovMap> seleBranchCodeSearch(Map<String, Object> params);

	EgovMap selectSsCapacityCTM(Map<String, Object> params);

	
	
	/*List<EgovMap> selectOrgChartCdList(Map<String, Object> params);
	
	List<EgovMap> getDeptTreeList(Map<String, Object> params);
	
	List<EgovMap> getGroupTreeList(Map<String, Object> params);

	List<EgovMap> selectCdChildList(Map<String, Object> params);
	
	List<EgovMap> selectOrgChartCtList(Map<String, Object> params);
	
	List<EgovMap> selectCtChildList(Map<String, Object> params);*/
	

	
}
