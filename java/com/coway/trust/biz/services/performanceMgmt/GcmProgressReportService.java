package com.coway.trust.biz.services.performanceMgmt;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : GcmProgressReportService.java
 * @Description : GCM Progress Report Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 29.   KR-OHK        First creation
 * </pre>
 */
public interface GcmProgressReportService {

	List<EgovMap> selectMemList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectScmList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCmList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodyList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodyRowDataList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectHearServiceList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectRentalCollectionList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectSalesNetList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectSalesProdList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectRejoinList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectMBOSalesList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectMBOSVMList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectRetentionList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCFFList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectGcmPEList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectScmPEAList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCmPEAList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectCodyPEAList(Map<String, Object> params) throws Exception;

}
