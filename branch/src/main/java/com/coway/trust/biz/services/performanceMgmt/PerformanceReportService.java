package com.coway.trust.biz.services.performanceMgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PerformanceReportService {

	List<EgovMap> selectPfReportRejoin(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPfReportCollection(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPfReportHeartService(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPfReportSales(Map<String, Object> params) throws Exception;

	List<EgovMap> selectBranchList(Map<String, Object> params) ;

}
