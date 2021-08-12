package com.coway.trust.biz.logistics.calendar;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CalendarService {

	List<EgovMap> selectCalendarEventList(Map<String, Object> params);

	int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList);

	List<EgovMap> selectEventListToManage(Map<String, Object> params);

	int updRemoveCalItem(Map<String, Object> params);

	int saveCalEventChangeList(List<Object> updList, Integer updUserId);

}
