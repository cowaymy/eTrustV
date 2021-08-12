package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ChartService {

	List<EgovMap> getSalesKeyInAnalysis(Map<String, Object> params);

	List<EgovMap> getNetSalesChart(Map<String, Object> params);

	List<EgovMap> getSalesMonth(Map<String, Object> params);

	List<EgovMap> getWpSales(Map<String, Object> params);
}
