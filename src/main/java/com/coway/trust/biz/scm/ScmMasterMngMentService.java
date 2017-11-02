package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ScmMasterMngMentService 
{
	//SCM Master ManageMent
	List<EgovMap> selectMasterMngmentSearch(Map<String, Object> params);
	
	// CDC WareHouse Mapping
	List<EgovMap> selectCdcWareMapping(Map<String, Object> params);
	List<EgovMap> selectWhLocationMapping(Map<String, Object> params);
	int insetCdcWhMapping(List<Object> addList, Integer crtUserId); 
	int deleteCdcWhMapping(List<Object> addList, Integer crtUserId); 
	
	
	// Business Plan Manager
	List<EgovMap> selectVersionCbList(Map<String, Object> params);
	List<EgovMap> selectBizPlanManager(Map<String, Object> params);
	List<EgovMap> selectBizPlanStock(Map<String, Object> params);
	int updatePlanStock(List<Object> addList, Integer crtUserId); 
	int insertBizPlanMaster(Map<String, Object> params, SessionVO sessionVO);
	
	//Excel Load
	int saveLoadExcel(Map<String, Object> masterMap, List<Map<String, Object>> detailList);
	
	
	/* Plan and Sales DashBoard */	
	List<EgovMap> selectChartDataList(Map<String, Object> params);
	List<EgovMap> selectQuarterRate(Map<String, Object> params);
	List<EgovMap> selectPSDashList(Map<String, Object> params);
	
}
