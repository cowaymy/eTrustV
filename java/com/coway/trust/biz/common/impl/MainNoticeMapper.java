package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("MainNoticeMapper")
public interface MainNoticeMapper {
	List<EgovMap> selectDailyCount(Map<String, Object> params);

	List<EgovMap> selectMainNotice(Map<String, Object> params);

	List<EgovMap> selectTagStatus(Map<String, Object> params);

	List<EgovMap> selectDailyPerformance(Map<String, Object> params);

	List<EgovMap> selectSalesOrgPerf(Map<String, Object> params);

	List<EgovMap> getCustomerBday(Map<String, Object> params);

	List<EgovMap> getAccRewardPoints(Map<String, Object> params);

	List<EgovMap> getHPBirthday(Map<String, Object> params);

}
