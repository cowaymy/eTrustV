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
	
	List<EgovMap> selectEvtMemIdList(Map<String, Object> params);
	
	List<EgovMap> selectSalesOrdNotList(Map<String, Object> params);
}
