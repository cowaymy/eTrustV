package com.coway.trust.biz.eAccounting.creditCard.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("creditCardAllowancePlanMapper")
public interface CreditCardAllowancePlanMapper {
	List<EgovMap> getCreditCardHolderList(Map<String, Object> params);
	List<EgovMap> getAllowanceLimitDetailPlanList(Map<String, Object> params);
	List<EgovMap> checkInBetweenAllowanceLimitDetailExist(Map<String, Object> params);
	List<EgovMap> checkUpcomingAllowanceLimitDetailExist(Map<String, Object> params);
	List<EgovMap> checkIfAllowanceLimitDetailStartDateExist(Map<String, Object> params);
	int updateAllowanceLimitDetail(Map<String, Object> params);
	int updateAllowanceLimitDetailAmount(Map<String, Object> params);
	int insertAllowanceLimitDetail(Map<String, Object> params);
	int removeAllowanceLimitDetail(Map<String, Object> params);
	EgovMap getCreditCardHolderDetail(Map<String, Object> params);
	EgovMap getAllowanceLimitDetailPlan(Map<String, Object> params);
	EgovMap getAllowanceLimitDetailPlanBefore(Map<String, Object> params);
	EgovMap getAllowanceLimitDetailPlanAfter(Map<String, Object> params);
}
