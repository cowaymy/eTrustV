package com.coway.trust.biz.logistics.design;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ArtworkRequestService {
	List<EgovMap> selectArtworkCategoryList(Map<String, Object> params);
	
	List<EgovMap> selectArtworkList(Map<String, Object> params);

//	List<EgovMap> selectStockTransferDeliveryList(Map<String, Object> params);
//
//	String insertStockTransferInfo(Map<String, Object> params);
//
//	List<EgovMap> addStockTransferInfo(Map<String, Object> params);
//
//	List<EgovMap> selectStockTransferNoList(Map<String, Object> params);
//
//	Map<String, Object> StocktransferDataDetail(String param);
//
//	int stockTransferItemDeliveryQty(Map<String, Object> params);
//
//	List<EgovMap> selectTolocationItemList(Map<String, Object> params);
//
//	void deliveryStockTransferInfo(Map<String, Object> params);
//
//	void deliveryStockTransferItmDel(Map<String, Object> params);
//
//	String StocktransferReqDelivery(Map<String, Object> params);
//
//	String StockTransferDeliveryIssue(Map<String, Object> params);
//
//	List<EgovMap> selectStockTransferMtrDocInfoList(Map<String, Object> params);
//
//	void insertStockBooking(Map<String, Object> params);
//
//	void StocktransferDeliveryDelete(Map<String, Object> params);
}
