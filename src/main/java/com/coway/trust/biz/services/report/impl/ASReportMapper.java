package com.coway.trust.biz.services.report.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ASReportMapper")
public interface ASReportMapper {

	/*
	 *BY KV - branch - CT add params
	 */
	List<EgovMap> selectMemberCodeList(Map<String, Object> params);

	EgovMap selectOrderNum();

	List<EgovMap> selectViewLedger(Map<String, Object> params);

	List<EgovMap> selectMemCodeList();
}
