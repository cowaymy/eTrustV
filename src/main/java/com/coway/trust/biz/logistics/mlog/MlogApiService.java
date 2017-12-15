package com.coway.trust.biz.logistics.mlog;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.audit.InputBarcodePartsForm;
import com.coway.trust.api.mobile.logistics.audit.InputNonBarcodeForm;
import com.coway.trust.api.mobile.logistics.inventory.InventoryReqTransferMForm;
import com.coway.trust.api.mobile.logistics.recevie.ConfirmReceiveMForm;
import com.coway.trust.api.mobile.logistics.returnonhandstock.ReturnOnHandStockReqMForm;
import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferConfirmGiMForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MlogApiService {

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
	
	List<EgovMap> getItemBankResultList(Map<String, Object> params);
	
	List<EgovMap> getCommonReqHeader(Map<String, Object> params);
	
	List<EgovMap> getCommonReqParts(Map<String, Object> params);
	
	List<EgovMap> getAuditStockResultDetail(Map<String, Object> params);
	
	List<EgovMap> getStockTransferReqStatusMList(Map<String, Object> params);
	
	List<EgovMap> getStockTransferReqStatusDList(Map<String, Object> params);
	
	List<EgovMap> getNonBarcodeM(Map<String, Object> params);
	
	List<EgovMap> getNonBarcodeDList(String invenAdjustLocId);
	
	List<EgovMap> getBarcodeDList(String invenAdjustLocId);
	
	List<EgovMap> getBarcodeCList(String invenAdjustLocId);
	
	List<EgovMap> getUsedPartsList(Map<String, Object> params);
	
	List<EgovMap> getMiscPartList();
	
	List<EgovMap> getFilterNotChangeList(Map<String, Object> params);
	
	List<EgovMap> getFilterUserChangeList(Map<String, Object> params);

	/**
	 * 현창배 추가
	 * 
	 * @param params
	 * @return
	 */
	//List<EgovMap> getBarcodeList(Map<String, Object> params);

	//List<EgovMap> getNonBarcodeList(Map<String, Object> params);

	List<EgovMap> getStockAuditResult(Map<String, Object> params);

	List<EgovMap> getStockPriceList(Map<String, Object> params);// 완

	//List<StrockMovementVoForMobile> getStockRequestStatusHeader(Map<String, Object> params);

	//List<StrockMovementVoForMobile> getRequestStatusParts(Map<String, Object> setMap);
	
	/**
	 * 인서트 추가 
	 * 
	 * @param reqTransferMList
	 * @return
	 */
	
	void saveInvenReqTransfer(InventoryReqTransferMForm inventoryReqTransferMForm);
	
	void stockMovementReqDelivery(List<StockTransferConfirmGiMForm> stockTransferConfirmGiMForm);

	Map<String, Object> selectStockMovementSerial(Map<String, Object> params);
	
	void stockMovementConfirmReceive(ConfirmReceiveMForm confirmReceiveMForm);
	
	String stockMovementCommonCancle(Map<String, Object> params);
	
	void returnOnHandStockReq(ReturnOnHandStockReqMForm returnOnHandStockReq);
	
	void inputNonBarcode(InputNonBarcodeForm inputNonBarcodeForm);

	void inputBarcode(List<InputBarcodePartsForm> inputBarcodePartsForm);

}
