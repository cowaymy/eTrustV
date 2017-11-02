package com.coway.trust.biz.scm.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("accInvenOntimeMapper")
public interface AccInvenOntimeMapper 
{

	// 	//On-Time Delivery
	List<EgovMap> selectOnTimeMonthly(Map<String, Object> params);
	List<EgovMap> selectOnTimeWeeklyStartPoint(Map<String, Object> params);
	List<EgovMap> selectOnTimeCalculStatus(Map<String, Object> params);
	List<EgovMap> selectOnTimeWeeklyList(Map<String, Object> params);
	
	List<EgovMap> selectOnTimeDeliverySearch(Map<String, Object> params);


}
