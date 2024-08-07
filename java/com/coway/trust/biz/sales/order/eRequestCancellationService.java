
package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface  eRequestCancellationService {

	List<EgovMap> selectOrderList(Map<String, Object> params);

	public EgovMap selectOrderBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	public List<EgovMap> selectCallLogList(Map<String, Object> params);

	EgovMap checkeRequestAutoDebitDeduction(Map<String, Object> params);

	EgovMap validRequestOCRStus(Map<String, Object> params);

	ReturnMessage requestCancelOrder(Map<String, Object> params, SessionVO sessionVO) throws Exception ;

	EgovMap cancelReqInfo(Map<String, Object> params);

	void insertReqEditOrdInfo(Map<String, Object> params);

  List<EgovMap> selectRequestApprovalList(Map<String, Object> params);

  int saveApprCnct(Map<String, Object> params);

  int saveApprInstAddr(Map<String, Object> params);

}
