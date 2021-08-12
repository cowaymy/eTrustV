/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.giandgrstock;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface GiAndGrStockService
{

	List<EgovMap> selectLocation(Map<String, Object> params);

	List<EgovMap> stockBalanceSearchList(Map<String, Object> params);

	List<EgovMap> selectStockBalanceDetailsList(Map<String, Object> params);

	List<EgovMap> stockBalanceMovementType(Map<String, Object> params);

}