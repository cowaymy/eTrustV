package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.performanceMgmt.PerformanceReportService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("performanceReportService")
public class PerformanceReportServiceImpl  implements PerformanceReportService{

	@Resource(name = "performanceReportMapper")
	private PerformanceReportMapper performanceReportMapper;
	
	@Override
	public List<EgovMap> selectPfReportRejoin(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return performanceReportMapper.selectPfReportRejoin(params);
	}

	@Override
	public List<EgovMap> selectPfReportCollection(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return performanceReportMapper.selectPfReportCollection(params);
	}

	@Override
	public List<EgovMap> selectPfReportHeartService(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return performanceReportMapper.selectPfReportHeartService(params);
	}

	@Override
	public List<EgovMap> selectPfReportSales(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return performanceReportMapper.selectPfReportSales(params);
	}

	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params)  {
		// TODO Auto-generated method stub
		return performanceReportMapper.selectBranchList(params);
	}

	
	
	
	
}
