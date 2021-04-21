package com.coway.trust.biz.logistics.calendar.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("calendarMapper")
public interface CalendarMapper {

	List<EgovMap> selectCalendarEventList(Map<String, Object> params);

}
