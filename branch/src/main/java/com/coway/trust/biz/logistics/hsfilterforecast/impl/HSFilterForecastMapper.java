/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.hsfilterforecast.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HSFilterForecastMapper")
public interface HSFilterForecastMapper
{

	List<EgovMap> selectHSFilterForecastList(Map<String, Object> params);

	List<EgovMap> selectForecastDetailsList(Map<String, Object> params);

}
