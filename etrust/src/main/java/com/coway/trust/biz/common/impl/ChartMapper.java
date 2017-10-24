package com.coway.trust.biz.common.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("chartMapper")
public interface ChartMapper {
	void selectSalesKeyInAnalysis(Map<String, Object> params);

	void selectNetSalesChart(Map<String, Object> params);
}
