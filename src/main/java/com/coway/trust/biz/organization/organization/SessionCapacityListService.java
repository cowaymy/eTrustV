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
	
	List<EgovMap> seleCtCodeSearch(Map<String, Object>params);
	
	List<EgovMap> seleBranchCodeSearch(Map<String, Object>params);
	
	/*List<EgovMap> selectHpChildList(Map<String, Object> params);
	
	List<EgovMap> getDeptTreeList(Map<String, Object> params);        
	
	List<EgovMap> getGroupTreeList(Map<String, Object> params);        
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	List<EgovMap> selectOrgChartCdList(Map<String, Object> params);
	
	List<EgovMap> selectOrgChartCtList(Map<String, Object> params);
	
	
	*/

	
}



