package com.coway.trust.biz.services.report.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ASReportMapper")
public interface ASReportMapper {

	List<EgovMap> selectMemberCodeList();
	
	EgovMap selectOrderNum();
}
