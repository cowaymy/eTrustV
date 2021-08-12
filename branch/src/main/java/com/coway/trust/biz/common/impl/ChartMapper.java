package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("chartMapper")
public interface ChartMapper {
	void selectSalesKeyInAnalysis(Map<String, Object> params);

	void selectNetSalesChart(Map<String, Object> params);

    List<EgovMap> getSalesMonth(Map<String, Object> params);

	List<EgovMap> getWpSales(Map<String, Object> params);
}
