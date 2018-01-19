package com.coway.trust.biz.services.performanceMgmt;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SurveyMgmtService {
	
	List<EgovMap> selectMemberTypeList();
	
	List<EgovMap> selectSurveyStusList();
	
	List<EgovMap> selectSurveyEventList(Map<String, Object> params) throws Exception;
	
	int addSurveyEventCreate(List<Object> updateList , String loginId);

	List<EgovMap> getCodeNameList(Map<String, Object> params);
	
	int addSurveyEventTarget(Map<String, Map<String, ArrayList<Object>>> params, String loginId);
	
	List<EgovMap> selectEvtMemIdList(Map<String, Object> params);
	
	List<EgovMap> selectSalesOrdNotList(Map<String, Object> params);

	List<EgovMap> selectSurveyEventDisplayInfoList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectSurveyEventDisplayQList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectSurveyEventDisplayTargetList(Map<String, Object> params) throws Exception;
	
	int addEditedSurveyEventTarget(Map<String, Map<String, ArrayList<Object>>> params, String loginId);
	
	EgovMap selectSalesOrdNotList2(Map<String, Object> params);
	
	
}
