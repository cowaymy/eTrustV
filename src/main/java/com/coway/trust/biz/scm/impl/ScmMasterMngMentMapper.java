package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ScmMasterMngMentMapper")
public interface ScmMasterMngMentMapper 
{
	/* SCM MASTER MANAGEMENT */
	List<EgovMap> selectMasterMngmentSearch(Map<String, Object> params);
	
	/* CDC WARE MAPPING */
	List<EgovMap> selectCdcWareMapping(Map<String, Object> params);
	List<EgovMap> selectWhLocationMapping(Map<String, Object> params);
	
	int insetCdcWhMapping(Map<String, Object> params); 
	int deleteCdcWhMapping(Map<String, Object> params); 
	
	/* Business Plan Manager */
	List<EgovMap> selectBizPlanManager(Map<String, Object> params);

}
