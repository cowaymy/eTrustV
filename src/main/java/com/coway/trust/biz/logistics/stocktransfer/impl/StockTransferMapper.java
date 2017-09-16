package com.coway.trust.biz.logistics.stocktransfer.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("stockTranMapper")
public interface StockTransferMapper {
	List<EgovMap> selectStockTransferMainList(Map<String, Object> params);

	List<EgovMap> selectStockTransferDeliveryList(Map<String, Object> params);

	String selectStockTransferSeq();

	void insStockTransferHead(Map<String, Object> params);

	void insStockTransfer(Map<String, Object> params);

	void updStockTransfer(Map<String, Object> params);

	List<EgovMap> selectStockTransferNoList();

	List<EgovMap> selectDeliveryNoList();

	Map<String, Object> selectStockTransferHead(String param);

	List<EgovMap> selectStockTransferItem(String param);

	Map<String, Object> stockTransferItemDeliveryQty(Map<String, Object> params);

	List<EgovMap> selectStockTransferToItem(Map<String, Object> params);

	String selectDeliveryStockTransferSeq();

	void deliveryStockTransferIns(Map<String, Object> params);

	void deliveryStockTransferDetailIns(Map<String, Object> params);

	String selectDeliveryNobyReqsNo(Map<String, Object> params);

	void StockTransferItmDel(Map<String, Object> params);

	void deliveryStockTransferItmDel(Map<String, Object> params);

	void StockTransferiSsue(Map<String, Object> params);

	void StockTransferCancelIssue(Map<String, Object> params);

	List<EgovMap> selectStockTransferMtrDocInfoList(Map<String, Object> params);
	
	void updateRequestTransfer(String param);
	
	void insertStockBooking(Map<String, Object> params);
}
