package com.coway.trust.web.logistics.calendar;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.calendar.CalendarEventVO;
import com.coway.trust.biz.logistics.calendar.CalendarService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/calendar")
public class CalendarController {

	private static final Logger logger = LoggerFactory.getLogger(CalendarController.class);

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Resource(name = "calendarService")
	private CalendarService calendarService;

	@RequestMapping(value = "/initCalendar.do")
	public String initCalendar(@RequestParam Map<String, Object> params
			, ModelMap model
			, SessionVO sessionVO
			, HttpServletRequest request) throws Exception  {

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

		params.put("calMonthYear", monthYear);
		params.put("calMemType", (int) sessionVO.getUserTypeId());

		List<EgovMap> eventList = calendarService.selectCalendarEventList(params);

		String eventListJsonStr = new Gson().toJson(eventList);

		model.put("eventListJsonStr", eventListJsonStr);
		model.put("dayOfWeekFirstDt", dayOfWeekFirstDt);
		model.put("lastDateOfMonth", lastDateOfMonth);
		model.put("displayMth", prefixMonth + calMonth);
		model.put("displayYear", calYear);
		model.put("calMemType", sessionVO.getUserTypeId());

		return "logistics/calendar/initCalendar";
	}

	@RequestMapping(value = "/selectCalendarEvents.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectCalendarEvents(@RequestParam Map<String, Object> params
			, HttpServletRequest request
			, ModelMap model
			, SessionVO sessionVO
			) throws Exception  {

		logger.debug("==== selectCalendarEvents Params: " + params.toString());

		List<EgovMap> eventList = calendarService.selectCalendarEventList(params);

		String firstDayOfMonth = "01/" + (String) params.get("calMonthYear"); //Example: 01/05/2020
		Date firstDayOfMonthDt = new SimpleDateFormat("dd/MM/yyyy").parse(firstDayOfMonth);

		Calendar cal = Calendar.getInstance();
		cal.setTime(firstDayOfMonthDt);

		int dayOfWeekFirstDt = cal.get(Calendar.DAY_OF_WEEK) - 1;//minus one as calendar will show MON instead of SUN on first column
		int lastDateOfMonth = cal.getActualMaximum(Calendar.DATE);

		String[] splitMthYr = ((String) params.get("calMonthYear")).split("/");

		Map<String, Object> hm = new HashMap<>();
		hm.put("eventList", eventList);
		hm.put("dayOfWeekFirstDt", dayOfWeekFirstDt);
		hm.put("lastDateOfMonth", lastDateOfMonth);
		hm.put("displayMth", splitMthYr[0]);
		hm.put("displayYear", splitMthYr[1]);
		hm.put("calMemType", params.get("calMemType"));

		return ResponseEntity.ok(hm);
	}

	@RequestMapping(value = "/calendarEventFileUploadPop.do")
	public String calendarEventFileUploadPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "/logistics/calendar/calendarEventFileUploadPop";
	}

	@RequestMapping(value = "/csvUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> csvUpload(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException  {
		ReturnMessage message = new ReturnMessage();

		String batchMthYear = request.getParameter("batchMthYear");
		String batchMemType = request.getParameter("batchMemType");

		logger.debug("==== Request Param - batchMthYear : " + batchMthYear);
		logger.debug("==== Request Param - batchMemType : " + batchMemType);

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<CalendarEventVO> vos = csvReadComponent.readCsvToList(multipartFile, true, CalendarEventVO::create);

		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
		for (CalendarEventVO vo : vos) {
			HashMap<String, Object> hm = new HashMap<String, Object>();
			hm.put("eventDt", vo.getDate());
			hm.put("eventDesc", vo.getAgenda());
			hm.put("crtUserId", sessionVO.getUserId());

			detailList.add(hm);
		}

		Map<String, Object> master = new HashMap<String, Object>();
		master.put("crtUserId", sessionVO.getUserId());
		master.put("batchStatusId", 1);
		master.put("batchCalRem", "");
		master.put("batchMthYear", batchMthYear);
		master.put("batchMemType", batchMemType);

		int result = calendarService.saveCsvUpload(master, detailList);

		if (result > 0) {
			message.setMessage("Calendar file successfully uploaded.<br/>Batch ID : " + result);
			message.setCode(AppConstants.SUCCESS);
		} else {
			message.setMessage("Failed to upload Calendar file. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/calendarEventEditDeletePop.do")
	public String calendarEventEditDeletePop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "/logistics/calendar/calendarEventEditDeletePop";
	}

	@RequestMapping(value = "/searchCalendarEvents.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCalendarEvents(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> calendarEventList = calendarService.selectEventListToManage(params);
		return ResponseEntity.ok(calendarEventList);
	}

	@RequestMapping(value = "/updRemoveCalItem.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> updRemoveCalItem(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		int userId = sessionVO.getUserId();
		params.put("userId", userId);

		int result = 0;
		result = calendarService.updRemoveCalItem(params);

		if(result > 0) {
			message.setMessage("Calendar item has been removed.");
			message.setCode(AppConstants.SUCCESS);
		} else {
			message.setMessage("Failed to remove calendar item. Please try again later.");
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveCalEventChangeList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCalEventChangeList(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		List<Object> updList = params.get(AppConstants.AUIGRID_UPDATE); // Get Grid Update List

		int updResult = 0;
		updResult = calendarService.saveCalEventChangeList(updList, sessionVO.getUserId());

		if(updResult > 0) {
			message.setMessage("Calendar item(s) has been updated.");
			message.setCode(AppConstants.SUCCESS);
		} else {
			message.setMessage("Failed to update calendar item(s). Please try again later.");
			message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);
	}

}
