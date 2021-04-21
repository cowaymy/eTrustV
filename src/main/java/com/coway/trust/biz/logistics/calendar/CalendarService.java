package com.coway.trust.biz.logistics.calendar;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CalendarService {

	List<EgovMap> selectCalendarEventList(Map<String, Object> params);

}
