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
//    			insertValue.put("holidayType", (insertValue.get("holidayType").toString()).substring(0, 1) );
    			insertValue.put("userId", sessionVO.getUserId());
    			logger.debug("insertValue {}", insertValue);
    			happyCallPlanningMapper.insertHappyCall(insertValue);
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
    		}
    		delSuccess = true;
		}else{
			delSuccess = false;
		}
		return delSuccess;
	}
	
}
