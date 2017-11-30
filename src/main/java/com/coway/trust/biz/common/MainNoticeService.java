package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MainNoticeService {
	// MainNotice DailyCount
	List<EgovMap> selectDailyCount(Map<String, Object> params);

	List<EgovMap> getMainNotice(Map<String, Object> params);

	List<EgovMap> getTagStatus(Map<String, Object> params);

	List<EgovMap> getDailyPerformance(Map<String, Object> params);
}
