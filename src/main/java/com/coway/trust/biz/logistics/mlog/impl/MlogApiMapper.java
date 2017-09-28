package com.coway.trust.biz.logistics.mlog.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("MlogApiMapper")
public interface MlogApiMapper {
	
	List<EgovMap> getCTStockList(Map<String, Object> params);
	
	List<EgovMap> getRDCStockList(Map<String, Object> params);
	
	List<EgovMap> getAllStockList(Map<String, Object> params);
	
	List<EgovMap> selectPartsStockHolder(Map<String, Object> params);
	
	List<EgovMap> StockReceiveList(Map<String, Object> params);
	
	List<EgovMap> selectStockReceiveSerial(Map<String, Object> params);

}
