package com.coway.trust.biz.logistics.mlog;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.logistics.mlog.vo.StrockMovementVoForMobile;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MlogApiService {

	List<EgovMap> getRDCStockList(Map<String, Object> params);

	List<EgovMap> getStockbyHolderList(Map<String, Object> params);
	
	List<EgovMap> getStockbyHolderQty(Map<String, Object> params);
	
	List<EgovMap> getCt_CodyList(Map<String, Object> params);

	List<EgovMap> getAllStockList(Map<String, Object> params);

	List<EgovMap> getInventoryStockByHolder(Map<String, Object> params);

	List<EgovMap> StockReceiveList(Map<String, Object> params);

	List<EgovMap> selectStockReceiveSerial(Map<String, Object> params);
	
	List<EgovMap> getMyStockList(Map<String, Object> params);
	

	/**
	 * 현창배 추가
	 * 
	 * @param params
	 * @return
	 */
	List<EgovMap> getBarcodeList(Map<String, Object> params);

	List<EgovMap> getNonBarcodeList(Map<String, Object> params);

	List<EgovMap> getStockAuditResult(Map<String, Object> params);

	List<EgovMap> getStockPriceList(Map<String, Object> params);// 완

	List<StrockMovementVoForMobile> getStockRequestStatusHeader(Map<String, Object> params);

	List<StrockMovementVoForMobile> getRequestStatusParts(Map<String, Object> setMap);

}
