/**
 *
 */
package com.coway.trust.web.attendance;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.attendance.AttendanceService;
import com.coway.trust.biz.attendance.impl.CalendarEventVO;
import com.coway.trust.biz.logistics.calendar.CalendarService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.web.attendance.AttendanceController;
import com.coway.trust.config.csv.CsvReadComponent;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Low Kim Ching
 *
 */
@Controller
@RequestMapping(value = "/attendance")
public class AttendanceController {

	 private static final Logger LOGGER = LoggerFactory.getLogger(AttendanceController.class);

	    @Resource(name = "AttendanceService")
	    private AttendanceService attendanceService;

	    @Resource(name = "calendarService")
		private CalendarService calendarService;

	    @Autowired
		private CsvReadComponent csvReadComponent;

		@Autowired
		private SessionHandler sessionHandler;

	    @Autowired
	    private MessageSourceAccessor messageAccessor;

	    @RequestMapping(value = "/managerAttendanceDownloadUpload.do")
		public String managerAttendanceDownloadUpload(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO, HttpServletRequest request) throws Exception  {

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

			return "/attendance/managerAttendanceDownloadUpload";

		}

	    @RequestMapping(value = "/managerAttendanceListing.do")
		public String managerAttendanceListing(@RequestParam Map<String, Object> params, ModelMap model) {
			return "/attendance/managerAttendanceListing";
		}


		@RequestMapping(value = "/attendanceFileUploadPop.do")
		public String calendarEventFileUploadPop(@RequestParam Map<String, Object> params, ModelMap model) {
			return "/attendance/attendanceFileUploadPop";
		}

		@RequestMapping(value = "/attendanceFileDownloadPop.do")
		public String calendarEventFileDownloadPop(@RequestParam Map<String, Object> params, ModelMap model) {
			return "/attendance/attendanceFileDownloadPop";
		}


		@Transactional
		@RequestMapping(value = "/csvUpload.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> csvUpload(MultipartHttpServletRequest request, ModelMap model, SessionVO sessionVO) throws IOException, InvalidFormatException  {
			ReturnMessage message = new ReturnMessage();


			String batchMthYear = request.getParameter("batchMthYear").trim();
			String batchMemType = request.getParameter("batchMemType").trim();
			int result = 0;
			int dup = 0;


			Map<String, MultipartFile> fileMap = request.getFileMap();
			MultipartFile multipartFile = fileMap.get("csvFile");


			List<CalendarEventVO> vos = csvReadComponent.readCsvToList(multipartFile, true, CalendarEventVO::create);

			List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
			for (CalendarEventVO vo : vos) {
				HashMap<String, Object> hm = new HashMap<String, Object>();
				hm.put("atdType", vo.getAttendanceType().trim());
				hm.put("memCode", vo.getMemCode().trim());
				hm.put("dateFrom", vo.getDateFrom().trim());
				hm.put("dateTo", vo.getDateTo());
				hm.put("time", vo.getTime().trim());
				hm.put("crtUserId", sessionVO.getUserId());

				detailList.add(hm);
			}

			//LOGGER.debug("details =====================================>>  " + detailList);

			if (StringUtils.isNotEmpty(request.getParameter("batchId").trim())) {
				String batchId= request.getParameter("batchId").trim();
				HashMap<String, Object> details = new HashMap<String, Object>();
				details.put("crtUserId", sessionVO.getUserId());
				details.put("batchId", batchId);
				details.put("batchId", batchId);
				int disableUploadDtl = attendanceService.disableBatchCalDtl(details);

				if(disableUploadDtl > 0){
					result = attendanceService.saveCsvUpload2(detailList, batchId, batchMemType);
				}
			}
			else{
				Map<String, Object> master = new HashMap<String, Object>();
				master.put("crtUserId", sessionVO.getUserId());
				master.put("batchStatusId", 1);
				master.put("batchMthYear", batchMthYear);
				master.put("batchMemType", batchMemType);


				int duplicateUploadCount = attendanceService.checkDup(master);

			    if(duplicateUploadCount > 0)
			    {
			    	dup=1;
			    }
			    else{
			    	result = attendanceService.saveCsvUpload(master, detailList);
			    }
			}

			if (result >0 && dup == 0) {
				message.setMessage("Attendance file successfully uploaded.<br/>Batch ID : " + result);
				message.setCode(AppConstants.SUCCESS);
				message.setData(result);
			}
			else if(dup == 1) {
				message.setMessage("Failed to upload Attendance file due to duplicated Member Type and Month.");
				message.setCode(AppConstants.FAIL);
			}
			else {
				message.setMessage("Failed to upload Attendance file. Please try again later.");
				message.setCode(AppConstants.FAIL);
			}

			return ResponseEntity.ok(message);
		}


