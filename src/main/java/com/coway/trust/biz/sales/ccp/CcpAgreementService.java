package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpAgreementService {

	List<EgovMap> selectContactAgreementList(Map<String, Object> params) throws Exception;
	
	EgovMap getOrderId(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectAfterServiceJsonList (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectBeforeServiceJsonList (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectSearchOrderNo(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectSearchMemberCode (Map<String, Object> params) throws Exception;
	
	EgovMap getMemCodeConfirm (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectCurierListJsonList() throws Exception;
	
	List<EgovMap> selectOrderJsonList(Map<String, Object> params) throws Exception;
	
	Map<String, Object> insertAgreement(Map<String, Object> params) throws Exception;
	
	boolean sendSuccessEmail(Map<String, Object> params) throws Exception;
	
	EgovMap selectAgreementInfo (Map<String, Object> params) throws Exception;
	
	List<EgovMap> getMessageStatusCode(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectConsignmentLogAjax (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectMessageLogAjax (Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectContactOrdersAjax(Map<String, Object> params) throws Exception;
	
	Map<String, Object> updateAgreementMtcEdit(Map<String, Object> params) throws Exception;
	
	void updateNewConsignment(Map<String, Object> params) throws Exception;
	
	boolean sendUpdateEmail(Map<String, Object> params) throws Exception;
	
	void uploadCcpFile(Map<String, Object> params) throws Exception;
	
}
