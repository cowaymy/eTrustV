/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.stocktransfer;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface StockTransferService {
	List<EgovMap> selectStockTransferMainList(Map<String, Object> params);
	
	void insertStockTransferInfo(Map<String, Object> params);
	
	void addStockTransferInfo(Map<String, Object> params);
	
	List<EgovMap> selectStockTransferNoList();
	
	Map<String, Object> StocktransferDataDetail(String param);
	
	int stockTransferItemDeliveryQty(Map<String, Object> params);
	
	List<EgovMap> selectTolocationItemList(Map<String, Object> params);
	
	void deliveryStockTransferInfo(Map<String, Object> params);
}