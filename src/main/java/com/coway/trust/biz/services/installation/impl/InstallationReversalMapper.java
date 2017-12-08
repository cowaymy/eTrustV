package com.coway.trust.biz.services.installation.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("installationReversalMapper")
public interface InstallationReversalMapper {
	
	List<EgovMap> selectOrderList(Map<String, Object> params);
	
	EgovMap selectOrderListDetail1(Map<String, Object> params);
	EgovMap selectOrderListDetail2(Map<String, Object> params);
	EgovMap selectOrderListDetail3(Map<String, Object> params);
	EgovMap selectOrderListDetail4(Map<String, Object> params);
	EgovMap selectOrderListDetail5(Map<String, Object> params);

}
