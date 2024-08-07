/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.stockbalance.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("StockBalanceMapper")
public interface StockBalanceMapper
{

	List<EgovMap> selectLocation(Map<String, Object> params);

	List<EgovMap> stockBalanceSearchList(Map<String, Object> params);

	List<EgovMap> selectStockBalanceDetailsList(Map<String, Object> params);

	List<EgovMap> stockBalanceMovementType(Map<String, Object> params);

}