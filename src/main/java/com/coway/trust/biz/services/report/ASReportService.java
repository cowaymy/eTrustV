package com.coway.trust.biz.services.report;

import java.util.List;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ASReportService {

	List<EgovMap> selectMemberCodeList();
	
	EgovMap selectOrderNum();
}
