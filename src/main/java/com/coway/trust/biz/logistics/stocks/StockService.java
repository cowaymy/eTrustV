/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.stocks;


import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface StockService {

	List<EgovMap>selectStockList(Map<String, Object> params);
	
	List<EgovMap>selectStockInfo(Map<String, Object> params);
	
	List<EgovMap>selectPriceInfo(Map<String, Object> params);
	
	List<EgovMap>selectFilterInfo(Map<String, Object> params);
	
	List<EgovMap>selectServiceInfo(Map<String, Object> params);
	
	List<EgovMap>selectStockImgList(Map<String, Object> params);

}
