package com.coway.trust.biz.api;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ChatbotInboundApiService {
	EgovMap verifyBasicAuth(HttpServletRequest request);
	EgovMap verifyCustIdentity(HttpServletRequest request, Map<String, Object> params) throws Exception;
	EgovMap getOrderList(HttpServletRequest request, Map<String, Object> params) throws Exception;
	EgovMap sendStatement(HttpServletRequest request, Map<String, Object> params) throws Exception;
	void rtnRespMsg(Map<String, Object> params);
}
