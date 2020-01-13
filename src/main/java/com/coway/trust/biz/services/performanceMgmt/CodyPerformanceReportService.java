package com.coway.trust.biz.services.performanceMgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CodyPerformanceReportService.java
 * @Description : Cody Performance Report Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 06.   KR-OHK        First creation
 * </pre>
 */
public interface CodyPerformanceReportService {

	List<EgovMap> selectCodyHCList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodyHSOverallList(Map<String, Object> params) throws Exception;
	List<EgovMap> selectCodyHSList(Map<String, Object> params) throws Exception;
	List<EgovMap> selectCodyHSCorporateRatioList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodyRCOverallList(Map<String, Object> params) throws Exception;
	List<EgovMap> selectCodyRCList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodySalesOverallList(Map<String, Object> params) throws Exception;
	List<EgovMap> selectCodySalesList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodySVMOverallList(Map<String, Object> params) throws Exception;
	List<EgovMap> selectCodySVMList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodyRTOverallList(Map<String, Object> params) throws Exception;
	List<EgovMap> selectCodyRTList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodyCFFOverallList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodyPEList(Map<String, Object> params) throws Exception;

	EgovMap selectMemberInfo(Map<String, Object> params) throws Exception;
}
