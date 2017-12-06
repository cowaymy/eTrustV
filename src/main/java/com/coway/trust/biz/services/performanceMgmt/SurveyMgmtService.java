package com.coway.trust.biz.services.performanceMgmt;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface SurveyMgmtService {
	
	List<EgovMap> selectMemberTypeList();
	
	List<EgovMap> selectSurveyStusList();
	
	List<EgovMap> selectSurveyEventList(Map<String, Object> params) throws Exception;
	
	int addSurveyEventCreate(List<Object> updateList , String loginId);

}
