package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ComplianceCallLogService {

	List<EgovMap> selectComplianceLog(Map<String, Object> params);

	EgovMap getMemberDetail(Map<String, Object> params);

	String insertCompliance(Map<String, Object> params,SessionVO sessionVo, List<EgovMap> gridOrder);

	EgovMap selectCheckOrder(Map<String, Object> params);

	EgovMap selectComplianceOrderDetail(Map<String, Object> params);

	EgovMap selectComplianceNoValue(Map<String, Object> params);

	List<EgovMap> selectOrderDetailComplianceId(Map<String, Object> params);

	List<EgovMap> selectComplianceRemark(Map<String, Object> params);

	boolean deleteOrderDetail(Map<String, Object> params);

	boolean insertComplianceOrderDetail (List<Object> gridOrder,Map<String, Object> formList);

	boolean saveMaintenceCompliance(Map<String, Object> params,SessionVO sessionVo);

	boolean saveOrderMaintence(Map<String, Object> params,SessionVO sessionVo);

	EgovMap selectAttachDownload(Map<String, Object> params);

	boolean saveOrderMaintenceSync(Map<String, Object> params,SessionVO sessionVo);

	String insertComplianceReopen(Map<String, Object> params,SessionVO sessionVo);

	List<EgovMap> getPicList(Map<String, Object> params);

}
