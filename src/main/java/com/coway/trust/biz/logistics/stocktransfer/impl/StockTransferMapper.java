package com.coway.trust.biz.logistics.stocktransfer.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("stockTranMapper")
public interface StockTransferMapper {
	List<EgovMap> selectStockTransferList(Map<String, Object> params);
	
	String selectStockTransferSeq();
	
	void insStockTransferHead(Map<String, Object> params);
	
	void insStockTransfer(Map<String, Object> params);
	
	void updStockTransfer(Map<String, Object> params);
}
