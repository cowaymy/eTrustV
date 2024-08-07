/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.totaldelivery;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TotalDeliveryService
{

	List<EgovMap> selectTotalDeliveryList(Map<String, Object> params);

}