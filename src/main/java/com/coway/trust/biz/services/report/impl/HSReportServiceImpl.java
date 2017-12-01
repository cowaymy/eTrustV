package com.coway.trust.biz.services.report.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.report.HSReportService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HSReportService")
public class HSReportServiceImpl extends EgovAbstractServiceImpl implements HSReportService{
	
	@Resource(name = "HSReportMapper")
	private HSReportMapper HSReportMapper;
	
	@Override
	public List<EgovMap> selectHSReportSingle(Map<String, Object> params) {
		return HSReportMapper.selectHSReportSingle(params);
	}
	
}
