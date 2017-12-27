package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("servicesLogisticsPFCMapper")

public interface ServicesLogisticsPFCMapper {
  
	 Map<String, Object>   SP_LOGISTIC_REQUEST(Map<String, Object> param);
	 Map<String, Object>   SP_LOGISTIC_REQUEST_REVERSE(Map<String, Object> param);
	 Map<String, Object>   SP_SVC_LOGISTIC_REQUEST(Map<String, Object> param);
	 void install_Active_SP_LOGISTIC_REQUEST(Map<String, Object> param);
	 
	 
	  
}
