package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.performanceMgmt.SurveyMgmtService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("surveyMgmtService")
public class SurveyMgmtServiceImpl implements SurveyMgmtService{
	
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
	
	@Override
	public List<EgovMap> getCodeNameList(Map<String, Object> params) {
		return surveyMgmtMapper.selectCodeNameList(params);
	}
	
/*	@Override
	public int addSurveyEventTarget(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+surveyMgmtMapper.addSurveyEventTarget((Map<String, Object>) obj);
		}
		return cnt;
	}*/

	@Override
	public int addSurveyEventTarget(Map<String, Map<String, ArrayList<Object>>> params, String loginId){
		
		Map<String, ArrayList<Object>> aGrid = params.get("aGrid");
		Map<String, ArrayList<Object>> bGrid = params.get("bGrid");
		
		ArrayList<Object> addList = aGrid.get(AppConstants.AUIGRID_ADD);
		
		if(addList != null && addList.size() > 0){
			Map<String, Object> masterRow = (Map<String, Object>) addList.get(0);
			//마스터 등록...
			// xxxMapper.insert(masterRow);
			((Map<String, Object>) masterRow).put("crtUserId", loginId);
			((Map<String, Object>) masterRow).put("updUserId", loginId);
			surveyMgmtMapper.addSurveyEventInfo((Map<String, Object>) masterRow);
			
			
			//두번재 그리드 등록...
			ArrayList<Object> b_addList = bGrid.get(AppConstants.AUIGRID_ADD);
			
			for(Object row : b_addList){
				Map<String, Object> bRow = (Map<String, Object>) row;
				bRow.put("evtId", masterRow.get("evtId"));
				//xxxMapper.insertBB(bRow);
				((Map<String, Object>) bRow).put("crtUserId", loginId);
				((Map<String, Object>) bRow).put("updUserId", loginId);
				surveyMgmtMapper.addSurveyEventTarget((Map<String, Object>) bRow);
			}
			
		}else{
			throw new ApplicationException(AppConstants.FAIL, "1건 이상이어야 합니다.");
		}
		
		return 0;
	}
}
