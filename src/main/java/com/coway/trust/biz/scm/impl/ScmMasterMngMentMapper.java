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
	List<EgovMap> selectInvenCbBoxByStockType(Map<String, Object> params);
	List<EgovMap> selectInvenCbBoxByCategory(Map<String, Object> params);
	int updateMasterMngment(Map<String, Object> params);
	int updateMasterMngSupplyPlanTgtMoq(Map<String, Object> params);
	int insertMstMngMasterCDC(Map<String, Object> params);
	int insertMstMngMasterHeader(Map<String, Object> params);
	
	/* CDC WARE MAPPING */
	List<EgovMap> selectCdcWareMapping(Map<String, Object> params);
	List<EgovMap> selectWhLocationMapping(Map<String, Object> params);
	
	int insetCdcWhMapping(Map<String, Object> params); 
	int deleteCdcWhMapping(Map<String, Object> params); 
	
	/* Business Plan Manager */
	List<EgovMap> selectVersionCbList(Map<String, Object> params);
	List<EgovMap> selectBizPlanManager(Map<String, Object> params);
	List<EgovMap> selectBizPlanStock(Map<String, Object> params);  
	int updatePlanStock(Map<String, Object> params);
	int insertBizPlanMaster(Map<String, Object> params);   
	
	// 
	int getSeqNowSCM0003M(); 
	int insertDetailExcel(Map<String, Object> master);
	int insertMasterExcel(Map<String, Object> master);

	/* Plan and Sales DashBoard */
	List<EgovMap> selectChartDataList(Map<String, Object> params);	
	List<EgovMap> selectQuarterRate(Map<String, Object> params);	
	List<EgovMap> selectPSDashList(Map<String, Object> params);	
	
}
