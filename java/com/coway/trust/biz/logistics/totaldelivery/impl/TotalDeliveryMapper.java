/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.totaldelivery.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("TotalDeliveryMapper")
public interface TotalDeliveryMapper
{

	List<EgovMap> selectTotalDeliveryList(Map<String, Object> params);

}