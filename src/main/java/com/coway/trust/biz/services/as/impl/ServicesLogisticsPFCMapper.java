package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("servicesLogisticsPFCMapper")

public interface ServicesLogisticsPFCMapper {
  
	 void install_Active_SP_LOGISTIC_REQUEST(Map<String, Object> param);
	  
}
