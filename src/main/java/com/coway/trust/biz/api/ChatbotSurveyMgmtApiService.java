package com.coway.trust.biz.api;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ChatbotSurveyMgmtApiService {

	Map<String, Object> pushSurveyQues(Map<String, Object> params, HttpServletRequest request) throws Exception;

	Map<String, Object> cbtReqApi(Map<String, Object> params);

	EgovMap verifyBasicAuth(Map<String, Object> params, HttpServletRequest request);

	Map<String,Object> hcSurveyResult(HttpServletRequest request, Map<String, Object> params) throws Exception;

	void rtnRespMsg(Map<String, Object> params);

	Map<String, Object> SP_INST_CHATBOT_HAPPY_CALL_RESULT(Map<String, Object> params);

}
