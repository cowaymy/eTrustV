package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("keyinConfigMapper")
public interface KeyinConfigMapper {
	List<EgovMap> selectkeyinConfigList(Map<String, Object> params);

	void updateAllowSalesStatus(Map<String, Object> params) throws Exception;

}
