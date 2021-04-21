package com.coway.trust.biz.logistics.calendar.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.calendar.CalendarService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("calendarService")
public class CalendarServiceImpl implements CalendarService {

	@Resource(name = "calendarMapper")
	private CalendarMapper calendarMapper;

	private static final Logger logger = LoggerFactory.getLogger(CalendarServiceImpl.class);

	@Override
	public List<EgovMap> selectCalendarEventList(Map<String, Object> params) {
		return calendarMapper.selectCalendarEventList(params);
	}
}
