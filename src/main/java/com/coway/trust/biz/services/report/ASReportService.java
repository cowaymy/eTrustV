package com.coway.trust.biz.services.report;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ASReportService {

	List<EgovMap> selectMemberCodeList();
	
	EgovMap selectOrderNum();
	
	List<EgovMap> selectViewLedger(Map<String, Object> params);
}
