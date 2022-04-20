package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SalesMonitoringFileService {


	List<EgovMap> selectSummarySalesListing(Map<String, Object> params);

	List<EgovMap> selectWeekSalesListing(Map<String, Object> params);

	List<EgovMap> selectPerformanceView(Map<String, Object> params);

	List<EgovMap> selectSmfHA(Map<String, Object> params);

	List<EgovMap> selectSmfHC(Map<String, Object> params);

	List<EgovMap> selectSmfActHp(Map<String, Object> params);

	List<EgovMap> selectSmfDailyListing(Map<String, Object> params);

	List<EgovMap> selectSimulatedMemberCRSCode(Map<String, Object> params);



}
