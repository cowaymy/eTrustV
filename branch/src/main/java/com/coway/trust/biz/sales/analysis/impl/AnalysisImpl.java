package com.coway.trust.biz.sales.analysis.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.analysis.AnalysisService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("analysisService")
public class AnalysisImpl extends EgovAbstractServiceImpl implements AnalysisService{

	
	@Resource(name = "analysisMapper")
	private AnalysisMapper analysisMapper;

	@Override
	public EgovMap maintanceSession() {
		
		return analysisMapper.maintanceSession();
	}
}
