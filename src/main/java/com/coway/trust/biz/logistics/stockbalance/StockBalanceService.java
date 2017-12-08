package com.coway.trust.biz.logistics.stockbalance;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface StockBalanceService {

	List<EgovMap> selectLocation(Map<String, Object> params);
	
	List<EgovMap> stockBalanceSearchList(Map<String, Object> params);
	
	List<EgovMap> stockBalanceMovementType(Map<String, Object> params);
}
