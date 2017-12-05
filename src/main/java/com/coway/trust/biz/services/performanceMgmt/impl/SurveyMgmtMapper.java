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

}
