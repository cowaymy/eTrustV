package com.coway.trust.web.logistics.calendar;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Response;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.logistics.calendar.CalendarService;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/calendar")
public class CalendarController {

	private static final Logger logger = LoggerFactory.getLogger(CalendarController.class);

	@Resource(name = "calendarService")
	private CalendarService calendarService;

	@RequestMapping(value = "/initCalendar.do")
	public String initCalendar(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

		logger.debug("==== initCalendar Params: " + params.toString());

		// set calendar to default displaying current month's events
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.DAY_OF_MONTH, 1);

		int dayOfWeekFirstDt = cal.get(Calendar.DAY_OF_WEEK) - 1; //minus one as calendar will show MON instead of SUN on first column
		int lastDateOfMonth = cal.getActualMaximum(Calendar.DATE);
		int calMonth = cal.get(Calendar.MONTH) + 1; //plus one because MONTH index begins with 0
		int calYear = cal.get(Calendar.YEAR);

		String prefixMonth = "";
		if(calMonth < 10) {
			prefixMonth = "0";
		}

		String monthYear = prefixMonth + calMonth + "/" + calYear;

		params.put("calMonth", monthYear);

		List<EgovMap> eventList = calendarService.selectCalendarEventList(params);

		String eventListJsonStr = new Gson().toJson(eventList);

		model.put("eventListJsonStr", eventListJsonStr);
		model.put("dayOfWeekFirstDt", dayOfWeekFirstDt);
		model.put("lastDateOfMonth", lastDateOfMonth);

		return "logistics/calendar/initCalendar";
	}

	@RequestMapping(value = "/selectCalendarEvents.do", method = RequestMethod.POST)
	public String selectCalendarEvents(@RequestParam Map<String, Object> params
			, HttpServletRequest request, ModelMap model) throws Exception  {

		logger.debug("==== selectCalendarEvents Params: " + params.toString());

		List<EgovMap> eventList = calendarService.selectCalendarEventList(params);

		String firstDayOfMonth = "01/" + (String) params.get("calMonth"); //Example: 01/05/2020
		Date firstDayOfMonthDt = new SimpleDateFormat("dd/MM/yyyy").parse(firstDayOfMonth);

		Calendar cal = Calendar.getInstance();
		cal.setTime(firstDayOfMonthDt);

		int dayOfWeekFirstDt = cal.get(Calendar.DAY_OF_WEEK) - 1;//minus one as calendar will show MON instead of SUN on first column
		int lastDateOfMonth = cal.getActualMaximum(Calendar.DATE);

		String eventListJsonStr = new Gson().toJson(eventList);

		model.put("eventListJsonStr", eventListJsonStr);
		model.put("dayOfWeekFirstDt", dayOfWeekFirstDt);
		model.put("lastDateOfMonth", lastDateOfMonth);

		return "/logistics/calendar/initCalendar";
	}
}
