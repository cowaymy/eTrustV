package com.coway.trust.biz.services.report.impl;


import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HSReportMapper")
public interface HSReportMapper {
	
	List<EgovMap> selectHSReportSingle(Map<String, Object> params);
	
	List<EgovMap> selectHSReportGroup(Map<String, Object> params);

}
