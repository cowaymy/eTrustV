package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CodyPerformanceReportMapper.java
 * @Description : Cody Performance Report Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 06.   KR-OHK        First creation
 * </pre>
 */

@Mapper("codyPerformanceReportMapper")
public interface CodyPerformanceReportMapper {

	List<EgovMap> selectCodyHCList(Map<String, Object> params);

	List<EgovMap> selectCodyHSOverallList(Map<String, Object> params);
	List<EgovMap> selectCodyHSList(Map<String, Object> params);
	List<EgovMap> selectCodyHSCorporateRatioList(Map<String, Object> params);

	List<EgovMap> selectCodyRCOverallList(Map<String, Object> params);
	List<EgovMap> selectCodyRCList(Map<String, Object> params);

	List<EgovMap> selectCodySalesOverallList(Map<String, Object> params);
	List<EgovMap> selectCodySalesList(Map<String, Object> params);

	List<EgovMap> selectCodySVMOverallList(Map<String, Object> params);
	List<EgovMap> selectCodySVMList(Map<String, Object> params);

	List<EgovMap> selectCodyRTOverallList(Map<String, Object> params);
	List<EgovMap> selectCodyRTList(Map<String, Object> params);

	List<EgovMap> selectCodyCFFOverallList(Map<String, Object> params);

	List<EgovMap> selectCodyPEList(Map<String, Object> params);

	EgovMap selectMemberInfo(Map<String, Object> params);
}
