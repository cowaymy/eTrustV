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
	
	List<EgovMap> getStockTransferReqStatusMList(Map<String, Object> params);

	List<EgovMap> getStockTransferReqStatusDList(Map<String, Object> params);
	
	List<EgovMap> getNonBarcodeM(Map<String, Object> params);
	
	List<EgovMap> getNonBarcodeDList(String invenAdjustLocId);
	
	List<EgovMap> getBarcodeDList(String invenAdjustLocId);
	
	List<EgovMap> getBarcodeCList(String invenAdjustLocId);
	
	
	/**
	 * 현창배 추가
	 * 
	 * @param params
	 * @return
	 */

	List<EgovMap> getStockAuditResult(Map<String, Object> params);

	//List<EgovMap> getNonBarcodeList(Map<String, Object> params);

//	List<EgovMap> getBarcodeList(Map<String, Object> params);

	List<EgovMap> getStockPriceList(Map<String, Object> params);

//	List<StrockMovementVoForMobile> getStockRequestStatusHeader(Map<String, Object> params);
//
//	List<StrockMovementVoForMobile> getRequestStatusParts(Map<String, Object> setMap);
	
	/**
	 * 인서트 추가
	 * 
	 * @param params
	 * @return
	 */
	
	String selectStockMovementSeq();
	
	String selectDeliveryStockMovementSeq();
	
	void insStockMovementHead(Map<String, Object> fMap);
	
	void insStockMovementDetail(Map<String, Object> fMap);
	
	void insertStockBooking(Map<String, Object> fMap);
	
	void insertDeliveryStockMovementDetail(Map<String, Object> tmpMap);
	
	void insertMovementSerial(Map<String, Object> tmpMap);
	
	void insertDeliveryStockMovement(Map<String, Object> tmpMap);
	
	void updateRequestMovement(Map<String, Object> tmpMap);
	
	List<EgovMap> selectStockMovementSerial(Map<String, Object> params);
	
}
