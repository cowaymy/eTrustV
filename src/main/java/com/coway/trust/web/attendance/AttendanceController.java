/**
 *
 */
package com.coway.trust.web.attendance;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLConnection;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.joda.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.a.a.a.g.m.n;
import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.attendance.AttendanceService;
import com.coway.trust.biz.attendance.impl.CalendarEventVO;
import com.coway.trust.biz.logistics.calendar.CalendarService;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.web.attendance.AttendanceController;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

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

		@Value("${epapan.auth}")
		private String epapanAuth;

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
			model.put("migrateMonth", attendanceService.atdMigrateMonth());

			return "/attendance/managerAttendanceDownloadUpload";

		}

	    @RequestMapping(value = "/managerAttendanceListing.do")
		public String managerAttendanceListing(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
	    	Integer memLvl = sessionVO.getMemberLevel();
	    	model.put("memLvl", memLvl == null ? 0 : memLvl);
	    	model.put("deptCode", memLvl == null ? null : memLvl == 1 ? sessionVO.getOrgCode() : memLvl == 2 ? sessionVO.getGroupCode() : sessionVO.getDeptCode());
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
		public @ResponseBody ResponseEntity<ReturnMessage> csvUpload(MultipartHttpServletRequest request, ModelMap model, SessionVO sessionVO) throws IOException, InvalidFormatException, Exception {

			try{

				ReturnMessage message = new ReturnMessage();

				String batchMthYear = request.getParameter("batchMthYear").trim();

				int result = 0, dup = 0;

				Map<String, MultipartFile> fileMap = request.getFileMap();
				MultipartFile multipartFile = fileMap.get("csvFile");

				List<CalendarEventVO> vos = csvReadComponent.readCsvToList(multipartFile, true, CalendarEventVO::create);

			    Map<String, Object> cvsParam= new HashMap<String, Object>();
			    cvsParam.put("voList", vos);
			    cvsParam.put("userId", sessionVO.getUserId());

				if (StringUtils.isNotEmpty(request.getParameter("batchId").trim())) {

					String batchId= request.getParameter("batchId").trim();

					HashMap<String, Object> details = new HashMap<String, Object>();
					details.put("crtUserId", sessionVO.getUserId());
					details.put("batchId", batchId);

					int disableUploadDtl = attendanceService.disableBatchCalDtl(details); // Inactive details table data

					cvsParam.put("voList", vos);
					cvsParam.put("type", "upd");
					cvsParam.put("batchId", batchId);
					result = attendanceService.saveCsvUpload(cvsParam); // INSERT NEW DATA INTO ATD0002D

				}
				else{

					//Check duplicated
					Map<String, Object> master = new HashMap<String, Object>();
					master.put("crtUserId", sessionVO.getUserId());
					master.put("batchStatusId", 1);
					master.put("batchMthYear", batchMthYear);

					int duplicateUploadCount = attendanceService.checkDup(master);

				    if(duplicateUploadCount > 0)
				    {
				    	dup=1;
				    }
				    else{
				    	cvsParam.put("type", "ins");
				    	int mResult = attendanceService.saveBatchCalMst(master); // INSERT INTO ATD0001M
				    	result = attendanceService.saveCsvUpload(cvsParam); // INSERT INTO ATD0002D
				    }
				}

				if (result >0 && dup == 0) {
					message.setMessage("Attendance file successfully uploaded.<br/>Batch ID : " + result);
					message.setCode(AppConstants.SUCCESS);
					message.setData(result);
				}
				else if(dup == 1) {
					message.setMessage("Failed to upload Attendance file due to duplicated Month.");
					message.setCode(AppConstants.FAIL);
				}
				else {
					message.setMessage("Failed to upload Attendance file. Please try again later.");
					message.setCode(AppConstants.FAIL);
				}

				return ResponseEntity.ok(message);

			}
			catch(Exception e){
				throw e;
			}
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

		  try{
				params.put("crtUserId", session.getUserId());

				int disableMasterResult = attendanceService.deleteUploadBatch(params);

				int disableDetailsResult = attendanceService.disableBatchCalDtl(params);

				int disableBatchAtdRate = attendanceService.disableBatchAtdRate(params);

				ReturnMessage message = new ReturnMessage();

				if (disableMasterResult > 0 && disableDetailsResult >0) {
			    	message.setCode(AppConstants.SUCCESS);
			    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
				}

				return ResponseEntity.ok(message);
		  }
		  catch(Exception e){
			  throw e;
		  }
	  }


	  @Transactional
	  @RequestMapping(value = "/approveUploadBatch.do")
	  public ResponseEntity<ReturnMessage> approveUploadBatch(@RequestBody Map<String, Object> params , SessionVO session) throws Exception{

		  try{

			    ReturnMessage message = new ReturnMessage();

			    params.put("crtUserId", session.getUserId());
				int result = attendanceService.approveUploadBatch(params);

				if (result > 0) {
			    	message.setCode(AppConstants.SUCCESS);
			    	message.setMessage("Success to approve.");
				} else {
					message.setMessage("Failed to approve this attendance. Please try again later.");
					message.setCode(AppConstants.FAIL);
				}

				return ResponseEntity.ok(message);
		  }
		  catch(Exception e){
			  throw e;
		  }
	  }

	  @RequestMapping(value = "/selectManagerCode.do", method = RequestMethod.GET)
	   public ResponseEntity<List<EgovMap>> selectManagerCode(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

	    List<EgovMap> managerCodeList = attendanceService.selectManagerCode(params);

	    return ResponseEntity.ok(managerCodeList);
	  }

	  @RequestMapping(value="/getAttendanceResetHist.do", method=RequestMethod.GET)
	  public ResponseEntity<String> getAttendanceResetHist(@RequestParam Map<String, Object> p) throws MalformedURLException, IOException {
		  Map<String, Object> ret = new HashMap();
		  if (attendanceService.checkIfHp(p) > 0) {
			  URLConnection connection = new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/attendTokenHist/" + p.get("memCode")).openConnection();
              connection.setRequestProperty("Authorization", epapanAuth);
			  BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
              String input;
              StringBuffer content = new StringBuffer();
              while ((input = in.readLine()) != null) {
            	  content.append(input);
              }
              in.close();
              Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
              ret.put("success", 1);
              ret.put("data", res);
		  } else {
			  ret.put("success", 0);
		  	  ret.put("message", "HP does not exists");
		  }
		  return ResponseEntity.ok(new Gson().toJson(ret));
	  }

	  @RequestMapping(value="/resetAttendance.do", method=RequestMethod.POST)
	  public ResponseEntity<String> resetAttendance(@RequestBody Map<String, Object> p, SessionVO session) throws MalformedURLException, IOException {
		  	Map<String, Object> ret = new HashMap();
		  	if (attendanceService.checkIfHp(p) > 0) {
		  		HttpURLConnection connection = (HttpURLConnection) new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/attendToken").openConnection();
		  		connection.setDoOutput(true);
		  		Map<String, Object> d = new HashMap();
		  		d.put("userName", p.get("memCode"));
		  		d.put("updUser", session.getUserName());
		  		byte[] inputData = new Gson().toJson(d).getBytes("utf-8");
		  		connection.setRequestMethod( "PUT" );
		  		connection.setRequestProperty("Content-Type", "application/json");
		  		connection.setRequestProperty("charset", "utf-8");
		  		connection.setRequestProperty("Authorization", epapanAuth);
		  		connection.setRequestProperty("Content-Length", Integer.toString(inputData.length));
		  		try(OutputStream os = connection.getOutputStream()) {
		  			os.write(inputData);
		  		}
		  		BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		  		String input;
		  		StringBuffer content = new StringBuffer();
		  		while ((input = in.readLine()) != null) {
		  			content.append(input);
		  		}
		  		in.close();
		  		Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
		  		if ((Boolean) res.get("success")) {
		  			ret.put("success", 1);
			  		ret.put("message", "Attendance Device reseted");
		  		} else {
		  			ret.put("success", 0);
			  		ret.put("message", "Unexpected error happened");
		  		}
		  	} else {
		  		ret.put("success", 0);
		  		ret.put("message", "HP does not exists");
		  	}
		  	return ResponseEntity.ok(new Gson().toJson(ret));
	  }

	  @RequestMapping(value="/modifyHoliday.do", method = RequestMethod.POST)
	  public ResponseEntity<String> addHoliday(@RequestBody Map<String, Object> p) throws MalformedURLException, IOException {
		  HttpURLConnection connection = (HttpURLConnection) new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/cowayMergeHoliday").openConnection();
			connection.setDoOutput(true);
			Map<String, Object> d = new HashMap();
			d.put("eventDate", p.get("date"));
			d.put("eventCowayCode", p.get("occasion").equals("") ? "" : "A0002");
			d.put("eventCowayDesc", p.get("occasion"));
			byte[] inputData = new Gson().toJson(d).getBytes("utf-8");
			connection.setRequestMethod( "PUT" );
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestProperty("charset", "utf-8");
			connection.setRequestProperty("Authorization", epapanAuth);
		    connection.setRequestProperty("Content-Length", Integer.toString(inputData.length));
		    try(OutputStream os = connection.getOutputStream()) {
		    	os.write(inputData);
		    }
			BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			String input;
			StringBuffer content = new StringBuffer();
			while ((input = in.readLine()) != null) {
				content.append(input);
			}
			in.close();
			Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
			return ResponseEntity.ok(new Gson().toJson(res));
	  }

	  @RequestMapping(value="/getHolidays.do")
	  public ResponseEntity<String> getHolidays(@RequestParam Map<String, Object> p) throws MalformedURLException, IOException {
		  URLConnection connection = new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/cowayMergeHoliday/" + p.get("month")).openConnection();
          connection.setRequestProperty("Authorization", epapanAuth);
		  BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
          String input;
          StringBuffer content = new StringBuffer();
          while ((input = in.readLine()) != null) {
        	  content.append(input);
          }
          in.close();
          Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
          return ResponseEntity.ok(new Gson().toJson(((List<Map<String, Object>>) res.get("dataList")).stream().filter((h) -> {
        	  return h.get("event_coway_code") != null && !h.get("event_coway_code").equals("");
          }).collect(Collectors.toList())));
	  }

	  @RequestMapping(value = "/searchAtdManagementList.do", method = RequestMethod.GET)
	   public ResponseEntity<String> searchAtdManagementList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		  LOGGER.debug("params =====================================>>  " + params);
		  if ((new SimpleDateFormat("dd/MM/yyyy").parse(attendanceService.atdMigrateMonth())).after(new SimpleDateFormat("MM/yyyy").parse((String) params.get("calMonthYear")))) {

			  if(params.get("hpCode") != null){
				  throw new Exception ("HP Data no available before epapan migration.");
			  }

			  List<EgovMap> AtdList = attendanceService.searchAtdManagementList(params);
			  return ResponseEntity.ok(new Gson().toJson(AtdList));
		  } else {
			  String memCode = params.get("hpCode") != null ? params.get("hpCode").toString() : attendanceService.getMemCode(params);
			  URLConnection connection = new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/attendEvents/" + memCode + "/reqDate/" + new SimpleDateFormat("yyyyMM").format(new SimpleDateFormat("MM/yyyy").parse((String) params.get("calMonthYear")))).openConnection();
              connection.setRequestProperty("Authorization", epapanAuth);
			  BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
              String input;
              StringBuffer content = new StringBuffer();
              while ((input = in.readLine()) != null) {
            	  content.append(input);
              }
              in.close();
              Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
              List<Map<String, Object>> data = ((List<Map<String, Object>>) nvl(res.get("dataList"), new ArrayList())).stream().map((d) -> {
            	 Map<String, Object> a = new HashMap();
            	 Date date;
            	 try {
					date = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse((String) d.get("start"));
            	 } catch (Exception e) {
					date = null;
            	 }
            	 String type = (String) d.get("attend_type_code");
            	 a.put("atdDate", date == null ? null : new SimpleDateFormat("yyyy/MM/dd").format(date));
            	 a.put("atdDay", date == null ? null : new SimpleDateFormat("EEEEE").format(date).toUpperCase());
            	 a.put("type", type);
            	 a.put("year", date == null ? null : Integer.parseInt(new SimpleDateFormat("yyyy").format(date)));
            	 a.put("month", date == null ? null : Integer.parseInt(new SimpleDateFormat("MM").format(date)));
            	 a.put("managerCode", params.get("managerCode"));
            	 a.put("infoTech", type.equals("A0001") ? 1 : 0);
            	 a.put("eLeave", type.equals("A0002") ? 1 : 0);
            	 a.put("publicHoliday", type.equals("A0003") ? 1 : 0);
            	 a.put("training", type.equals("A0004") ? 1 : 0);
            	 a.put("attendance", type.equals("A0005") ? 1 : 0);
            	 try {
					a.put("time", type.equals("A0001") ? (date.after(new SimpleDateFormat("yyyy/MM/dd/HH:mm:ss").parse(new SimpleDateFormat("yyyy/MM/dd").format(date) + "/09:00:01")) ? "LATE" : new SimpleDateFormat("HH:mm:ss").format(date)) : new SimpleDateFormat("HH:mm:ss").format(date));
				} catch (Exception e) {
					a.put("time", "-");
				}
            	 return a;
              }).collect(Collectors.toList());
              List<Map<String, Object>> fullData = Stream.iterate(1, i -> i + 1).limit(Calendar.getInstance().getActualMaximum(Calendar.DAY_OF_MONTH)).map(i -> {
            	  try {
        			  Date attendanceDate = new SimpleDateFormat("MM/yyyy/d").parse(((String) params.get("calMonthYear")) + "/" + i.toString());
        			  Map<String, Object> exist = data.stream().filter(a -> {
        				  return a.get("atdDate").equals(new SimpleDateFormat("yyyy/MM/dd").format(attendanceDate));
        			  }).findFirst().orElse(null);
        			  if (exist != null) {
        				  return exist;
        			  }
        			  Map<String, Object> empty = new HashMap();
        			  empty.put("atdDate", new SimpleDateFormat("yyyy/MM/dd").format(attendanceDate));
                      empty.put("atdDay", new SimpleDateFormat("EEEEE").format(attendanceDate).toUpperCase());
                      empty.put("year", Integer.parseInt(new SimpleDateFormat("yyyy").format(attendanceDate)));
                      empty.put("month", Integer.parseInt(new SimpleDateFormat("MM").format(attendanceDate)));
                      empty.put("managerCode", params.get("managerCode"));
                      empty.put("infoTech", 0);
                      empty.put("eLeave", 0);
                      empty.put("publicHoliday", 0);
                      empty.put("training", 0);
                      empty.put("attendance", 0);
                      empty.put("time", "-");
                      return empty;
            	  } catch (Exception e) {
            		  // treat as not found
            		  e.printStackTrace();
            	  }
            	  Map<String, Object> none = new HashMap();
            	  return none;
              }).collect(Collectors.toList());
              return ResponseEntity.ok(new Gson().toJson(fullData));
		  }
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

	  @RequestMapping("/attendanceExcelPop.do")
	  public String attendanceExcelPop(ModelMap model, SessionVO session) {
		  model.put("memLvl", nvl(session.getMemberLevel(), 0));
		  model.put("orgCode", nvl(session.getOrgCode(), ""));
		  model.put("grpCode", nvl(session.getGroupCode(), ""));
		  model.put("deptCode", nvl(session.getDeptCode(), ""));
		  model.put("memCode", nvl(session.getUserMemCode(), ""));
		  return "/attendance/attendanceExcelPop";
	  }

	private Object nvl(Object a, Object b) {
		return a != null ? a : b;
	}

	@RequestMapping("/getDownline.do")
	public ResponseEntity<List<EgovMap>> getDownline(@RequestParam Map<String, Object> params) {
		return ResponseEntity.ok(attendanceService.getDownline(params));
	}

	@RequestMapping("/getDownlineHP.do")
	public ResponseEntity<List<EgovMap>> getDownlineHP(@RequestParam Map<String, Object> params) {
		return ResponseEntity.ok(attendanceService.getDownlineHP(params));
	}

	@RequestMapping("/reportingBranch.do")
	public String reportingBranch(SessionVO session, ModelMap model) {
		model.put("memLvl", nvl(session.getMemberLevel(), 0));
        model.put("orgCode", nvl(session.getOrgCode(), ""));
        model.put("grpCode", nvl(session.getGroupCode(), ""));
        model.put("deptCode", nvl(session.getDeptCode(), ""));
        model.put("memCode", nvl(session.getUserMemCode(), ""));
		return "/attendance/attendanceReportingBranch";
	}

	@RequestMapping("/getAllReporting.do")
	public ResponseEntity<String> getAllReporting(@RequestParam Map<String, Object> p) {
		List<EgovMap> hps = attendanceService.selectHPReporting(p);
		hps = hps.stream().map((hp) -> {
			try {
				URLConnection connection = new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/attendanceAllowLocation/" + hp.get("memCode")).openConnection();
				connection.setRequestProperty("Authorization", epapanAuth);
				BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
				String input;
				StringBuffer content = new StringBuffer();
				while ((input = in.readLine()) != null) {
					content.append(input);
				}
				in.close();
				Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
				List<Map<String, Object>> data = (List<Map<String, Object>>) nvl(res.get("dataList"), new ArrayList());
				hp.put("locations", data);
			} catch (Exception e) {
				hp.put("locations", new ArrayList());
			}
			return hp;
		})
		.filter((hp) -> hp.get("locations") != null && ((List<EgovMap>) hp.get("locations")).size() != 0)
		.collect(Collectors.toList());
		return ResponseEntity.ok(new Gson().toJson(hps));
	}

	@RequestMapping("/selectHPReporting.do")
	public ResponseEntity<String> selectHPReporting(@RequestParam Map<String, Object> params) {
		List<EgovMap> hps = attendanceService.selectHPReporting(params);
		if (hps.size() > 0) {
			EgovMap hp = hps.stream().findFirst().get();
			try {
				URLConnection connection = new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/attendanceAllowLocation/" + hp.get("memCode")).openConnection();
				connection.setRequestProperty("Authorization", epapanAuth);
				BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
				String input;
				StringBuffer content = new StringBuffer();
				while ((input = in.readLine()) != null) {
					content.append(input);
				}
				in.close();
				Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
				List<Map<String, Object>> data = (List<Map<String, Object>>) nvl(res.get("dataList"), new ArrayList());
				hp.put("locations", data);
				return ResponseEntity.ok(new Gson().toJson(hp));
			} catch (Exception e) {
				// fall
			}
		}
		return ResponseEntity.ok(new Gson().toJson(new HashMap()));
	}

	@RequestMapping("/getReportingBranch.do")
	public ResponseEntity<List<EgovMap>> getReportingBranch() {
		return ResponseEntity.ok(attendanceService.getReportingBranch());
	}

	@RequestMapping(value="/removeLocation.do", method=RequestMethod.POST)
	public ResponseEntity<String> removeLocation(@RequestBody Map<String, Object> p) throws MalformedURLException, IOException, ProtocolException {
		HttpURLConnection connection = (HttpURLConnection) new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/attendanceAllowLocation").openConnection();
		connection.setDoOutput(true);
		Map<String, Object> d = new HashMap();
		d.put("attendDate", "undefi");
		d.put("attendAllowBranchCode", p.get("attendAllowBranchCode"));
		d.put("attendAllowHpCode", p.get("memCode"));
		d.put("attendAllowUseYn", "N");
		byte[] inputData = new Gson().toJson(d).getBytes("utf-8");
		connection.setRequestMethod( "PUT" );
		connection.setRequestProperty("Content-Type", "application/json");
		connection.setRequestProperty("charset", "utf-8");
		connection.setRequestProperty("Authorization", epapanAuth);
	    connection.setRequestProperty("Content-Length", Integer.toString(inputData.length));
	    try(OutputStream os = connection.getOutputStream()) {
	    	os.write(inputData);
	    }
		BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		String input;
		StringBuffer content = new StringBuffer();
		while ((input = in.readLine()) != null) {
			content.append(input);
		}
		in.close();
		Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
		return ResponseEntity.ok(new Gson().toJson(res));
	}

	@RequestMapping(value="/addLocation.do", method = RequestMethod.POST)
	public ResponseEntity<HashMap<String, Object>> addLocation(@RequestBody Map<String, Object> params) {
		try {
			HttpURLConnection connection = (HttpURLConnection) new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/attendanceAllowLocation").openConnection();
			connection.setDoOutput(true);
			Map<String, Object> d = new HashMap();
			d.put("attendAllowHpCode", params.get("code"));
			d.put("attendAllowBranchId", params.get("id"));
			d.put("attendAllowBranchCode", params.get("name"));
			d.put("attendAllowUseYn", "Y");
			byte[] inputData = new Gson().toJson(d).getBytes("utf-8");
			connection.setRequestMethod( "POST" );
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestProperty("charset", "utf-8");
			connection.setRequestProperty("Authorization", epapanAuth);
		    connection.setRequestProperty("Content-Length", Integer.toString(inputData.length));
		    try(OutputStream os = connection.getOutputStream()) {
		    	os.write(inputData);
		    }
			BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			String input;
			StringBuffer content = new StringBuffer();
			while ((input = in.readLine()) != null) {
				content.append(input);
			}
			in.close();
			Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
			if ((boolean) res.get("success")) {
				HashMap<String, Object> retD = new HashMap();
				retD.put("success", true);
				return ResponseEntity.ok(retD);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ResponseEntity.ok(new HashMap());
	}

	@RequestMapping("/genAttendanceExcelData.do")
	public ResponseEntity<String> genAttendanceExcelData(@RequestParam Map<String, Object> params, SessionVO session) throws ParseException {
		if (!session.getDeptCode().equals(" ")) params.put("deptCode", session.getDeptCode());
		if (!session.getGroupCode().equals(" ")) params.put("grpCode", session.getGroupCode());
		if (!session.getOrgCode().equals(" ")) params.put("orgCode", session.getOrgCode());
		return ResponseEntity.ok(attendanceService.getAttendanceRaw(params));
	}
}
