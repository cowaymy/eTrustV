/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.giandgrdetail;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface GiAndGrDetailService
{

	List<EgovMap> selectLocation(Map<String, Object> params);

	List<EgovMap> giAndGrDetailSearchList(Map<String, Object> params);

//	List<EgovMap> selectStockBalanceDetailsList(Map<String, Object> params);
//
//	List<EgovMap> stockBalanceMovementType(Map<String, Object> params);

}