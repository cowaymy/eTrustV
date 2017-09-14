/**
 * 
 */
package com.coway.trust.web.commission.calculation;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.commission.calculation.CommissionCalculationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.commission.CommissionConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/commission/calculation")
public class CommissionCalculationController {

	private static final Logger logger = LoggerFactory.getLogger(CommissionCalculationController.class);

	@Resource(name = "commissionCalculationService")
	private CommissionCalculationService commissionCalculationService;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	/**
	 * Call run commission management
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/runCommissionMng.do")
	public String runCommissionMng(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> orgGrList = commissionCalculationService.selectOrgGrCdListAll(params);
		model.addAttribute("orgGrList", orgGrList);

		List<EgovMap> orgList = commissionCalculationService.selectOrgCdListAll(params);

		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("orgGrList", orgGrList);
		model.addAttribute("orgList", orgList);
		// 호출될 화면
		return "commission/commissionCalculationMng";
	}

	/**
	 * Organization Ajax Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectOrgCdListAll", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrgCdListAll(@RequestParam Map<String, Object> params, ModelMap model) {

		// 조회.
		List<EgovMap> orgList = commissionCalculationService.selectOrgCdListAll(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orgList);
	}

	@RequestMapping(value = "/selectOrgProList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrgProList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		params.put("mstId", CommissionConstants.COMIS_PRO_CD);
		// 조회.
		List<EgovMap> itemList = commissionCalculationService.selectOrgItemList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(itemList);
	}

	@RequestMapping(value = "/callCommissionProcedure", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> callCommissionProcedure(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		// public ResponseEntity<ReturnMessage> callCommissionProcedure(@RequestBody Map<String, ArrayList<Object>>
		// params, Model model) {
		EgovMap item = new EgovMap();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if (sessionVO == null) {
			loginId = "1000000000";
		} else {
			loginId = String.valueOf(sessionVO.getUserId());
		}
	
		
		String dt = "";
		if(params.get("searchDt")==null || String.valueOf(params.get("searchDt")).equals("")){
			dt = CommonUtils.getNowDate().substring(4,6)+"/"+CommonUtils.getNowDate().substring(0, 4);
		}else{
			dt = String.valueOf(params.get("searchDt"));
		}
		
		int pvMonth = Integer.parseInt(dt.substring(0,2))-1;
		int pvYear = Integer.parseInt(dt.substring(3));
		
		Calendar calendar = Calendar.getInstance();
		calendar.set(pvYear, pvMonth, 1);
		calendar.add(calendar.MONTH, -1);		
		Date date = calendar.getTime();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.getDefault(Locale.Category.FORMAT));
		int sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);	
		params.put("searchDt",df.format(date));

		logger.debug("pvMonth : {}", pvMonth);
		logger.debug("pvYear : {}", pvYear);
		logger.debug("searchDt : {}", params.get("searchDt"));

		params.put("taskId", String.valueOf(sTaskID));
		params.put("loginId", loginId);

		item = (EgovMap) commissionCalculationService.callCommProcedure(params);
		logger.debug("v_result : {}", params.get("v_result"));

		if (params.get("v_result").equals(CommissionConstants.COMIS_FAIL)) {
			/*
			 * 1. insert common log 2. set error message
			 */

		} else {
			/*
			 * 1. set sucess message
			 */
		}

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	
	/**
	 * Call Weekly  management
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/weeklyCommissionMng.do")
	public String weeklyCommissionMng(@RequestParam Map<String, Object> params, ModelMap model) {

		String dt = CommonUtils.getNowDate().substring(0, 6);	
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("year",  Integer.parseInt(dt.substring(3)));
		model.addAttribute("month", Integer.parseInt(dt.substring(0,2)));
		
		// 호출될 화면
		return "commission/commissionWeeklyMng";
	}
	
	/**
	 * Weekly Ajax Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectWeeklyList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWeeklyList(@RequestParam Map<String, Object> params, ModelMap model) {

		// 조회.
		List<EgovMap> weeklyList = commissionCalculationService.selectWeeklyList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(weeklyList);
	}
	
	/**
	 * Weekly  management
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCommissionWeeklyGrid.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage>  saveCommissionWeeklyGrid(@RequestBody Map<String, ArrayList<Object>> params, Model model) {

		String dt = CommonUtils.getNowDate().substring(0, 6);	
		dt = dt.substring(4) + "/" + dt.substring(0, 4);

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";			
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}
		
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		
		int cnt = 0;
		
		if (addList.size() > 0) {			
			cnt = commissionCalculationService.addWeeklyCommissionGrid(addList, loginId);
		}
		if (udtList.size() > 0) {
			cnt = commissionCalculationService.udtWeeklyCommissionGrid(udtList,loginId);
		}
		
		model.addAttribute("searchDt", dt);
		model.addAttribute("year",  Integer.parseInt(dt.substring(3)));
		model.addAttribute("month", Integer.parseInt(dt.substring(0,2)));
		
		logger.info("수정 : {}", udtList.toString());
		logger.info("추가 : {}", addList.toString());
		//logger.info("삭제 : {}", delList.toString());
		logger.info("카운트 : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

}
