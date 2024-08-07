package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.performanceMgmt.HappyCallPlanningService;
import com.coway.trust.biz.services.performanceMgmt.SurveyMgmtService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("happyCallPlanningService")
public class HappyCallPlanningServiceImpl implements HappyCallPlanningService{
	
	private static final Logger logger = LoggerFactory.getLogger(HappyCallPlanningService.class);

	@Resource(name = "happyCallPlanningMapper")
	private HappyCallPlanningMapper happyCallPlanningMapper;
	
	@Override
	public List<EgovMap> selectCodeNameList(Map<String, Object> params) {
		return happyCallPlanningMapper.selectCodeNameList(params);
	}

	@Override
	public List<EgovMap> selectHappyCallList(Map<String, Object> params) {
		return happyCallPlanningMapper.selectHappyCallList(params);
	}

	@Override
	public boolean insertHappyCall(List<Object> addList, SessionVO sessionVO) {
		boolean addSuccess = false;
		if(addList.size() > 0){
    		for(int i=0; i< addList.size(); i++){
    			Map<String, Object>  insertValue = (Map<String, Object>) addList.get(i);
    			insertValue.put("userId", sessionVO.getUserId());
    			logger.debug("insertValue {}", insertValue);
    			happyCallPlanningMapper.insertHappyCall(insertValue);
    			
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
				if(insertValue.get("feedbackType").equals("Special")){	
					for(int j=0; j<2; j++){
						insertValue.put("hcAnsPoint", pointSpecial[j]);
						insertValue.put("hcAnsDesc", descSpecial[j]);
						happyCallPlanningMapper.insertHappyCallSub(insertValue);
					}
				}//FeedbackType이 Standard일때
				else if(insertValue.get("feedbackType").equals("Standard")){
					for(int k=0; k<5; k++){
						insertValue.put("hcAnsPoint", pointStandard[k]);
						insertValue.put("hcAnsDesc", descStandard[k]);
						happyCallPlanningMapper.insertHappyCallSub(insertValue);
					}
				}
    			 
    		}
    		addSuccess = true;
		}else{
			addSuccess = false;
		}
		return addSuccess;
	}
	
	@Override
	public boolean updateHappyCall(List<Object> udtList, SessionVO sessionVO) {
		boolean addSuccess = false;
		if(udtList.size() > 0){
    		for(int i=0; i< udtList.size(); i++){
    			Map<String, Object>  updateValue = (Map<String, Object>) udtList.get(i);
    			updateValue.put("userId", sessionVO.getUserId());
    			logger.debug("updateValue {}", updateValue);
    			happyCallPlanningMapper.updateHappyCall(updateValue);
    		}
    		addSuccess = true;
		}else{
			addSuccess = false;
		}
		return addSuccess;
	}

	@Override
	public boolean deleteHappyCall(List<Object> delList, SessionVO sessionVO) {
		boolean delSuccess = false;
		if(delList.size() > 0){
    		for(int i=0; i< delList.size(); i++){
    			Map<String, Object>  deleteValue = (Map<String, Object>) delList.get(i);
    			logger.debug("deleteValue {}", deleteValue);
    			happyCallPlanningMapper.deleteHappyCall(deleteValue);
    			happyCallPlanningMapper.deleteHappyCallSub(deleteValue);
    		}
    		delSuccess = true;
		}else{
			delSuccess = false;
		}
		return delSuccess;
	}
	
}
