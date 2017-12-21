package com.coway.trust.biz.services.report.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.report.ASReportService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ASReportService")
public class ASReportServiceimpl extends EgovAbstractServiceImpl implements ASReportService{

	@Resource(name = "ASReportMapper")
	private ASReportMapper ASReportMapper;
	
	@Override
	public List<EgovMap> selectMemberCodeList() {
		return ASReportMapper.selectMemberCodeList();
	}
	
	@Override
	public EgovMap selectOrderNum() {
		return ASReportMapper.selectOrderNum();
	}
	
	@Override
	public List<EgovMap> selectViewLedger(Map<String, Object> params) {
		return ASReportMapper.selectViewLedger(params);
	}
	
	@Override
	public List<EgovMap> selectMemCodeList() {
		return ASReportMapper.selectMemCodeList();
	}
	
}
