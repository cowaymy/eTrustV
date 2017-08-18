package com.coway.trust.biz.logistics.stockmovement.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("stockMoveMapper")
public interface StockMovementMapper {

	String selectStockMovementSeq();

	void insStockMovementHead(Map<String, Object> fMap);

	void insStockMovement(Map<String, Object> insMap);

	List<EgovMap> selectStockMovementNoList();

	List<EgovMap> selectDeliveryNoList();

	List<EgovMap> selectStockMovementMainList(Map<String, Object> params);

	List<EgovMap> selectStockMovementDeliveryList(Map<String, Object> params);

	List<EgovMap> selectStockMovementToItem(Map<String, Object> params);

	Map<String, Object> selectStockMovementItemDeliveryQty(Map<String, Object> params);

	List<EgovMap> selectStockMovementItem(String param);

	Map<String, Object> selectStockMovementHead(String param);

	void deleteStockMovementItm(Map<String, Object> insMap);

	void deleteDeliveryStockMovementItm(Map<String, Object> insMap);

	String selectDeliveryStockMovementSeq();

	void insertDeliveryStockMovementDetail(Map<String, Object> insMap);

	void insertDeliveryStockMovement(Map<String, Object> insMap);

}
