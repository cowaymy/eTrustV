package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

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
	List<EgovMap> selectBizPlanManager(Map<String, Object> params);
	
}
