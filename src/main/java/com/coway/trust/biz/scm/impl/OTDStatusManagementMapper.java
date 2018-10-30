package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("OTDStatusManagementMapper")
public interface OTDStatusManagementMapper
{
	//	OTD Status Report
	List<EgovMap> selectOTDStatus(Map<String, Object> params);
}