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
	
	@Override
	public List<EgovMap> selectHSReportGroup(Map<String, Object> params) {
		return HSReportMapper.selectHSReportGroup(params);
	}
	
	@Override
	public List<EgovMap> selectCMGroupList(Map<String, Object> params) {
		return HSReportMapper.selectCMGroupList(params);
	}
	
	@Override
	public List<EgovMap> selectCodyList(Map<String, Object> params) {
		return HSReportMapper.selectCodyList(params);
	}
	
	@Override
	public List<EgovMap> selectReportBranchCodeList(Map<String, Object> params) {
		return HSReportMapper.selectReportBranchCodeList(params);
	}

	
	@Override
	public List<EgovMap> selectDeptCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HSReportMapper.selectDeptCodeList(params);
	}

	@Override
	public List<EgovMap> selectDscCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HSReportMapper.selectDscCodeList(params);
	}

	@Override
	public List<EgovMap> selectInsStatusList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HSReportMapper.selectInsStatusList(params);
	}

	@Override
	public List<EgovMap> selectCodyCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HSReportMapper.selectCodyCodeList(params);
	}


	@Override
	public List<EgovMap> selectAreaCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HSReportMapper.selectAreaCodeList(params);
	}
}
