
package com.coway.trust.biz.logistics.hsfilter.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HsFilterDeliveryMapper")
public interface HsFilterDeliveryMapper{

	List<EgovMap> selectHSFilterDeliveryBranchList(Map<String, Object> params);
	List<EgovMap> selectHSFilterDeliveryList(Map<String, Object> params);
	List<EgovMap> selectHSFilterDeliveryPickingList(Map<String, Object> params);

	List<EgovMap> selectHSFilterDeliveryPickingListCall(Map<String, Object> params);
	List<EgovMap> selectHSFilterDeliveryListCall(Map<String, Object> params);



	List<EgovMap> selectStockTransferRequestItem(Map<String, Object> params);
	List<EgovMap> selectStockTransferList(Map<String, Object> params);
	List<EgovMap> selectDeliverydupCheck(Map<String, Object> insMap);
	void deliveryStockTransferIns(Map<String, Object> params);
	void deliveryStockTransferDetailIns(Map<String, Object> params);
	void updateRequestTransfer(String param);

	String selectDeliveryStockTransferSeq();
	String  selectLocId (String prams);
	String  selectUomId (String prams);

	int updateSTONo (Map<String, Object> params);
	int updateLog109MSTONo (Map<String, Object> params);
	//chage



}
