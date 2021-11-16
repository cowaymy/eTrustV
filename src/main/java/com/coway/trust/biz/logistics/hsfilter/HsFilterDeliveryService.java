package com.coway.trust.biz.logistics.hsfilter;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HsFilterDeliveryService{

	List<EgovMap> selectHSFilterDeliveryBranchList(Map<String, Object> params);

	List<EgovMap> selectHSFilterDeliveryList(Map<String, Object> params);

	List<EgovMap> selectHSFilterDeliveryPickingList(Map<String, Object> params);

	String insertStockTransferInfo(Map<String, Object> params);

	String StocktransferReqDelivery(List <EgovMap> params, int userId);

	List<EgovMap> selectDeliverydupCheck(Map<String, Object> insMap);

	List<EgovMap> selectStockTransferRequestItem(Map<String, Object> params);

	List<EgovMap> selectStockTransferList(Map<String, Object> params);

}
