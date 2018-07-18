package com.coway.trust.biz.services.report;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ASReportService {

	/*
	 *BY KV - branch - CT add params
	 */
	List<EgovMap> selectMemberCodeList(Map<String, Object> params);

	EgovMap selectOrderNum();

	List<EgovMap> selectViewLedger(Map<String, Object> params);

	List<EgovMap> selectMemCodeList();
}
