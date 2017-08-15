package com.coway.trust.biz.logistics.stockmovement;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface StockMovementService {

	void insertStockMovementInfo(Map<String, Object> param);

	List<EgovMap> selectStockMovementNoList(Map<String, Object> params);

	List<EgovMap> selectStockMovementMainList(Map<String, Object> params);

	List<EgovMap> selectStockMovementDeliveryList(Map<String, Object> params);

	List<EgovMap> selectTolocationItemList(Map<String, Object> smap);

}
