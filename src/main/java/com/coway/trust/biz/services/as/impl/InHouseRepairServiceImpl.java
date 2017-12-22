package com.coway.trust.biz.services.as.impl;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.as.InHouseRepairService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import oracle.sql.DATE;

@Service("InHouseRepairService")
public class  InHouseRepairServiceImpl  extends EgovAbstractServiceImpl implements InHouseRepairService{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(InHouseRepairServiceImpl.class);
	
	@Resource(name = "InHouseRepairMapper")
	private InHouseRepairMapper inHouseRepairMapper;
	
	@Override
	public List<EgovMap> selInhouseList(Map<String, Object> params) {
		return inHouseRepairMapper.selInhouseList(params);
	}  
	 
	
	@Override
	public List<EgovMap> selInhouseDetailList(Map<String, Object> params) {
		return inHouseRepairMapper.selInhouseDetailList(params);
	}  
	
	
	@Override 
	public List<EgovMap> getCallLog(Map<String, Object> params) {
		return inHouseRepairMapper.getCallLog(params);
	} 
	
   
	@Override 
	public List<EgovMap> getProductDetails(Map<String, Object> params) {
		return inHouseRepairMapper.getProductDetails(params);
	}
	
 
	@Override 
	public List<EgovMap> getProductMasters(Map<String, Object> params) {
		return inHouseRepairMapper.getProductMasters(params);
	}
	
	
	@Override 
	public  EgovMap  isAbStck(Map<String, Object> params) {
		return inHouseRepairMapper.isAbStck(params);
	}
	
}