		@RequestMapping(value = "/attendanceSubmitApproval.do")
		public String attendanceSubmitApproval(@RequestParam Map<String, Object> params, ModelMap model) {
			LOGGER.debug("==== attendanceSubmitApproval : " + params);

			model.put("batchId", params.get("batchId"));
			return "attendance/attendanceSubmitApproval";
		}


		@RequestMapping(value = "/registrationMsgPop.do")
		public String registrationMsgPop(@RequestParam Map<String, Object> params, ModelMap model) {
			model.put("batchId", params.get("batchId"));
			return "attendance/registrationMsgPop";
		}

		@Transactional
		@RequestMapping(value = "/approveLineSubmit.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> approveLineSubmit(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

			LOGGER.debug("params =====================================>>  " + params);

			params.put(CommonConstants.USER_ID, sessionVO.getUserId());
			params.put("userName", sessionVO.getUserName());

			//model.put("batchId", getUserInfo.get("memCode"));

			// TODO
			attendanceService.insertApproveLine(params);

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setData(params);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}


	   @RequestMapping(value = "/searchAtdUploadList.do", method = RequestMethod.GET)
	   public ResponseEntity<List<EgovMap>> searchAtdUploadList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	    List<EgovMap> AtdList = attendanceService.searchAtdUploadList(params);

	    return ResponseEntity.ok(AtdList);
	  }




	  @RequestMapping(value = "/attendanceFileEditDeletePop.do")
		public String attendanceFileEditDeletePop(@RequestParam Map<String, Object> params, ModelMap model) {
			return "/attendance/attendanceFileEditDeletePop";
	  }


	  @Transactional
	  @RequestMapping(value = "/deleteUploadBatch.do")
	  public ResponseEntity<ReturnMessage> deleteUploadBatch(@RequestBody Map<String, Object> params , SessionVO session) throws Exception{

			params.put("crtUserId", session.getUserId());

			int result = attendanceService.deleteUploadBatch(params);

			ReturnMessage message = new ReturnMessage();

			if (result > 0) {
		    	message.setCode(AppConstants.SUCCESS);
		    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			} else {
				message.setMessage("Failed to delete Attendance file. Please try again later.");
				message.setCode(AppConstants.FAIL);
			}

			return ResponseEntity.ok(message);
	  }


	  @Transactional
	  @RequestMapping(value = "/approveUploadBatch.do")
	  public ResponseEntity<ReturnMessage> approveUploadBatch(@RequestBody Map<String, Object> params , SessionVO session) throws Exception{

			params.put("crtUserId", session.getUserId());

			int result = attendanceService.approveUploadBatch(params);

			ReturnMessage message = new ReturnMessage();

			if (result > 0) {
		    	message.setCode(AppConstants.SUCCESS);
		    	message.setMessage("Success to approve.");
			} else {
				message.setMessage("Failed to approve this attendance. Please try again later.");
				message.setCode(AppConstants.FAIL);
			}

			return ResponseEntity.ok(message);
	  }

	  @RequestMapping(value = "/selectManagerCode.do", method = RequestMethod.GET)
	   public ResponseEntity<List<EgovMap>> selectManagerCode(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	    List<EgovMap> managerCodeList = attendanceService.selectManagerCode(params);

	    return ResponseEntity.ok(managerCodeList);
	  }


	  @RequestMapping(value = "/searchAtdManagementList.do", method = RequestMethod.GET)
	   public ResponseEntity<List<EgovMap>> searchAtdManagementList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		  LOGGER.debug("params =====================================>>  " + params);
	    List<EgovMap> AtdList = attendanceService.searchAtdManagementList(params);

	    return ResponseEntity.ok(AtdList);
	  }

	  @RequestMapping(value = "/downloadManagerYearlyAttendance.do")
		public String downloadManagerYearlyAttendance(@RequestParam Map<String, Object> params, ModelMap model) {
			model.addAttribute("ind", params.get("ind"));
			return "/attendance/downloadManagerYearlyAttendancePop";
		}

	  @RequestMapping(value = "/selectYearList.do", method = RequestMethod.GET)
	   public ResponseEntity<List<EgovMap>> selectYearList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	    List<EgovMap> yearList = attendanceService.selectYearList(params);

	    return ResponseEntity.ok(yearList);
	  }




}
