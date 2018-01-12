package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface DailyCollectionService
{
	/**
	 * 
	 * @param params
	 * @return
	 */
    int countDailyCollectionData(Map<String, Object> params);
}
