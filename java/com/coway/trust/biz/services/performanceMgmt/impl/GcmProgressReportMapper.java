package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : GcmProgressReportMapper.java
 * @Description : GCM Progress Report Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 29.   KR-OHK        First creation
 * </pre>
 */

@Mapper("gcmProgressReportMapper")
public interface GcmProgressReportMapper {

	List<EgovMap> selectMemList(Map<String, Object> params);

	List<EgovMap> selectScmList(Map<String, Object> params);

	List<EgovMap> selectCmList(Map<String, Object> params);

	List<EgovMap> selectCodyList(Map<String, Object> params);

	List<EgovMap> selectCodyRowDataList(Map<String, Object> params);

	List<EgovMap> selectHearServiceList(Map<String, Object> params);

	List<EgovMap> selectRentalCollectionList(Map<String, Object> params);

	List<EgovMap> selectSalesNetList(Map<String, Object> params);

	List<EgovMap> selectSalesProdList(Map<String, Object> params);

	List<EgovMap> selectRejoinList(Map<String, Object> params);

	List<EgovMap> selectMBOSalesList(Map<String, Object> params);

	List<EgovMap> selectMBOSVMList(Map<String, Object> params);

	List<EgovMap> selectRetentionList(Map<String, Object> params);

	List<EgovMap> selectCFFList(Map<String, Object> params);

	List<EgovMap> selectGcmPEList(Map<String, Object> params);

	List<EgovMap> selectScmPEAList(Map<String, Object> params);

	List<EgovMap> selectCmPEAList(Map<String, Object> params);

	List<EgovMap> selectCodyPEAList(Map<String, Object> params);
}
