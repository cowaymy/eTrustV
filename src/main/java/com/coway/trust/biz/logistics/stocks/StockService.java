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

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface StockService {

	List<EgovMap> selectStockList(Map<String, Object> params);

	List<EgovMap> selectStockInfo(Map<String, Object> params);

	List<EgovMap> selectPriceInfo(Map<String, Object> params);

	List<EgovMap> selectFilterInfo(Map<String, Object> params);

	List<EgovMap> selectServiceInfo(Map<String, Object> params);

	List<EgovMap> selectStockImgList(Map<String, Object> params);

	void updateStockInfo(Map<String, Object> params);
	
	void modifyServicePoint(Map<String, Object> params);

	void updatePriceInfo(Map<String, Object> params);

	List<EgovMap> srvMembershipList(Map<String, Object> params);

	int addServiceInfoGrid(int stockId, List<Object> addLIst, int loginId);

	int removeServiceInfoGrid(int stockId, List<Object> removeLIst, int loginId);

	int removeFilterInfoGrid(int stockId, List<Object> removeLIst, int loginId, String revalue);

	int addFilterInfoGrid(int stockId, List<Object> addLIst, int loginId, String revalue);

	List<EgovMap> selectPriceHistoryInfo(Map<String, Object> params);

	List<EgovMap> selectStockCommisionSetting(Map<String, Object> param);

	void updateStockCommision(Map<String, Object> params);
	
	String nonvalueStockIns(Map<String, Object> params);
	
	EgovMap nonvaluedItemCodeChk(Map<String, Object> params);

}
