package com.coway.trust.web.sales.ccp;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.ccp.CcpCalculateService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpCalculateController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpCalculateController.class);
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Resource(name = "ccpCalculateService") 
	private CcpCalculateService ccpCalculateService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@Autowired
	private AdaptorService adaptorService;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/selectCalCcpList.do")
	public String selectCalCcpList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		return "sales/ccp/ccpCalCcpList";
	}
	
	
	@RequestMapping(value="/getRegionCodeList")
	public ResponseEntity<List<EgovMap>> getRegionCodeList(@RequestParam Map<String, Object> params) throws Exception{
	
		List<EgovMap> regionCodeList = null;
		regionCodeList = ccpCalculateService.getRegionCodeList(params);
		
		return ResponseEntity.ok(regionCodeList);
		
	}
	
	
	@RequestMapping(value = "/selectDscCodeList")
	public ResponseEntity<List<EgovMap>> selectDscCodeList()throws Exception{
		
		List<EgovMap> dscCodeList = null;
		
		dscCodeList = ccpCalculateService.selectDscCodeList();
		
		return ResponseEntity.ok(dscCodeList);
		
	}
	
	
	@RequestMapping(value = "selectReasonCodeFbList")
	public ResponseEntity<List<EgovMap>> selectReasonCodeFbList() throws Exception{
		
		List<EgovMap> fbList = null;
		
		fbList = ccpCalculateService.selectReasonCodeFbList();
		
		return ResponseEntity.ok(fbList);
	}
	
	@RequestMapping(value = "/selectCalCcpListAjax")
	public ResponseEntity<List<EgovMap>> selectCalCcpListAjax(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{
		
		LOGGER.info("#############################################");
		LOGGER.info("#############selectCalCcpListAjax Start");
		LOGGER.info("############# params : " + params.get("calOrdNo"));
		LOGGER.info("#############################################");
		//Params Setting
		
		String arryCalCcpStatus[] = request.getParameterValues("calCcpStatus");
		String arryCalBranch[] = request.getParameterValues("calBranch");
		String arryCalReason[] = request.getParameterValues("calReason");
		
		params.put("arryCalCcpStatus", arryCalCcpStatus);
		params.put("arryCalBranch", arryCalBranch);
		params.put("arryCalReason", arryCalReason);
		
		//Call Service
		List<EgovMap> calList = null;
		
		calList = ccpCalculateService.selectCalCcpListAjax(params);
		
		return ResponseEntity.ok(calList);
		
	}
	
	
	@RequestMapping(value = "/selectCalCcpViewEditPop.do")
	public String selectCalCcpViewEditPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
		
		LOGGER.info("############################################################");
		LOGGER.info("############ CalCcpViewEditPop Params Confirm : " + params.toString());
		LOGGER.info("############################################################");
		
		//Log Service
		EgovMap prgMap = null;
		BigDecimal prgDecimal = null;
		int resultVal = 0;
		prgMap = ccpCalculateService.getLatestOrderLogByOrderID(params);
		prgDecimal = (BigDecimal)prgMap.get("prgrsId");
		resultVal = prgDecimal.intValue();
		
    	//params Set
    	params.put("prgrsId", resultVal); 
    	params.put("salesOrderId", params.get("salesOrdId"));
    	//service1
    	EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    	EgovMap salesMan = ccpCalculateService.selectSalesManViewByOrdId(params);
    	
    	
    	EgovMap tempMap = null;
    	tempMap = (EgovMap)orderDetail.get("basicInfo");
    	
    	BigDecimal tempIntval = (BigDecimal)tempMap.get("custTypeId");
    	
    	//Set Param
    	if(tempIntval.intValue() == 965){
    		model.addAttribute("ccpMasterId", "1"); //Company
    		params.put("ccpMasterId", "1"); //order unit MasterId
    	}else{
    		model.addAttribute("ccpMasterId", "0"); //Individual
    		params.put("ccpMasterId", "2"); //oder unit MasterId
    	}
    	
    	EgovMap fieldMap = null;
    	//params Set
    	params.put("custId", tempMap.get("custId"));
    	
    	fieldMap = ccpCalculateService.getCalViewEditField(params);
    	
    	
    	//loadIncomRange
    	Map<String, Object> incomMap = new HashMap<String, Object>();
    	incomMap = ccpCalculateService.selectLoadIncomeRange(params);
    	
    	
    	//ccpId
    	EgovMap ccpInfoMap = null;
    	ccpInfoMap = ccpCalculateService.selectCcpInfoByCcpId(params);
    	
    	//Model
    	model.addAttribute("ccpId", params.get("ccpId"));
    	model.addAttribute("orderDetail", orderDetail);
    	model.addAttribute("fieldMap", fieldMap);
    	model.addAttribute("incomMap", incomMap);
    	model.addAttribute("ccpInfoMap", ccpInfoMap);
    	model.addAttribute("salesMan", salesMan);
			
		//return 
		if(resultVal > 1){
			return "sales/ccp/ccpCalCCpViewPop";
		}else{
			return "sales/ccp/ccpCalCcpViewEditPop";
		}
	}
	
	
	@RequestMapping(value = "/ccpCalCCpViewPop.do")
	public String ccpCalCCpViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
		
		LOGGER.info("############################################################");
		LOGGER.info("############ CalCcpViewPop Params Confirm : " + params.toString());
		LOGGER.info("############################################################");
		
		//Log Service
		EgovMap prgMap = null;
		BigDecimal prgDecimal = null;
		int resultVal = 0;
		prgMap = ccpCalculateService.getLatestOrderLogByOrderID(params);
		prgDecimal = (BigDecimal)prgMap.get("prgrsId");
		resultVal = prgDecimal.intValue();
		
    	//params Set
    	params.put("prgrsId", resultVal); 
    	params.put("salesOrderId", params.get("salesOrdId"));
    	//service1
    	EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
    	EgovMap salesMan = ccpCalculateService.selectSalesManViewByOrdId(params);
    	
    	
    	EgovMap tempMap = null;
    	tempMap = (EgovMap)orderDetail.get("basicInfo");
    	
    	BigDecimal tempIntval = (BigDecimal)tempMap.get("custTypeId");
    	
    	//Set Param
    	if(tempIntval.intValue() == 965){
    		model.addAttribute("ccpMasterId", "1"); //Company
    		params.put("ccpMasterId", "1"); //order unit MasterId
    	}else{
    		model.addAttribute("ccpMasterId", "0"); //Individual
    		params.put("ccpMasterId", "2"); //oder unit MasterId
    	}
    	
    	EgovMap fieldMap = null;
    	//params Set
    	params.put("custId", tempMap.get("custId"));
    	
    	fieldMap = ccpCalculateService.getCalViewEditField(params);
    	
    	
    	//loadIncomRange
    	Map<String, Object> incomMap = new HashMap<String, Object>();
    	incomMap = ccpCalculateService.selectLoadIncomeRange(params);
    	
    	
    	//ccpId
    	EgovMap ccpInfoMap = null;
    	ccpInfoMap = ccpCalculateService.selectCcpInfoByCcpId(params);
    	
    	//Model
    	model.addAttribute("ccpId", params.get("ccpId"));
    	model.addAttribute("orderDetail", orderDetail);
    	model.addAttribute("fieldMap", fieldMap);
    	model.addAttribute("incomMap", incomMap);
    	model.addAttribute("ccpInfoMap", ccpInfoMap);
    	model.addAttribute("salesMan", salesMan);
			
		//return 
    	return "sales/ccp/ccpCalCCpViewPop";
		
	}

	
	@RequestMapping(value = "/getOrderUnitList")
	public ResponseEntity<List<EgovMap>> getOrderUnitList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> unitList = null;
		
		unitList = ccpCalculateService.getOrderUnitList(params);
		
		return ResponseEntity.ok(unitList);
		
	}
	
	
	@RequestMapping(value = "/getCcpStusCodeList")
	public ResponseEntity<List<EgovMap>> getCcpStusCodeList() throws Exception{
		
		List<EgovMap> cList = null;
		cList = ccpCalculateService.getCcpStusCodeList();
		
		return ResponseEntity.ok(cList);
		
	}
	
	
	@RequestMapping(value = "/getCcpRejectCodeList")
	public ResponseEntity<List<EgovMap>> getCcpRejectCodeList() throws Exception{
		
		List<EgovMap> rList = null;
		
		rList = ccpCalculateService.getCcpRejectCodeList();
		
		return ResponseEntity.ok(rList);
		
	}
	
	
	@RequestMapping(value = "/getLoadIncomeRange")
	public ResponseEntity<List<EgovMap>> getLoadIncomeRange(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> incomList = null;
		
		incomList = ccpCalculateService.getLoadIncomeRange(params);
		
		return ResponseEntity.ok(incomList);
	}
	
	
	@RequestMapping(value = "/getFicoScoreByAjax")
	public ResponseEntity<EgovMap> getFicoScoreByAjax(@RequestParam Map<String, Object> params) throws Exception{
		//ccpId
		LOGGER.info("###########  CCPINFO AJAX Params : " + params.toString());
    	EgovMap ccpInfoMap = null;
    	ccpInfoMap = ccpCalculateService.selectCcpInfoByCcpId(params);
    	
    	return ResponseEntity.ok(ccpInfoMap);
		
	}
	
	
	@RequestMapping(value = "/countCallEntry")
	public ResponseEntity<EgovMap> countCallEntry(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap callMap = null;
		callMap = ccpCalculateService.countCallEntry(params);
		
		return ResponseEntity.ok(callMap);
		
	}
	
	
	@RequestMapping(value = "/calSave", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> calSave(@RequestBody Map<String, Object> params) throws Exception{
		
		//Session
		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());
		params.put("userFullName", session.getUserFullname());
		params.put("userBranchId", session.getUserBranchId());
		//Params Setting
		
		/*### Reject Status Params Setting ####*/
		if(params.get("rejectStatusEdit") != null){
			
    		if(params.get("rejectStatusEdit").equals("12")){
    			
    			params.put("statusEdit", "1");
    			params.put("rejectStatusEdit", "0");
    			params.put("updateCCPIssynch", "0");
    			
    		}else{
    			
    			if( null == params.get("statusEdit") || ("").equals(params.get("statusEdit"))){
    				params.put("statusEdit", "0");
    			}
    			
    			if( null == params.get("rejectStatusEdit") || ("").equals(params.get("rejectStatusEdit"))){
    				params.put("rejectStatusEdit", "0");
    			}
    			params.put("updateCCPIssynch", "0");
    		}
		
		}
		
		/*####  Total Score Point ####*/
		if( null == params.get("ccpTotalScorePoint") || ("").equals(params.get("ccpTotalScorePoint"))){
			params.put("ccpTotalScorePoint", "0");
		}
		
		/*####  Reason Code ####*/
		if( null == params.get("reasonCodeEdit") || ("").equals(params.get("reasonCodeEdit"))){
			params.put("reasonCodeEdit", "0");
		}
		
		/*####  Special Remark ####*/
		if( null == params.get("spcialRem") || ("").equals(params.get("spcialRem"))){
			
			params.put("spcialRem", "");
		}
		
		/*####  PNC Rem ####*/
		if( null == params.get("pncRem") || ("").equals(params.get("pncRem"))){
			
			params.put("pncRem", "");
		}
		
		/*####  Fico Score ####*/
		if( null == params.get("ficoScore") || ("").equals(params.get("ficoScore"))){
			params.put("ficoScore", "0");
		}
		
		params.put("hasGrnt", "0");
		
		LOGGER.info("#####################################################");
		LOGGER.info("######  params.ToString : " + params.toString());
		LOGGER.info("#####################################################");
		
		//Service
		ccpCalculateService.calSave(params);
		//Send SMS
		int chkSms =  Integer.parseInt(String.valueOf(params.get("isChkSms")));
		String smsResultMSg = "";
		List<String> mobileNumList = new ArrayList<String>();
		if(chkSms > 0){
			SmsVO sms = new SmsVO(session.getUserId(), 975);
			
			LOGGER.info(" Message Contents : " + (String)params.get("hiddenUpdSmsMsg"));
			LOGGER.info(" Mobile Phone Number : " + (String)params.get("hiddenSalesMobile"));
			//mobileNumList.add((String) params.get("hiddenSalesMobile"));
			//TODO Test Phone Number (주석해제)
			mobileNumList.add("11111111");  
			
			sms.setMessage((String) params.get("hiddenUpdSmsMsg"));
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
			
		}
		//Return MSG
		ReturnMessage message = new ReturnMessage();
		
	    message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(smsResultMSg));
		
		return ResponseEntity.ok(message); 
		
	}
	
	
	
	
	@RequestMapping(value = "/ccpCalCcpCustInfoLimitEditPop.do")
	public String selectCalCustInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		LOGGER.info("#####################################################");
		LOGGER.info("######  params.ToString : " + params.toString());
		LOGGER.info("#####################################################");
		
		
		return "sales/ccp/ccpCalCcpCustInfoLimitEditPop";
	}
	
	/* RPT */
	
	@RequestMapping(value = "/goCcpPerformancePop.do")
	public String goCcpPerformancePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		String toMonth = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT4);
		
		
		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		model.put("toMonth", toMonth);
		
		
		
		return "sales/ccp/ccpCalPerformancePop";
	}
	
}

