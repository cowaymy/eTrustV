package com.coway.trust.biz.services.performanceMgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ClProgressReportService.java
 * @Description : CL Progress Report Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 31.   KR-OHK        First creation
 * </pre>
 */
public interface ClProgressReportService {

	List<EgovMap> selectGcmList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectScmList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCmList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodyList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectHearServiceList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectRentalCollectionList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectSalesNetAppList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectSalesNetCatList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectRejoinList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectMBOSalesList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectMBOSVMList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectRetentionList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCFFList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPEAList(Map<String, Object> params) throws Exception;

}
