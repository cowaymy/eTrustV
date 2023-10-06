package com.coway.trust.biz.misc.chatbotSurveyMgmt;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ChatbotSurveyMgmtService {
	List<EgovMap> selectChatbotSurveyType(Map<String, Object> params);
	List<EgovMap> selectChatbotSurveyMgmtList(Map<String, Object> params);
	List<EgovMap> selectChatbotSurveyDesc(Map<String, Object> params);
	List<EgovMap> selectChatbotSurveyMgmtEdit(Map<String, Object> params);
	void saveSurveyDetail(Map<String, Object> params, SessionVO sessionVO);
}
