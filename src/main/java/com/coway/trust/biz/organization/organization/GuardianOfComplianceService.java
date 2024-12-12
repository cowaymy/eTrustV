package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface GuardianOfComplianceService {


	List<EgovMap> selectGuardianofComplianceList(Map<String, Object> params);

	List<EgovMap> selectGuardianofComplianceListCodyHP(Map<String, Object> params, SessionVO sessionVo);

	EgovMap saveGuardian(Map<String, Object> params, SessionVO sessionVo);

	List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params);

	EgovMap selectGuardianofComplianceInfo(Map<String, Object> params);

	List<EgovMap> selectGuardianRemark(Map<String, Object> params);

	boolean saveGuardianCompliance(Map<String, Object> params,SessionVO sessionVo);

	String insertGuardian(Map<String, Object> params,SessionVO sessionVo);

	List<EgovMap> selectOrderList(Map<String, Object> params);

	EgovMap selectMemberByMemberIDCode(Map<String, Object> params);

	EgovMap selectAttachDownload(Map<String, Object> params);

	boolean updateGuardianCompliance(Map<String, Object> params,SessionVO sessionVo);

	List<EgovMap> selectReasonCodeList(Map<String, Object> params);

	List<EgovMap> selectGuardianofComplianceListSearch(Map<String, Object> params);

	List<EgovMap> getSubCatList(Map<String, Object> params);

	String gocApprove(Map<String, Object> params,SessionVO sessionVo);

	void gocReject(Map<String, Object> params,SessionVO sessionVo);

}
