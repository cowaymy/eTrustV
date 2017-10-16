package com.coway.trust.biz.logistics.mlog.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.logistics.mlog.vo.StrockMovementVoForMobile;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("MlogApiMapper")
public interface MlogApiMapper {

	List<EgovMap> getRDCStockList(Map<String, Object> params);

	List<EgovMap> getStockbyHolderList(Map<String, Object> params);

	List<EgovMap> getCommonQty(Map<String, Object> params);

	List<EgovMap> getCt_CodyList(Map<String, Object> params);

	List<EgovMap> getInventoryOverallStock(Map<String, Object> params);
	
	List<EgovMap> getAllStockList(Map<String, Object> params);

	List<EgovMap> getInventoryStockByHolder(Map<String, Object> params);

	List<EgovMap> StockReceiveList(Map<String, Object> params);

	List<EgovMap> selectStockReceiveSerial(Map<String, Object> params);

	List<EgovMap> getMyStockList(Map<String, Object> params);

	List<EgovMap> getReturnPartsSearch(Map<String, Object> params);

	List<EgovMap> getAlternativeFilterMList();

	List<EgovMap> getAlternativeFilterDList();

	List<EgovMap> getItemBankLocationList(Map<String, Object> params);

	List<EgovMap> getItemBankItemList();

	List<EgovMap> getCommonReqHeader(Map<String, Object> params);
	
	List<EgovMap> getCommonReqParts(Map<String, Object> params);
	
	List<EgovMap> getAuditStockResultDetail(Map<String, Object> params);

	/**
	 * 현창배 추가
	 * 
	 * @param params
	 * @return
	 */

	List<EgovMap> getStockAuditResult(Map<String, Object> params);

	List<EgovMap> getNonBarcodeList(Map<String, Object> params);

	List<EgovMap> getBarcodeList(Map<String, Object> params);

	List<EgovMap> getStockPriceList(Map<String, Object> params);

	List<StrockMovementVoForMobile> getStockRequestStatusHeader(Map<String, Object> params);

	List<StrockMovementVoForMobile> getRequestStatusParts(Map<String, Object> setMap);

}
