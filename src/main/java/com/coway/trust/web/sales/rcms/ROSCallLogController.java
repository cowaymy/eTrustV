package com.coway.trust.web.sales.rcms;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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

import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderLedgerService;
import com.coway.trust.biz.sales.rcms.ROSCallLogService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/rcms")
public class ROSCallLogController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ROSCallLogController.class);
	
	@Autowired
	private AdaptorService adaptorService;
	
	@Resource(name = "rosCallLogService")
	private ROSCallLogService rosCallLogService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@Resource(name = "orderLedgerService")
	private OrderLedgerService orderLedgerService;
	
	@RequestMapping(value = "/rosCallLogList.do")
	public String rosCallLogList (@RequestParam Map<String, Object> params) throws Exception{
		
		return "sales/rcms/rosCallLogList";
	}
	
	
	@RequestMapping(value = "/getAppTypeList")
	public ResponseEntity<List<EgovMap>> getAppTypeList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> appTypeList = null;
		
		appTypeList = rosCallLogService.getAppTypeList(params);
		
		return ResponseEntity.ok(appTypeList);
		
	}
	
	
	@RequestMapping(value = "/selectRosCallLogList")
	public ResponseEntity<List<EgovMap>> selectRosCallLogList(@RequestParam Map<String, Object> params, HttpServletRequest request )throws Exception{
		
		String appTypeArr[] = request.getParameterValues("appType");
		String rentalArr[] = request.getParameterValues("rentalStatus"); 
		
		params.put("appTypeArr", appTypeArr);
		params.put("rentalArr", rentalArr);
		
		List<EgovMap> rosCallList = null;
		
		LOGGER.info("############## selectRosCallLogList Params : " + params.toString());
		
		rosCallList = rosCallLogService.selectRosCallLogList(params);
		
		return ResponseEntity.ok(rosCallList);
		
	}
	
	
	@RequestMapping(value = "/newRosCallPop.do")
	public String newRosCallPop (@RequestParam Map<String, Object> params, SessionVO sessionVO, ModelMap model) throws Exception{
		
		/*** Billing Group (Grid Params)***/
		model.put("ordNo", params.get("ordNo"));
		model.put("ordId", params.get("salesOrderId"));
		model.put("custBillId", params.get("custBillId"));
		
		
		/****  Order Detail  ****/ 
		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);
		
        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		
		model.put("orderDetail", orderDetail);
		model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
		
		EgovMap basicMap = (EgovMap)orderDetail.get("basicInfo");
		
		params.put("ordId", params.get("salesOrderId"));
		params.put("salesOrdId", params.get("salesOrderId"));//sixmonth
		params.put("appTypeId", basicMap.get("appTypeId"));//sixmonth
		
		/**** OUTSTANDING ****/
		List<EgovMap> ordOutInfoList = orderLedgerService.getOderOutsInfo(params);
		EgovMap ordOutInfo = ordOutInfoList.get(0);
		LOGGER.debug("ordOutInfo =====================>>> " + ordOutInfo);
		model.addAttribute("ordOutInfo", ordOutInfo);
		
		/*** LAST 6 MONTH ***/
		List<EgovMap> resultList = orderDetailService.selectLast6MonthTransListNew(params);
		
		EgovMap sixMonthMap = new EgovMap();
		if(resultList != null && resultList.size() > 1 ){
			sixMonthMap = resultList.get(1);
		}else{
			sixMonthMap.put("curMonth", 0);
			sixMonthMap.put("prev1Month", 0);
		}
		model.addAttribute("sixMonthMap", sixMonthMap);
		
		/*** BILL MONTH(S)***/
		EgovMap billMonthMap = null;
		billMonthMap = rosCallLogService.getRentInstallLatestNo(params);
		model.addAttribute("billMonthMap", billMonthMap);
		
		/*** RENTAL STATUS ***/
		EgovMap rentalMap = null;
		rentalMap = rosCallLogService.getRentalStatus(params);
		model.addAttribute("rentalMap", rentalMap);
		
		/*** AGREEMENT LIST ***/
		List<EgovMap> agreList = orderLedgerService.selectAgreInfo(params);
		model.addAttribute("agreList", new Gson().toJson(agreList));
		
		/*** ORDER SALESMAN VIEW ***/
		EgovMap salesManMap = null;
		salesManMap = rosCallLogService.getOrderServiceMemberViewByOrderID(params);
		model.addAttribute("salesManMap", salesManMap);
		
		return "sales/rcms/newRosCallPop";
	}
	
	
	@RequestMapping(value = "/selectROSSMSCodyTicketLogList")
	public ResponseEntity<List<EgovMap>> selectROSSMSCodyTicketLogList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> smsList = null;
		smsList = rosCallLogService.selectROSSMSCodyTicketLogList(params);
		
		return ResponseEntity.ok(smsList);
		
	}
	
	
	@RequestMapping(value = "/getReasonCodeList")
	public ResponseEntity<List<EgovMap>> getReasonCodeList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> reasonList = null;
		
		reasonList = rosCallLogService.getReasonCodeList(params);
		
		return ResponseEntity.ok(reasonList);
		
	}
	
	
	@RequestMapping(value = "/getFeedbackCodeList")
	public ResponseEntity<List<EgovMap>> getFeedbackCodeList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> feedbackList = null;
		
		feedbackList = rosCallLogService.getFeedbackCodeList(params);
		
		return ResponseEntity.ok(feedbackList);
	}
	
	
	@RequestMapping(value = "/selectROSCallLogBillGroupOrderCnt")
	public ResponseEntity<List<EgovMap>> selectROSCallLogBillGroupOrderCnt(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> cntList = null;
		
		cntList = rosCallLogService.selectROSCallLogBillGroupOrderCnt(params); 
		
		return ResponseEntity.ok(cntList);
	}
	
	
	@RequestMapping(value = "/insertNewRosCall", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertNewRosCall(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception{
		
		Map<String, Object> rtnMap = new HashMap<String, Object>();;
		
		//Params
		params.put("userId", sessionVO.getUserId());
		//_____________________________________________________________________________________New Ros Call
		boolean isResult = false;
		isResult = rosCallLogService.insertNewRosCall(params);
		rtnMap.put("isResult",isResult);
		//_____________________________________________________________________________________Send SMS
		int chkSms =  Integer.parseInt(String.valueOf(params.get("chkSmS")));
		rtnMap.put("chkSms", chkSms);
		
		String smsResultMSg = "";
		
		List<String> mobileNumList = new ArrayList<String>();
		if(chkSms > 0){
			SmsVO sms = new SmsVO(sessionVO.getUserId(), 975);
			
			LOGGER.info(" Message Contents : " + (String)params.get("fullSms"));
			LOGGER.info(" Mobile Phone Number : " + (String)params.get("salesManMemTelMobile"));
			//mobileNumList.add((String) params.get("salesManMemTelMobile"));
			//TODO Test Phone Number (주석해제)
			mobileNumList.add("11111111");  
			
			sms.setMessage((String) params.get("fullSms"));
			sms.setMobiles(mobileNumList);  
			//send SMS
			SmsResult smsResult = adaptorService.sendSMS(sms);
			
			smsResultMSg += "Total Send Message : " + smsResult.getReqCount() + "</br>";
			smsResultMSg += "Success Count : " + smsResult.getSuccessCount() + "</br>";
			smsResultMSg += "Fail Count : " + smsResult.getFailCount() + "</br>";
			smsResultMSg += "Error Count : " + smsResult.getErrorCount() + "</br>";
			
			if(smsResult.getFailCount() > 0){
				smsResultMSg += "Fail Reason : " + smsResult.getFailReason() + "</br>";
			}
			
			rtnMap.put("smsResultMSg", smsResultMSg);
			rtnMap.put("total", smsResult.getReqCount());
			rtnMap.put("success", smsResult.getSuccessCount());
		}
		
		return ResponseEntity.ok(rtnMap);
	}
}
