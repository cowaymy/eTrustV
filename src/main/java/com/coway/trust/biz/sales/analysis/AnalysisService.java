package com.coway.trust.biz.sales.analysis;

import java.util.List;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AnalysisService {

	EgovMap maintanceSession();

	List<EgovMap> selectPltvProductCodeList();

	String selectMaxAccYm();
}
