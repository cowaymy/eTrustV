package com.coway.trust.biz.services.as.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Mapper("PreASManagementListMapper")
public interface PreASManagementListMapper {

	List<EgovMap> selectPreASManagementList(Map<String, Object> params);

	List<EgovMap> selectPreAsStat();

	void updateRejectedPreAS(Map<String, Object> params);

}
