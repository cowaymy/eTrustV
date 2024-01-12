package com.coway.trust.biz.api;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.biz.api.vo.chatbotInbound.VerifyCustIdentityReqForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ChatbotInboundApiService {
	EgovMap verifyBasicAuth(HttpServletRequest request);
//	EgovMap verifyCustIdentity(HttpServletRequest request, Map<String, Object> params) throws Exception;
	EgovMap getOrderList(HttpServletRequest request, Map<String, Object> params) throws Exception;
	EgovMap sendStatement(HttpServletRequest request, Map<String, Object> params) throws Exception;
	EgovMap getPaymentMode(HttpServletRequest request, Map<String, Object> params) throws Exception;
	EgovMap getOtd(HttpServletRequest request, Map<String, Object> params) throws Exception;
	void rtnRespMsg(Map<String, Object> params);

	Map<String, Object> generatePDF(Map<String, Object> params) throws Exception;
	List<Map<String, Object>> getGenPdfList(Map<String, Object> params) throws Exception;
	void update_chatbot(Map<String, Object> params)  throws Exception;
	Map<String, Object> createPdfFile(Map<String, Object> params)  throws Exception;
	EgovMap verifyCustIdentity(HttpServletRequest request, VerifyCustIdentityReqForm params) throws Exception;
}
