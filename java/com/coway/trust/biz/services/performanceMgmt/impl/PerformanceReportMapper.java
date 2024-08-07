package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("performanceReportMapper")
public interface PerformanceReportMapper {

	List<EgovMap> selectPfReportRejoin(Map<String, Object> params);

	List<EgovMap> selectPfReportSales(Map<String, Object> params);

	List<EgovMap> selectPfReportHeartService(Map<String, Object> params);

	List<EgovMap> selectPfReportCollection(Map<String, Object> params);

	List<EgovMap> selectBranchList(Map<String, Object> params);

}
