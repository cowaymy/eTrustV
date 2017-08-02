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
	List<EgovMap>selectStockTransferList(Map<String, Object> params);
	
	void updateStockTransferInfo(Map<String, Object> params);
	
}