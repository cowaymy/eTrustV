package com.coway.trust.biz.services.tagMgmt;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TagMgmtService {

	List<EgovMap> getTagStatus(Map<String, Object> params);

	EgovMap getDetailTagStatus(Map<String, Object> params);

	int addRemarkResult(Map<String, Object> params, SessionVO sessionVO)  throws ParseException;

	List<EgovMap> getTagRemark(Map<String, Object> params);

	List<EgovMap> getMainDeptList();

	List<EgovMap> getSubDeptList(Map<String, Object> params);

	List<EgovMap> getMainInquiryList();

	List<EgovMap> getSubInquiryList(Map<String, Object> params);

	EgovMap getOrderInfo(Map<String, Object> params);

	EgovMap getCallerInfo(Map<String, Object> params);

	EgovMap selectOrderSalesmanViewByOrderID(Map<String, Object> params);

	EgovMap selectOrderServiceMemberViewByOrderID(Map<String, Object> params);

	List<EgovMap> getAttachList(Map<String, Object> params);

}
