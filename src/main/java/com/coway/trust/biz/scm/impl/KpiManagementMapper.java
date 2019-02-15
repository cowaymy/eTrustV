package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("kpiManagementMapper")
public interface KpiManagementMapper {
	
	//	Inventory Report
	List<EgovMap> selectInventoryReportTotalHeader(Map<String, Object> params);
	List<EgovMap> selectInventoryReportDetailHeader(Map<String, Object> params);
	List<EgovMap> selectInventoryReportTotal(Map<String, Object> params);
	List<EgovMap> selectInventoryReportDetail(Map<String, Object> params);
}