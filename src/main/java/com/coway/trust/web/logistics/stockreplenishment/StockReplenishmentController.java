/**
 *
 */
package com.coway.trust.web.logistics.stockreplenishment;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.coway.trust.biz.logistics.stockReplenishment.StockReplenishmentService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.config.csv.CsvReadComponent;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Low Kim Ching
 *
 */
@Controller
@RequestMapping(value = "/logistics/stockReplenishment")
public class StockReplenishmentController {

	 private static final Logger LOGGER = LoggerFactory.getLogger(StockReplenishmentController.class);

		@Resource(name = "StockReplenishmentService")
	    private StockReplenishmentService stockReplenishmentService;

	    @Resource(name = "calendarService")
		private CalendarService calendarService;

	    @Autowired
		private CsvReadComponent csvReadComponent;

		@Autowired
		private SessionHandler sessionHandler;

	    @Autowired
	    private MessageSourceAccessor messageAccessor;

	    @RequestMapping(value = "/sroForecastHistoryList.do")
		public String sroForecastHistoryList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO, HttpServletRequest request) throws Exception  {

	    	List<EgovMap> sroStatus = stockReplenishmentService.selectSroStatus(params);
	    	model.put("sroStatus", sroStatus);
	    	return "/logistics/stockReplenishment/sroForecastHistoryList";

		}


	    @RequestMapping(value = "/selectWeekList.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectWeekList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		    List<EgovMap> weekList = stockReplenishmentService.selectWeekList(params);

		    return ResponseEntity.ok(weekList);
	    }

	    @RequestMapping(value = "/sroForecastHistoryList.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> sroForecastHistoryList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

			String searchMatCode = request.getParameter("searchMatCode");
			String[] searchType = request.getParameterValues("searchType");
			String[] searchCtgry = request.getParameterValues("searchCtgry");
			String[] searchlocgb = request.getParameterValues("searchlocgb");
			String[] searchLoc = request.getParameterValues("searchLoc");
			String searchlocgrade = request.getParameter("searchlocgrade");
			String searchBranch = request.getParameter("searchBranch");
			String searchCDC = request.getParameter("searchCDC");
			String searchYear = request.getParameter("searchYear");
			String searchMonth = request.getParameter("searchMonth");
			String searchWeek = request.getParameter("searchWeek");
			String[] searchStatus = request.getParameterValues("searchStatus");
			String sstocknm = request.getParameter("searchMatName");

			Map<String, Object> smap = new HashMap();


			smap.put("searchYear", searchYear);
			smap.put("searchMonth", searchMonth);
			smap.put("searchWeek", searchWeek);
			smap.put("searchMatCode", searchMatCode);
			smap.put("searchLoc", searchLoc);
			smap.put("searchType", searchType);
			smap.put("searchCtgry", searchCtgry);
			smap.put("searchlocgb", searchlocgb);
			smap.put("searchlocgrade", searchlocgrade);
			smap.put("sstocknm", sstocknm);
			smap.put("searchBranch", searchBranch);
			smap.put("searchCDC", searchCDC);
			smap.put("searchStatus", searchStatus);

	    	List<EgovMap> sroList = stockReplenishmentService.selectSroCodyList(smap);

		    return ResponseEntity.ok(sroList);
	   }

	    @RequestMapping(value = "/selectSroRdcList.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectSroRdcList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

			String searchMatCode = request.getParameter("searchMatCode");
			String[] searchType = request.getParameterValues("searchType");
			String[] searchCtgry = request.getParameterValues("searchCtgry");
			String[] searchlocgb = request.getParameterValues("searchlocgb");
			String[] searchLoc = request.getParameterValues("searchLoc");
			String searchlocgrade = request.getParameter("searchlocgrade");
			String searchBranch = request.getParameter("searchBranch");
			String searchCDC = request.getParameter("searchCDC");
			String searchYear = request.getParameter("searchYear");
			String searchMonth = request.getParameter("searchMonth");
			String searchWeek = request.getParameter("searchWeek");
			String[] searchStatus = request.getParameterValues("searchStatus");
			String sstocknm = request.getParameter("searchMatName");

			Map<String, Object> smap = new HashMap();


			smap.put("searchYear", searchYear);
			smap.put("searchMonth", searchMonth);
			smap.put("searchWeek", searchWeek);
			smap.put("searchMatCode", searchMatCode);
			smap.put("searchLoc", searchLoc);
			smap.put("searchType", searchType);
			smap.put("searchCtgry", searchCtgry);
			smap.put("searchlocgb", searchlocgb);
			smap.put("searchlocgrade", searchlocgrade);
			smap.put("sstocknm", sstocknm);
			smap.put("searchBranch", searchBranch);
			smap.put("searchCDC", searchCDC);
			smap.put("searchStatus", searchStatus);

	    	List<EgovMap> sroList = stockReplenishmentService.selectSroRdcList(smap);

		    return ResponseEntity.ok(sroList);
	   }

	    @RequestMapping(value = "/selectSroList.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectSroList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

			String searchMatCode = request.getParameter("searchMatCode");
			String[] searchType = request.getParameterValues("searchType");
			String[] searchCtgry = request.getParameterValues("searchCtgry");
			String[] searchlocgb = request.getParameterValues("searchlocgb");
			String[] searchLoc = request.getParameterValues("searchLoc");
			String searchlocgrade = request.getParameter("searchlocgrade");
			String searchBranch = request.getParameter("searchBranch");
			String searchCDC = request.getParameter("searchCDC");
			String searchYear = request.getParameter("searchYear");
			String searchMonth = request.getParameter("searchMonth");
			String searchWeek = request.getParameter("searchWeek");
			String[] searchStatus = request.getParameterValues("searchStatus");
			String sstocknm = request.getParameter("searchMatName");

			Map<String, Object> smap = new HashMap();


			smap.put("searchYear", searchYear);
			smap.put("searchMonth", searchMonth);
			smap.put("searchWeek", searchWeek);
			smap.put("searchMatCode", searchMatCode);
			smap.put("searchLoc", searchLoc);
			smap.put("searchType", searchType);
			smap.put("searchCtgry", searchCtgry);
			smap.put("searchlocgb", searchlocgb);
			smap.put("searchlocgrade", searchlocgrade);
			smap.put("sstocknm", sstocknm);
			smap.put("searchBranch", searchBranch);
			smap.put("searchCDC", searchCDC);
			smap.put("searchStatus", searchStatus);

	    	List<EgovMap> sroList = stockReplenishmentService.selectSroList(smap);

		    return ResponseEntity.ok(sroList);
	   }

	    @RequestMapping(value = "/sroRdcSafetyLevel.do")
	    public String hsFilterDeliveryList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

	      SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	      params.put("userId", sessionVO.getUserId());

	      return "/logistics/stockReplenishment/sroRdcSafetyLevel";
	    }


		@RequestMapping(value = "/selectSroSafetyLvlList.do" , method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectSroSafetyLvlList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		  List<EgovMap> list = stockReplenishmentService.selectSroSafetyLvlList(params);

		  return ResponseEntity.ok(list);
		}


		@Transactional
		@RequestMapping(value = "/insertSroSafetyLvl.do", method = RequestMethod.POST)
		 public ResponseEntity<ReturnMessage> insertSroSafetyLvl(@RequestBody Map<String, Object> params) throws Exception {

		   SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		   params.put("userId", sessionVO.getUserId());

		   int result = stockReplenishmentService.updateMergeLOG0119M(params);

		   ReturnMessage message = new ReturnMessage();

		   if(result > 0){
		    	 message.setCode(AppConstants.SUCCESS);
		    	 message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		   }else{
		    	message.setCode(AppConstants.FAIL);
		   	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		   }

		   return ResponseEntity.ok(message);

		}


		@RequestMapping(value = "/sroHsFilterForecastList.do")
		public String sroHsFilterForecastList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO, HttpServletRequest request) throws Exception  {
		   List<EgovMap> sroStatus = stockReplenishmentService.selectSroStatus(params);
	       model.put("sroStatus", sroStatus);
	       return "/logistics/stockReplenishment/sroHsFilterForecastList";

		}


		@RequestMapping(value = "/selectSroLocationType.do" , method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectSroLocationType(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		   List<EgovMap> list = stockReplenishmentService.selectSroLocationType(params);

		   return ResponseEntity.ok(list);
		}


		@RequestMapping(value = "/sroHsFilterForecastCodyList.do")
		public String sroHsFilterForecastCodyList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO, HttpServletRequest request) throws Exception  {

	      return "/logistics/stockReplenishment/sroHsFilterForecastCodyList";

		}

		@RequestMapping(value = "/sroHsFilterForecastRdcList.do")
		public String sroHsFilterForecastRdcList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO, HttpServletRequest request) throws Exception  {

	      return "/logistics/stockReplenishment/sroHsFilterForecastRdcList";

		}


		@RequestMapping(value = "/selectSroStatus.do" , method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectSroStatus(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		   List<EgovMap> list = stockReplenishmentService.selectSroStatus(params);

		   return ResponseEntity.ok(list);
		}

		@RequestMapping(value = "/sroGenerateCalendar.do")
		public String sroGenerateCalendar(@RequestParam Map<String, Object> params, ModelMap model) {

			String dt = CommonUtils.getNowDate().substring(0, 6);
			dt = dt.substring(4) + "/" + dt.substring(0, 4);

			model.addAttribute("searchDt", dt);
			model.addAttribute("year",  Integer.parseInt(dt.substring(3)));
			model.addAttribute("month", Integer.parseInt(dt.substring(0,2)));

			return "/logistics/stockReplenishment/sroGenerateCalendar";
		}


		@RequestMapping(value = "/selectWeeklyList", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectWeeklyList(@RequestParam Map<String, Object> params, ModelMap model) {

			List<EgovMap> weeklyList = stockReplenishmentService.selectWeeklyList(params);

			return ResponseEntity.ok(weeklyList);
		}


		@RequestMapping(value = "/saveSroCalendarGrid.do", method = RequestMethod.POST)
		public  ResponseEntity<ReturnMessage>  saveSroCalendarGrid(@RequestBody Map<String, Object> params, Model model,SessionVO sessionVO) {

			ReturnMessage message = new ReturnMessage();

			try{
				String dt = CommonUtils.getNowDate().substring(0, 6);
				dt = dt.substring(4) + "/" + dt.substring(0, 4);

				int result = 0;
				List<Object> dataList = (List<Object>) params.get("data");
				params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());

				if (dataList.size() > 0) {
					result = stockReplenishmentService.saveSroCalendarGrid(dataList,  params.get("userId").toString());
				}

				model.addAttribute("searchDt", dt);
				model.addAttribute("year",  Integer.parseInt(dt.substring(3)));
				model.addAttribute("month", Integer.parseInt(dt.substring(0,2)));

				message.setCode(result > 0 ? AppConstants.SUCCESS : AppConstants.FAIL);
				message.setMessage(result > 0 ? messageAccessor.getMessage(AppConstants.MSG_SUCCESS) : messageAccessor.getMessage(AppConstants.MSG_FAIL));
				return ResponseEntity.ok(message);

			}catch(Exception e){
				message.setCode(AppConstants.FAIL);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
				return ResponseEntity.ok(message);
			}

		}

		@RequestMapping(value = "/selectYearList.do", method = RequestMethod.GET)
	    public ResponseEntity<List<EgovMap>> selectYearList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
        		List<EgovMap> yearList = stockReplenishmentService.selectYearList(params);
        		return ResponseEntity.ok(yearList);
		}

		@RequestMapping(value = "/selectMonthList.do", method = RequestMethod.GET)
	    public ResponseEntity<List<EgovMap>> selectMonthList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
        		List<EgovMap> monthList = stockReplenishmentService.selectMonthList(params);
        		return ResponseEntity.ok(monthList);
		}

		@RequestMapping(value = "/sroShortageDeliveryList.do")
		public String sroShortageDeliveryList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO, HttpServletRequest request) throws Exception  {
				return "/logistics/stockReplenishment/sroShortageDeliveryList";
		}




}
