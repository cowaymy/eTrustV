package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.performanceMgmt.SurveyMgmtService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("surveyMgmtService")
public class SurveyMgmtServiceImpl extends EgovAbstractServiceImpl implements SurveyMgmtService{
	
	private static final Logger logger = LoggerFactory.getLogger(SurveyMgmtService.class);

	@Resource(name = "surveyMgmtMapper")
	private SurveyMgmtMapper surveyMgmtMapper;
	
	@Override
	public List<EgovMap> selectMemberTypeList() {
		
		return surveyMgmtMapper.selectMemberTypeList();
	}
	
	@Override
	public List<EgovMap> selectSurveyStusList() {
		
		return surveyMgmtMapper.selectSurveyStusList();
	}
	
	@Override
	public List<EgovMap> selectSurveyEventList(Map<String, Object> params) throws Exception {
		return surveyMgmtMapper.selectSurveyEventList(params);
	}
	
	@Override
	public int addSurveyEventCreate(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+surveyMgmtMapper.addSurveyEventCreate((Map<String, Object>) obj);
		}
		return cnt;
	}


}
