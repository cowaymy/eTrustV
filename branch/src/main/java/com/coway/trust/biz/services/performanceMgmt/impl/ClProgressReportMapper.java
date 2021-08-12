package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ClProgressReportMapper.java
 * @Description : CL Progress Report Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 31.   KR-OHK        First creation
 * </pre>
 */

@Mapper("clProgressReportMapper")
public interface ClProgressReportMapper {

	List<EgovMap> selectGcmList(Map<String, Object> params);

	List<EgovMap> selectScmList(Map<String, Object> params);

	List<EgovMap> selectCmList(Map<String, Object> params);

	List<EgovMap> selectCodyList(Map<String, Object> params);

	List<EgovMap> selectHearServiceList(Map<String, Object> params);

	List<EgovMap> selectRentalCollectionList(Map<String, Object> params);

	List<EgovMap> selectSalesNetAppList(Map<String, Object> params);

	List<EgovMap> selectSalesNetCatList(Map<String, Object> params);

	List<EgovMap> selectRejoinList(Map<String, Object> params);

	List<EgovMap> selectMBOSalesList(Map<String, Object> params);

	List<EgovMap> selectMBOSVMList(Map<String, Object> params);

	List<EgovMap> selectRetentionList(Map<String, Object> params);

	List<EgovMap> selectCFFList(Map<String, Object> params);

	List<EgovMap> selectPEAList(Map<String, Object> params);

}
