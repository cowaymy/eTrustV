package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("customerMobileContactUpdateMapper")
public interface CustomerMobileContactUpdateMapper {

	List<EgovMap> selectMobileUpdateJsonList(Map<String, Object> params);
	EgovMap selectMobileUpdateDetail(Map<String, Object> params);
	void updateAppvStatusSAL0329D(Map<String, Object> params) throws Exception;
	void updateAppvStatusSAL0027D(Map<String, Object> params) throws Exception;
}
