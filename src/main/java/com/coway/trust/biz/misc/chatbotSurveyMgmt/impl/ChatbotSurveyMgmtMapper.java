package com.coway.trust.biz.misc.chatbotSurveyMgmt.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.api.vo.SurveyCategoryDto;
import com.coway.trust.biz.api.vo.SurveyTargetAnsDto;
import com.coway.trust.biz.api.vo.SurveyTargetQuesDto;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("chatbotSurveyMgmtMapper")
public interface ChatbotSurveyMgmtMapper {
	List<EgovMap> selectChatbotSurveyType(Map<String, Object> params);
	List<EgovMap> selectChatbotSurveyMgmtList(Map<String, Object> params);
	List<EgovMap> selectChatbotSurveyDesc(Map<String, Object> params);
	int getCategoryDate(String ctrlId);

	List<EgovMap> selectChatbotSurveyMgmtEdit(Map<String, Object> params);
	String getSurveyEndDate(String ctrlId);


//	void updateExistTargetQues(Map<String,Object> params);
//	List<String> getTargetQuestionSurvID(Map<String,Object> params);
//	void updateTargetAnsYn(Map<String, Object> params);


	List<String> getExistTargetQuestion(Map<String, Object> params);
	String getTargetQuesStrDt(Map<String, Object> params);
	void updateExistTargetQues(Map<String,Object> params);

	int getNextSurvSeq();
	int getNextSurvGrpId(String ctrlId);
	void insertNewSurveyQues(Map<String,Object> params);
	void insertNewSurveyAns(Map<String,Object> params);


//	API PART
	List<EgovMap> getSurveyCategoryList();
	List<EgovMap> getSurveyTargetQuesList();
//	List<EgovMap> getSurveyTargetAnsList();
	List<EgovMap> getSurveyTargetAnsList(String[] surveyQuesArray);
	void updateSync(EgovMap updInfo);
}
