package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.servicePlanning.CTSubGroupListService;
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


	
}
