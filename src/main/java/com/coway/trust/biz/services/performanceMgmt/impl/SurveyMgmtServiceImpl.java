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
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SurveyMgmtService.class);

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
		Map<String, ArrayList<Object>> cGrid = params.get("cGrid");
		Map<String, ArrayList<Object>> dGrid = params.get("cGrid");
		
		ArrayList<Object> addList = aGrid.get(AppConstants.AUIGRID_ADD);
		
		if(addList != null && addList.size() > 0){
			Map<String, Object> masterRow = (Map<String, Object>) addList.get(0);
			//마스터 등록...
			// xxxMapper.insert(masterRow);
			((Map<String, Object>) masterRow).put("crtUserId", loginId);
			((Map<String, Object>) masterRow).put("updUserId", loginId);
			surveyMgmtMapper.addSurveyEventInfo((Map<String, Object>) masterRow);
			
			
			//두번째 그리드 등록...
			ArrayList<Object> b_addList = bGrid.get(AppConstants.AUIGRID_ADD);
			
			for(Object row : b_addList){
				Map<String, Object> bRow = (Map<String, Object>) row;
				bRow.put("evtId", masterRow.get("evtId"));
				//xxxMapper.insertBB(bRow);
				((Map<String, Object>) bRow).put("crtUserId", loginId);
				((Map<String, Object>) bRow).put("updUserId", loginId);
				surveyMgmtMapper.addSurveyEventTarget((Map<String, Object>) bRow);
			}
			
			//세번째 그리드 등록... CCR0003M에 등록하기
			ArrayList<Object> c_addList = cGrid.get(AppConstants.AUIGRID_ADD);
			ArrayList<Object> d_addList = cGrid.get(AppConstants.AUIGRID_ADD);
			
			for(Object row : c_addList){
				Map<String, Object> cRow = (Map<String, Object>) row;
				cRow.put("evtId", masterRow.get("evtId"));
				
				LOGGER.debug("hcDefCtgryId : {}", cRow.get("hcDefCtgryId"));
				
				//xxxMapper.insertCC(cRow);
				((Map<String, Object>) cRow).put("crtUserId", loginId);
				((Map<String, Object>) cRow).put("updUserId", loginId);
				surveyMgmtMapper.addSurveyEventQuestion((Map<String, Object>) cRow);
				
				
				//세번째 그리드에서 CCR0004M에 등록하기
				Map<String, Object> dRow = (Map<String, Object>) row;
				dRow.put("hcDefId", cRow.get("hcDefId"));
				//xxxMapper.insertCC(cRow);
				((Map<String, Object>) dRow).put("crtUserId", loginId);
				((Map<String, Object>) dRow).put("updUserId", loginId);
				
				String feedType = (String) cRow.get("hcDefCtgryId");
				
				String[] pointSpecial = new String[2];
				pointSpecial[0] = "1";
				pointSpecial[1] = "5";
				
				String[] descSpecial = new String[2];
				descSpecial[0] = "Yes";
				descSpecial[1] = "No";
				
				String[] pointStandard = new String[5];
				pointStandard[0] = "1";
				pointStandard[1] = "2";
				pointStandard[2] = "3";
				pointStandard[3] = "4";
				pointStandard[4] = "5";
				
				String[] descStandard = new String[5];
				descStandard[0] = "Excellent";
				descStandard[1] = "Good";
				descStandard[2] = "Average";
				descStandard[3] = "Poor";
				descStandard[4] = "Bad";
				
				//FeedbackType이 Special일때
				if(feedType.equals("Special")){
					for(int i=0; i<2; i++){
						dRow.put("hcAnsPoint", pointSpecial[i]);
						dRow.put("hcAnsDesc", descSpecial[i]);
						surveyMgmtMapper.addSurveyEventAnsSpecial((Map<String, Object>) dRow);
					}
				}//FeedbackType이 Standard일때
				else if(feedType.equals("Standard")){
					for(int j=0; j<5; j++){
						dRow.put("hcAnsPoint", pointStandard[j]);
						dRow.put("hcAnsDesc", descStandard[j]);
						surveyMgmtMapper.addSurveyEventAnsStandard((Map<String, Object>) dRow);
					}
				}
			}
			
		}else{
			throw new ApplicationException(AppConstants.FAIL, "1건 이상이어야 합니다.");
		}
		
		return 0;
	}
	
	@Override
	public List<EgovMap> selectEvtMemIdList(Map<String, Object> params) {
		return surveyMgmtMapper.selectEvtMemIdList(params);
	}
	
	@Override
	public List<EgovMap> selectSalesOrdNotList(Map<String, Object> params) {
		return surveyMgmtMapper.selectSalesOrdNotList(params);
	}
	
	@Override
	public List<EgovMap> selectSurveyEventDisplayInfoList(Map<String, Object> params) throws Exception {
		return surveyMgmtMapper.selectSurveyEventDisplayInfoList(params);
	}
	
	@Override
	public List<EgovMap> selectSurveyEventDisplayQList(Map<String, Object> params) throws Exception {
		return surveyMgmtMapper.selectSurveyEventDisplayQList(params);
	}
	
	@Override
	public List<EgovMap> selectSurveyEventDisplayTargetList(Map<String, Object> params) throws Exception {
		return surveyMgmtMapper.selectSurveyEventDisplayTargetList(params);
	}
	
}
