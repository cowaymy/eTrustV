package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("otdStatusManagementMapper")
public interface OtdStatusManagementMapper {
	List<EgovMap> selectOtdStatus(Map<String, Object> params);
}