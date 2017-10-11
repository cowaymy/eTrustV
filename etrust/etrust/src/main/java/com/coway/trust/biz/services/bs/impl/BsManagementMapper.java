package com.coway.trust.biz.services.bs.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("bsManagementMapper")
public interface BsManagementMapper {

	List<EgovMap> selectBsManagementList(Map<String, Object> params);

	List<EgovMap> selectBsStateList(Map<String, Object> params);
	
	List<EgovMap> selectAreaList(Map<String, Object> params);

}
