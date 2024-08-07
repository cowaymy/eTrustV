package com.coway.trust.biz.sales.common;

import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SalesCommonService {

	EgovMap getUserInfo(Map<String, Object> params);

	EgovMap getUserBranchType(Map<String, Object> params);

}
