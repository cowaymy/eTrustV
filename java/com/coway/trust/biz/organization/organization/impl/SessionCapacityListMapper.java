package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("sessionCapacityListMapper")
public interface SessionCapacityListMapper {
	List<EgovMap> selectOrgChartHpList(Map<String, Object> params);

	List<EgovMap> selectSsCapacityBrList(Map<String, Object> params);

	int insertCapacity(Map<String, Object> params);

	int updateCapacity(Map<String, Object> params);

	int updateCTMCapacity(Map<String, Object> params);

	int deleteCapacity(Map<String, Object> params);

	List<EgovMap> seleCtCodeSearch(Map<String, Object> params);

	List<EgovMap> seleCtCodeSearch2(Map<String, Object> params);

	List<EgovMap> seleBranchCodeSearch(Map<String, Object> params);

	List<EgovMap> selectSsCapacityCTM(Map<String, Object> params);

	/**
	 * Select Count Cpacity CTM
	 * @Author KR-SH
	 * @Date 2019. 11. 20.
	 * @param params
	 * @return
	 */
	public int selectCountSsCapacityCTM(Map<String, Object> params);

	List<EgovMap> selectSsCapacityBrListEnhance(Map<String, Object> params);

	int insertCapacityEnhance(Map<String, Object> params);

	int updateCapacityEnhance(Map<String, Object> params);

	int updateCTMCapacityEnhance(Map<String, Object> params);

	List<EgovMap> selectAllCarModelList();


	/*List<EgovMap> selectOrgChartCdList(Map<String, Object> params);

	List<EgovMap> getDeptTreeList(Map<String, Object> params);

	List<EgovMap> getGroupTreeList(Map<String, Object> params);

	List<EgovMap> selectCdChildList(Map<String, Object> params);

	List<EgovMap> selectOrgChartCtList(Map<String, Object> params);

	List<EgovMap> selectCtChildList(Map<String, Object> params);*/



}
