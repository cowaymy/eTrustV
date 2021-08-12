package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.impl.TerritoryManagementMapper;
import com.coway.trust.biz.services.servicePlanning.CTSubGroupListService;
import com.coway.trust.biz.services.servicePlanning.HolidayService;
import com.coway.trust.cmmn.model.SessionVO;
import com.crystaldecisions.reports.exporters.excel.libs.biff.records.FORMAT;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("holidayService")
public class HolidayServiceImpl extends EgovAbstractServiceImpl implements HolidayService{
	private static final Logger logger = LoggerFactory.getLogger(HolidayService.class);

	@Resource(name = "holidayMapper")
	private HolidayMapper holidayMapper;
	
	@Override
	public boolean insertHoliday(List<Object> params, SessionVO sessionVO) {
		boolean addSuccess = false;
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  insertValue = (Map<String, Object>) params.get(i);
    			insertValue.put("holidayType", (insertValue.get("holidayType").toString()).substring(0, 1) );
    			insertValue.put("userId", sessionVO.getUserId());
    			logger.debug("insertValue {}", insertValue);
    			holidayMapper.insertHoliday(insertValue);
    		}
    		addSuccess = true;
		}else{
			addSuccess = false;
		}
		return addSuccess;
	}
	
	@Override
	public boolean updateHoliday(List<Object> params, SessionVO sessionVO) {
		boolean addSuccess = false;
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  updateValue = (Map<String, Object>) params.get(i);
    			updateValue.put("holidayType", (updateValue.get("holidayType").toString()).substring(0, 1) );
    			updateValue.put("userId", sessionVO.getUserId());
    			logger.debug("updateValue {}", updateValue);
    			holidayMapper.updateHoliday(updateValue);
    		}
    		addSuccess = true;
		}else{
			addSuccess = false;
		}
		return addSuccess;
	}
	
	
	@Override
	public List<EgovMap> selectHolidayList(Map<String, Object> params) {
		return holidayMapper.selectHolidayList(params);
	}
	
	@Override
	public List<EgovMap> selectCTList(Map<String, Object> params) {
		return holidayMapper.selectCTList(params);
	}
	
	@Override
	public List<EgovMap> selectCTAssignList(Map<String, Object> params) {
		return holidayMapper.selectCTAssignList(params);
	}
	
	@Override
	public boolean deleteHoliday(List<Object> params, SessionVO sessionVO) {
		boolean delSuccess = false;
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  delValue = (Map<String, Object>) params.get(i);
    			delValue.put("holidayType", (delValue.get("holidayType").toString()).substring(0, 1) );
    			delValue.put("userId", sessionVO.getUserId());
    			logger.debug("updateValue {}", delValue);
    			holidayMapper.deleteHoliday(delValue);
    		}
    		delSuccess = true;
		}else{
			delSuccess = false;
		}
		return delSuccess;
	}
	
	
	@Override
	public boolean  insertCTAssign(List<Object> updList,Map<String , Object> formMap) {
		Map<String, Object>  insertValue = null;
		for(int i=0; i< updList.size(); i++){
			insertValue = (Map<String, Object>) updList.get(i);
			insertValue.put("holidayType",(formMap.get("holidayType").toString()).substring(0, 1));
			insertValue.put("holiday", formMap.get("holiday"));
			insertValue.put("branchName", formMap.get("branchName"));
			insertValue.put("holidayDesc", formMap.get("holidayDesc") != null ?formMap.get("holidayDesc"):"" );
			insertValue.put("holidaySeq", Integer.parseInt(formMap.get("holidaySeq").toString()));
			insertValue.put("state", formMap.get("state"));
			//holidaySeq1과 asignSeq 둘다 값이 있으면 inset 되어있다. 
			List<EgovMap> CTInfo = holidayMapper.selectCTInfo(insertValue);
		
			if(CTInfo.size() >  0){
				logger.debug("NO NO");
			}else{
				logger.debug("insertValue {}", insertValue);
				holidayMapper.insertCTAssign(insertValue);
			}
		}
		return true;
	}
	
	@Override
	public List<EgovMap> selectAssignCTList(Map<String, Object> params) {
		params.put("holidayType",(params.get("holidayType").toString()).substring(0, 1));	
		logger.debug("insertValue {}",params);
		return holidayMapper.selectAssignCTList(params);
	}
	
	public boolean  deleteCTAssign(List<Object> delList,Map<String , Object> formMap) {
		Map<String, Object>  delValue = null;
		for(int i=0; i< delList.size(); i++){
			delValue = (Map<String, Object>) delList.get(i);
			delValue.put("holidayType", (formMap.get("holidayType").toString()).substring(0, 1));
			delValue.put("holiday", formMap.get("holiday"));
			delValue.put("branchName", formMap.get("branchName"));
			delValue.put("holidayDesc", formMap.get("holidayDesc") != null ?formMap.get("holidayDesc"):"" );
			delValue.put("holidaySeq", Integer.parseInt(formMap.get("holidaySeq").toString()));
			logger.debug("delValue {}", delValue);
			holidayMapper.deleteCTAssign(delValue);
		}
		
		return true;
	}
	
	@Override
	public List<EgovMap> selectState() {
		return holidayMapper.selectState();
	}
	
	@Override
	public List<EgovMap> selectBranch() {
		return holidayMapper.selectBranch();
	}
	
	@Override 
	public List<EgovMap> selectCity(Map<String, Object> params) {
		return holidayMapper.selectCity(params);
	}

	@Override
	public List<EgovMap> selectBranchWithNM() {
		
		return holidayMapper.selectBranchWithNM();
	}

	@Override
	public boolean checkBeforeToday(Map<String, Object> insertValue) {
		Map<String, Object>  checkValue = null;
		
		checkValue = holidayMapper.selectBeforeToday(insertValue);
		
		String checkDate = checkValue.get("checkdate").toString();
		
		
		// 오늘 날짜보다 느리다
		if(checkDate.equals("t")){
			
			return true;
		}
		else return false;
		
		
		
	}

	@Override
	public boolean checkAlreadyHoliday(Map<String, Object> insertValue) {
		List<EgovMap>  checkValue = null;
		checkValue = holidayMapper.selectAlreadyHoliday(insertValue);
		
		//중복 날짜 존재
		if(checkValue != null  && checkValue.size() != 0){
			
			return true;
		}
		else return false;
	}

	@Override
	public boolean updateAppltype(Map<String, Object> params) {
		EgovMap isInput;
		if(params.get("update[0][applCode]")!= null ){
    		if(params.get("update[0][applCode]").equals("Working")){
    			String applType = (params.get("update[0][applCode]").toString()).substring(0, 1);
    			params.put("applType", applType);
    			params.put("holidayType", (params.get("holidayType").toString()).substring(0, 1) );
    			 isInput = holidayMapper.selectApplType(params);
    			if(isInput != null && isInput.size() > 0 ){
    				//이미 들어가있다
    				
    				
    			}
    			else{
    				holidayMapper.insertApplType(params);
    			}
    		
    		}
    		else{
    			params.put("holidayType", (params.get("holidayType").toString()).substring(0, 1) );
    			isInput = holidayMapper.selectApplType(params);
    			
    			if(isInput != null && isInput.size() > 0 ){
    				holidayMapper.deleteApplType(params);
    				
    			}
    			
    			
    		}
    	}
		
		
		return false;
	}
	
	
	
}
