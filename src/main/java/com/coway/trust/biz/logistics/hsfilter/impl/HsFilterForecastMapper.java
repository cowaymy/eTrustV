
package com.coway.trust.biz.logistics.hsfilter.impl;

import java.util.List;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HsFilterForecastMapper")
public interface HsFilterForecastMapper{

	List<EgovMap> selectHSFilterForecastyList(Map<String, Object> params);


}
