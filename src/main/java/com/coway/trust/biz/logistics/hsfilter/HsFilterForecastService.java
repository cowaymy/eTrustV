package com.coway.trust.biz.logistics.hsfilter;

import java.util.List;

import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HsFilterForecastService{

	List<EgovMap> selectHSFilterForecastList(Map<String, Object> params);
}
