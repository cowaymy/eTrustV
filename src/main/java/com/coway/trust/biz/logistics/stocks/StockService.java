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

	void updateStockPriceInfo(Map<String, Object> params);

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

	List<EgovMap> selectCodeList();

	void modifyEosEomInfo(Map<String, Object> params);

	List<EgovMap> getEosEomInfo(Map<String, Object> params);

	List<EgovMap> selectCodeList2();

	void updatePriceInfo2(Map<String, Object> params);

	List<EgovMap> selectPriceInfo2(Map<String, Object> params);

	List<EgovMap> selectPriceHistoryInfo2(Map<String, Object> params);

	void insertSalePriceReqst(Map<String, Object> params);

	int countInPrgrsPrcApproval(Map<String, Object> params);

	void updatePriceReqstApproval(Map<String, Object> params);

}
