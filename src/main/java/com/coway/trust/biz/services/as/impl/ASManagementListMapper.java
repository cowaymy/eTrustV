package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ASManagementListMapper")
public interface ASManagementListMapper {
	
	 List<EgovMap> selectASManagementList(Map<String, Object> params);
	 
	 List<EgovMap> getASHistoryList(Map<String, Object> params);
	 
	 List<EgovMap> getBSHistoryList(Map<String, Object> params);
	 
	 List<EgovMap> getBrnchId(Map<String, Object> params);
	 
	 EgovMap  getMemberBymemberID(Map<String, Object> params);

	 EgovMap   getASEntryDocNo(Map<String, Object> params);
	 
	 EgovMap   getASEntryId(Map<String, Object> params);
	 
	 EgovMap   getResultASEntryId(Map<String, Object> params);
	 
	 EgovMap   selASEntryView(Map<String, Object> params);
	 
	 int   insertSVC0001D(Map<String, Object> params);
	 
	 int   insertSVC0003D(Map<String, Object> params);
	 
	 int   updateSVC0001D(Map<String, Object> params);
	 
	 int   updateSVC0003D(Map<String, Object> params);
	 
	 List<EgovMap> getASOrderInfo(Map<String, Object> params);

	 List<EgovMap> getASEvntsInfo(Map<String, Object> params);

	 List<EgovMap> getASHistoryInfo(Map<String, Object> params);
	 
	 List<EgovMap> getASStockPrice(Map<String, Object> params);
	 
	 List<EgovMap> getASFilterInfo(Map<String, Object> params);
	 List<EgovMap> getASReasonCode(Map<String, Object> params);
	 List<EgovMap> getASMember(Map<String, Object> params);
	 
	 List<EgovMap> getASReasonCode2(Map<String, Object> params);

	 EgovMap selectOrderBasicInfo(Map<String, Object> params);
	 
	 EgovMap  asResult_insert(Map<String, Object> params);
	 
	 int   insertSVC0004D(Map<String, Object> params);
	 
	 int   insertSVC0005D(Map<String, Object> params);
}
