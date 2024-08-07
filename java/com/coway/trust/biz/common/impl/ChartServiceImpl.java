package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.ChartService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("chartService")
public class ChartServiceImpl implements ChartService {

	@Autowired
	private ChartMapper chartMapper;

	@Override
	public List<EgovMap> getSalesKeyInAnalysis(Map<String, Object> params) {
		chartMapper.selectSalesKeyInAnalysis(params);
		return (List<EgovMap>) params.get("chartData");
	}

	@Override
	public List<EgovMap> getNetSalesChart(Map<String, Object> params) {
		chartMapper.selectNetSalesChart(params);
		return (List<EgovMap>) params.get("chartData");
	}

	@Override
    public List<EgovMap> getSalesMonth(Map<String, Object> params) {
        return chartMapper.getSalesMonth(params);
    }

	@Override
	public List<EgovMap> getWpSales(Map<String, Object> params) {
        return chartMapper.getWpSales(params);
    }
}
