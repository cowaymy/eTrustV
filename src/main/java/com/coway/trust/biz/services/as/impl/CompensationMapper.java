package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("CompensationMapper")
public interface CompensationMapper {
	
	List<EgovMap> selCompensationList(Map<String, Object> params);
	 
	 
	 
}
