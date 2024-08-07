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

	void insertTransferSerial(Map<String, Object> params);

	void deliveryDelete54(Map<String, Object> params);

	void deliveryDelete55(Map<String, Object> params);

	void deliveryDelete61(Map<String, Object> params);

	void updateRequestTransfer(Map<String, Object> params);

	List<EgovMap> selectDeliverydupCheck(Map<String, Object> insMap);

	void updateStockHead(String reqstono);

	void deleteStockDelete(String reqstono);

	void deleteStockBooking(String reqstono);

	int selectdeliveryHead(String reqstono);

	int selectAvaliableStockQty(Map<String, Object> param);

	Map<String, Object> selectDelvryGRcmplt(String delyno);

	void updateDelivery54(Map<String, Object> formMap);

	String selectDefLocation(Map<String, Object> param);

	public List<EgovMap> selectStoIssuePop(Map<String, Object> params) throws Exception;

	public void stockTransferiSsueNew(Map<String, Object> params) throws Exception;

	/**
	 * Search Good Receipt Popup List
	 * @Author KR-SH
	 * @Date 2019. 12. 5.
	 * @param params
	 * @return
	 * @throws Exception
	 */
	public List<EgovMap> goodReceiptPopList(Map<String, Object> params) throws Exception;

	EgovMap selectDeliveryInsDet(Map<String, Object> params);

}
