package com.coway.trust.biz.sales.analysis.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("analysisMapper")
public interface AnalysisMapper {

	EgovMap maintanceSession();
	
}
