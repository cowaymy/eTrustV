package com.coway.trust.biz.services.report;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HSReportService {

	List<EgovMap> selectHSReportSingle(Map<String, Object> params);
}
