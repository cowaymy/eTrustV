package com.coway.trust.biz.scm;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AccInvenOntimeService 
{
	//On-Time Delivery
	List<EgovMap> selectOnTimeMonthly(Map<String, Object> params);
	List<EgovMap> selectOnTimeWeeklyStartPoint(Map<String, Object> params);
	List<EgovMap> selectOnTimeCalculStatus(Map<String, Object> params);
	List<EgovMap> selectOnTimeWeeklyList(Map<String, Object> params);
	List<EgovMap> selectOnTimeDeliverySearch(Map<String, Object> params);
	
}
