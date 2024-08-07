/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.giandgrdetail.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("GiAndGrDetailMapper")
public interface GiAndGrDetailMapper
{

	List<EgovMap> selectLocation(Map<String, Object> params);

	List<EgovMap> giAndGrDetailSearchList(Map<String, Object> params);

//	List<EgovMap> selectStockBalanceDetailsList(Map<String, Object> params);
//
//	List<EgovMap> stockBalanceMovementType(Map<String, Object> params);

}