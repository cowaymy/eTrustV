/**
 *
 */
package com.coway.trust.biz.homecare.sales;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Tommy
 *
 */
public interface htOrderListService {

	List<EgovMap> selectCodeList(Map<String, Object> params);

	List<EgovMap> selectOrderList(Map<String, Object> params);

	List<EgovMap> getApplicationTypeList(Map<String, Object> params);

	List<EgovMap> getUserCodeList();

	List<EgovMap> getOrgCodeList(Map<String, Object> params);

	List<EgovMap> getGrpCodeList(Map<String, Object> params);

	EgovMap getMemberOrgInfo(Map<String, Object> params);

	List<EgovMap> getBankCodeList(Map<String, Object> params);

	EgovMap selectInstallParam(Map<String, Object> params);

	List<EgovMap> selectProductReturnView(Map<String, Object> params);

	EgovMap getPReturnParam(Map<String, Object> params);

	EgovMap productReturnResult(Map<String, Object> params);

	void setPRFailJobRequest(Map<String, Object> params);

	EgovMap getPrCTInfo(Map<String, Object> params);
}
