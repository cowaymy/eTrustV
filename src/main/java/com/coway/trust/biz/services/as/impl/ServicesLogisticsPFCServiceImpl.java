package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("servicesLogisticsPFCService")
public class  ServicesLogisticsPFCServiceImpl  extends EgovAbstractServiceImpl implements ServicesLogisticsPFCService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ServicesLogisticsPFCServiceImpl.class);
	
	@Resource(name = "servicesLogisticsPFCMapper")
	private ServicesLogisticsPFCMapper  servicesLogisticsPFCMapper;
	 
	
	@Override
	public EgovMap  SP_LOGISTIC_REQUEST(Map<String, Object> params) {
		return (EgovMap) servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(params);
	}  
	   
	
	@Override
	public EgovMap SP_SVC_LOGISTIC_REQUEST(Map<String, Object> params) {
		return (EgovMap) servicesLogisticsPFCMapper.SP_SVC_LOGISTIC_REQUEST(params);
	}  
	 
	
	@Override
	public  void  install_Active_SP_LOGISTIC_REQUEST(Map<String, Object> params) {
		 servicesLogisticsPFCMapper.install_Active_SP_LOGISTIC_REQUEST(params);
	}  
	 
	
	
} 


