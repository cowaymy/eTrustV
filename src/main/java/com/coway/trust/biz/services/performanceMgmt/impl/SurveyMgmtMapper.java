package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("surveyMgmtMapper")
public interface SurveyMgmtMapper {

	List<EgovMap> selectMemberTypeList();
	
	List<EgovMap> selectSurveyStusList();
	
	List<EgovMap> selectSurveyEventList(Map<String, Object> params) throws Exception;

	int addSurveyEventCreate(Map<String, Object> params);
	
	List<EgovMap> selectCodeNameList(Map<String, Object> params);
	
	int addSurveyEventInfo(Map<String, Object> params);
	
	int addSurveyEventTarget(Map<String, Object> params);
	
	int addSurveyEventQuestion(Map<String, Object> params);
	
	int addSurveyEventAnsSpecial(Map<String, Object> params);
	
	int addSurveyEventAnsStandard(Map<String, Object> params);
	
	List<EgovMap> selectEvtMemIdList(Map<String, Object> params);
	
	List<EgovMap> selectSalesOrdNotList(Map<String, Object> params);
	
	List<EgovMap> selectSurveyEventDisplayInfoList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectSurveyEventDisplayQList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> selectSurveyEventDisplayTargetList(Map<String, Object> params) throws Exception;
	
	
	
	int udtSurveyEventInfo(Map<String, Object> params);
	
	int udtSurveyEventQuestion(Map<String, Object> params);
	
	int deleteSurveyEventTarget(Map<String, Object> params);
	
	int deleteSurveyEventQuestion(Map<String, Object> params);
	
	int deleteSurveyEventAns(Map<String, Object> params);
	
	EgovMap selectSalesOrdNotList2(Map<String, Object> params);
	
	int udtSurveyEventTarget(Map<String, Object> params);
	
	int selectSurveyEventTarget(Map<String, Object> params);


}
