package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SessionCapacityListService {

	List<EgovMap> selectSsCapacityBrList(Map<String, Object> params);

	void insertCapacity(List<Object> params, SessionVO sessionVO);

	void updateCapacity(List<Object> params, SessionVO sessionVO);

	void deleteCapacity(List<Object> params, SessionVO sessionVO);

	void updateCapacityByExcel(List<Map<String, Object>> updateList, SessionVO sessionVO);

	List<EgovMap> seleCtCodeSearch(Map<String, Object>params);

	List<EgovMap> seleCtCodeSearch2(Map<String, Object> params);

	List<EgovMap> seleBranchCodeSearch(Map<String, Object>params);

	List<EgovMap> selectSsCapacityCTM(Map<String, Object> params);

	void updateCTMCapacity(List<Object> udtList, SessionVO sessionVO);

	void updateCTMCapacityByExcel(List<Map<String, Object>> updateList, SessionVO sessionVO);

	void deleteCapacityByExcel(List<Map<String, Object>> updateList, SessionVO sessionVO);

	/**
	 * Select Count Cpacity CTM
	 * @Author KR-SH
	 * @Date 2019. 11. 20.
	 * @param params
	 * @return
	 */
	public int selectCountSsCapacityCTM(Map<String, Object> params);

	List<EgovMap> selectSsCapacityBrListEnhance(Map<String, Object> params);

	void insertCapacityEnhance(List<Object> params, SessionVO sessionVO);

	void updateCapacityEnhance(List<Object> params, SessionVO sessionVO);

	void updateCapacityByExcelEnhance(List<Map<String, Object>> updateList, SessionVO sessionVO);

	void updateCTMCapacityEnhance(List<Object> udtList, SessionVO sessionVO);

	void updateCTMCapacityByExcelEnhance(List<Map<String, Object>> updateList, SessionVO sessionVO);

	List<EgovMap> selectAllCarModelList();

	/*List<EgovMap> selectHpChildList(Map<String, Object> params);

	List<EgovMap> getDeptTreeList(Map<String, Object> params);

	List<EgovMap> getGroupTreeList(Map<String, Object> params);















	List<EgovMap> selectOrgChartCdList(Map<String, Object> params);

	List<EgovMap> selectOrgChartCtList(Map<String, Object> params);


	*/


}



