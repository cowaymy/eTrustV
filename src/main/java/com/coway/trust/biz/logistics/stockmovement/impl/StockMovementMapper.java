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

}
