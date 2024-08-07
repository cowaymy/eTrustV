package com.coway.trust.biz.api.impl;

import java.util.Map;

import com.coway.trust.biz.api.vo.HcSurveyResultCsvVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ChatbotSurveyMgmtApiMapper")
public interface ChatbotSurveyMgmtApiMapper {

	EgovMap checkAccess(Map<String, Object> params);
	void insertSurveyResp(HcSurveyResultCsvVO hcSurveyResultCsvVO);
	void insertApiAccessLog(Map<String, Object> params);
	EgovMap SP_INST_CHATBOT_HAPPY_CALL_RESULT(Map<String, Object> params);
}
