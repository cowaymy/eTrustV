package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.servicePlanning.CTSubGroupListService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.commission.CommissionConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("CTSubGroupListService")
public class CTSubGroupListServiceImpl  extends EgovAbstractServiceImpl implements CTSubGroupListService{
	private static final Logger logger = LoggerFactory.getLogger(CTSubGroupListService.class);
	
	@Resource(name = "CTSubGroupListMapper")
	private CTSubGroupListMapper CTSubGroupListMapper;
	
	@Override
	public List<EgovMap> selectCTSubGroupList(Map<String, Object> params) {
		return CTSubGroupListMapper.selectCTSubGroupList(params);
	}

	@Override
	public List<EgovMap> selectCTAreaSubGroupList(Map<String, Object> params) {
		return CTSubGroupListMapper.selectCTAreaSubGroupList(params);
	}
	
	@Override
	public List<EgovMap> selectCTSubGroupDscList(Map<String, Object> params) {
		return CTSubGroupListMapper.selectCTSubGroupDscList(params);
	}
	
	@Override
	public List<EgovMap> selectCTM(Map<String, Object> params) {
		return CTSubGroupListMapper.selectCTM(params);
	}
	
	@Override
	public void insertCTSubGroup(List<Object> params) {
		for(int i=0; i< params.size(); i++){
			Map<String, Object>  insertValue = (Map<String, Object>) params.get(i);
			logger.debug("insertValue {}", insertValue);
			CTSubGroupListMapper.insertCTSubGroup(insertValue);
		}
	}
	
	@Override
	public void updateCTSubGroupByExcel(List<Map<String, Object>> updateList) {
		for(int i=0; i< updateList.size(); i++){
			Map<String, Object>  insertValue = (Map<String, Object>) updateList.get(i);
			logger.debug("insertValue {}", insertValue);
			CTSubGroupListMapper.insertCTSubGroup(insertValue);
		}
	}
	
	@Override
	public void insertCTSubAreaGroup(List<Object> params) {
		for(int i=0; i< params.size(); i++){
			Map<String, Object>  insertValue = (Map<String, Object>) params.get(i);
			if(insertValue.get("locType").toString().equals("Local")){
				insertValue.put("locType", "L");
				insertValue.put("serviceWeek", 0);
			}else{
				insertValue.put("locType", "O");
				if(insertValue.get("svcWeek") != null){
					insertValue.put("serviceWeek", Integer.parseInt(insertValue.get("svcWeek").toString()));
				}
			}
			logger.debug("insertValue {}", insertValue);
			CTSubGroupListMapper.insertCTSubAreaGroup(insertValue);
		}
	}
	
	@Override
	public void updateCTAreaByExcel(List<Map<String, Object>> updateList) {
		for(int i=0; i< updateList.size(); i++){
			Map<String, Object>  insertValue = (Map<String, Object>) updateList.get(i);
			if(insertValue.get("locType").toString().equals("Local")){
				insertValue.put("locType", "L");
				insertValue.put("serviceWeek", 0);
			}else{
				insertValue.put("locType", "O");
				if(insertValue.get("svcWeek") != null){
					insertValue.put("serviceWeek", Integer.parseInt(insertValue.get("svcWeek").toString()));
				}
			}
			logger.debug("insertValue {}", insertValue);
			CTSubGroupListMapper.insertCTSubAreaGroup(insertValue);
		}
	}

	@Override
	public List<EgovMap> selectCTMByDSC(Map<String, Object> params) {

		return CTSubGroupListMapper.selectCTMByDSC(params);
	}

	@Override
	public List<EgovMap> selectCTSubGrb(Map<String, Object> params) {
		
		return CTSubGroupListMapper.selectCTSubGrb(params);
	}

	@Override
	public List<EgovMap> selectCTSubGroupMajor(Map<String, Object> params) {
		
		return CTSubGroupListMapper.selectCTSubGroupMajor(params);
	}

	@Override
	public int ctSubGroupSave(Map<String, Object> params, SessionVO sessionVO) {
		int cnt = 0;
		// user id 빼기
		params.put("userId", sessionVO.getUserId());
		
		// 1.subgroup 
		List<Object> subGroups = (List<Object>) params.get("subGroupList");
		Map<String, Object>  insertValue = null;
		List<String> insertSubgrps = new ArrayList<String>();
		if(subGroups != null && subGroups.size() != 0){
    		for(int i=0; i< subGroups.size(); i++){
    			insertValue = (Map<String, Object>) subGroups.get(i);
    			insertValue.put("memId", params.get("memId"));
    			insertValue.put("userId", params.get("userId"));
    			
    			insertSubgrps.add(insertValue.get("ctSubGrp").toString());
    			
    			// 이미 있나 확인 
    			EgovMap ctSubGroup = CTSubGroupListMapper.selectOneCTSubGrb(insertValue);
    			if( ctSubGroup != null && ctSubGroup.size() != 0){
    				continue;
    			}
    			else {
    				CTSubGroupListMapper.insertSvc0054m(insertValue); 
    			}
    			
    			
    		}
    		// 세이브 한거 이외 있으면 지워 주기
    		insertValue.put("insertSubgrps", insertSubgrps);
    		logger.debug("{}",  insertValue);
    		List<EgovMap> isDelete = CTSubGroupListMapper.selectNotChooseCTSubGrb(insertValue);
    		
    		if(isDelete != null && isDelete.size() != 0 ){
    			CTSubGroupListMapper.deleteSvc0054m(insertValue);
    		}
    	}
		else{
			//없으면 다지우기
			CTSubGroupListMapper.deleteSvc0054m(params);
			
		}
		
		  
        		//2.mainGroup 이미 있나 확인
		      String isMain = (String) params.get("mainGroup");
				if( isMain != null && isMain != ""){
            		EgovMap mainGroup =CTSubGroupListMapper.selectOneMainGroup(params);
            		if( mainGroup != null && mainGroup.size() != 0){
            			//이미 존재, 같은 메인
            			
            		}
            		else{
            			// 앞에서 넣어줬을 경우, 이미 있는 경우 
            			EgovMap ctSubGroup = CTSubGroupListMapper.selectAlreadyCTSubGrb(params);
            			if( ctSubGroup != null && ctSubGroup.size() != 0){
            			//업데이트, 앞에서 넣어줬을경우
            				CTSubGroupListMapper.updateMajorgroup(params);
            			}
            			else{
            			 //넣어주기 
            				CTSubGroupListMapper.insertMajorgroup(params);
            				
            			}
            		}
				}
        		// 선택 안된거는 다지우기 
        		CTSubGroupListMapper.updateNotMajorGroup(params);
		 
		return 0;
	}


	
}
