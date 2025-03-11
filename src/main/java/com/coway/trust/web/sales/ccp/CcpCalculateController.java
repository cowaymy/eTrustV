package com.coway.trust.web.sales.ccp;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.sales.ccp.CcpCalculateService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpCalculateController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpCalculateController.class);

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "ccpCalculateService")
	private CcpCalculateService ccpCalculateService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "orderListService")
	private OrderListService orderListService;

	@Resource(name = "memberListService")
	private MemberListService memberListService;

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
		String arryERstatus[] = request.getParameterValues("eRstatus");

		params.put("arryCalCcpStatus", arryCalCcpStatus);
		params.put("arryCalBranch", arryCalBranch);
		params.put("arryCalReason", arryCalReason);
		params.put("arryERstatus", arryERstatus);

		//Call Service
		List<EgovMap> calList = null;

		calList = ccpCalculateService.selectCalCcpListAjax(params);

		return ResponseEntity.ok(calList);

	}


	@RequestMapping(value = "/selectCalCcpViewEditPop.do")
	public String selectCalCcpViewEditPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		LOGGER.info("############################################################");
		LOGGER.info("############ CalCcpViewEditPop Params Confirm: " + params.toString());
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

    	// START selectOwnPurchaseInfo
    	if(tempMap.get("memInfo") != null){
    		EgovMap ownPurcInfo = ccpCalculateService.selectOwnPurchaseInfo(params.get("salesOrdId"));
        	model.addAttribute("ownPurchaseInfo", ownPurcInfo);
    		LOGGER.info("ownPurcInfo: " + ownPurcInfo);

          	if (ownPurcInfo != null){

          		// to get join period in years and months
          		if (ownPurcInfo.get("joinPeriod") != null){
          			BigDecimal joinPeriod = (BigDecimal)ownPurcInfo.get("joinPeriod");
          	      	int months = joinPeriod.intValue();
          	      	int years = months /12;
          	      	int remainMonth = months % 12;
          	    	model.addAttribute("joinYear", years);
          	    	model.addAttribute("joinMonth", months > 12 ? remainMonth : months);

          		}
          	}
    	}

      	// END selectOwnPurchaseInfo


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

    	//eResubmit
    	EgovMap ccpEresubmitMap = null;
    	ccpEresubmitMap = ccpCalculateService.selectCcpEresubmitView(params);
    	LOGGER.info("Check 1");

    	//Model
    	model.addAttribute("ccpId", params.get("ccpId"));
    	model.addAttribute("orderDetail", orderDetail);
    	model.addAttribute("fieldMap", fieldMap);
    	model.addAttribute("incomMap", incomMap);
    	model.addAttribute("ccpInfoMap", ccpInfoMap);
    	model.addAttribute("salesMan", salesMan);
    	model.addAttribute("ccpEresubmitMap", ccpEresubmitMap);
    	model.addAttribute("memType", sessionVO.getUserTypeId());

		//return
		if(resultVal > 1){
			return "sales/ccp/ccpCalCCpViewPop";
		}else{
			return "sales/ccp/ccpCalCcpViewEditPop";
		}
	}


	@RequestMapping(value = "/ccpCalCCpViewPop.do")
	public String ccpCalCCpViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		LOGGER.info("azimah ke ni############################################################");
		LOGGER.info("############ CalCcpViewPop Params Confirm : " + params.toString());
		LOGGER.info("azimah ke ni????############################################################");

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

    	// START selectOwnPurchaseInfo
    	if(tempMap.get("memInfo") != null){
    		EgovMap ownPurcInfo = ccpCalculateService.selectOwnPurchaseInfo(params.get("salesOrdId"));
        	model.addAttribute("ownPurchaseInfo", ownPurcInfo);
    		LOGGER.info("ownPurcInfo: " + ownPurcInfo);

          	if (ownPurcInfo != null){

          		// to get join period in years and months
          		if (ownPurcInfo.get("joinPeriod") != null){
          			BigDecimal joinPeriod = (BigDecimal)ownPurcInfo.get("joinPeriod");
          	      	int months = joinPeriod.intValue();
          	      	int years = months /12;
          	      	int remainMonth = months % 12;
          	    	model.addAttribute("joinYear", years);
          	    	model.addAttribute("joinMonth", months > 12 ? remainMonth : months);

          		}
          	}
    	}

      	// END selectOwnPurchaseInfo

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

    	//eResubmit
    	EgovMap ccpEresubmitMap = null;
    	ccpEresubmitMap = ccpCalculateService.selectCcpEresubmit(params);
    	LOGGER.info("Check 2");

    	//Model
    	model.addAttribute("ccpId", params.get("ccpId"));
    	model.addAttribute("approvalStus", params.get("approvalStus"));
    	model.addAttribute("orderDetail", orderDetail);
    	model.addAttribute("fieldMap", fieldMap);
    	model.addAttribute("incomMap", incomMap);
    	model.addAttribute("ccpInfoMap", ccpInfoMap);
    	model.addAttribute("salesMan", salesMan);
    	model.addAttribute("ccpEresubmitMap", ccpEresubmitMap);
    	model.addAttribute("memType", sessionVO.getUserTypeId());

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

	@RequestMapping(value = "/getCcpStusCodeList2")
	public ResponseEntity<List<EgovMap>> getCcpStusCodeList2() throws Exception{

		List<EgovMap> cList2 = null;
		cList2 = ccpCalculateService.getCcpStusCodeList2();

		return ResponseEntity.ok(cList2);

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
//experian fix
        if( null == params.get("experianScore") || ("").equals(params.get("experianScore"))){
            params.put("experianScore", "0");
        }
        if( null == params.get("experianRisk") || ("").equals(params.get("experianRisk"))){
            params.put("experianRisk", "0");
        }
//experian fix
		/*####  eResubmit status ####*/
		if( null == params.get("eRstatusEdit") || ("").equals(params.get("eRstatusEdit"))){
			params.put("eRstatusEdit", "0");
		}

		params.put("hasGrnt", "0");

		LOGGER.info("#####################################################");
		LOGGER.info("######  params.ToString : " + params.toString());
		LOGGER.info("#####################################################");

		//Service
		ccpCalculateService.calSave(params);

		if(!params.get("bndlId").equals("")){
		  Map<String, Object> auxParam =  ccpCalculateService.getAux(params);
		  if(auxParam != null){
		    params.put("saveCcpId", auxParam.get("ccpId"));
	        params.put("saveOrdId", auxParam.get("ccpSalesOrdId"));
	        params.put("payMode", auxParam.get("modeId"));
	        params.put("auxAppType", 1);
	        ccpCalculateService.calSave(params);
		  }
        }

		//Send SMS
		/*int chkSms =  Integer.parseInt(String.valueOf(params.get("isChkSms")));
		String smsResultMSg = "";
		List<String> mobileNumList = new ArrayList<String>();
		if(chkSms > 0){
			SmsVO sms = new SmsVO(session.getUserId(), 975);

			LOGGER.info(" Message Contents : " + (String)params.get("hiddenUpdSmsMsg"));
			LOGGER.info(" Mobile Phone Number : " + (String)params.get("hiddenSalesMobile"));
			//mobileNumList.add((String) params.get("hiddenSalesMobile"));
			mobileNumList.add("0175977998"); //For Testing purpose only

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

		}*/
		//Return MSG
		ReturnMessage message = new ReturnMessage();

	    message.setCode(AppConstants.SUCCESS);
		//message.setMessage(messageAccessor.getMessage(smsResultMSg));

		return ResponseEntity.ok(message);

	}




	@RequestMapping(value = "/ccpCalCcpCustInfoLimitEditPop.do")
	public String selectCalCustInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.info("#####################################################");
		LOGGER.info("######  params.ToString : " + params.toString());
		LOGGER.info("#####################################################");


		return "sales/ccp/ccpCalCcpCustInfoLimitEditPop";
	}


	@RequestMapping(value = "/getResultRowForCTOSDisplayForCCPCalculation")
	public ResponseEntity<Map<String, Object>> getResultRowForCTOSDisplayForCCPCalculation(@RequestParam Map<String, Object> params) throws Exception{

		Map<String, Object> rtnMap =	ccpCalculateService.getResultRowForCTOSDisplayForCCPCalculation(params);

		LOGGER.info("####################ResultRow Chk RESULT : " + rtnMap.toString());
		return ResponseEntity.ok(rtnMap);
	}
//EXPERIAN PROJECT
   @RequestMapping(value = "/getResultRowForEXPERIANDisplayForCCPCalculation")
    public ResponseEntity<Map<String, Object>> getResultRowForEXPERIANDisplayForCCPCalculation(@RequestParam Map<String, Object> params) throws Exception{

        Map<String, Object> exprtnMap = ccpCalculateService.getResultRowForEXPERIANDisplayForCCPCalculation(params);

        LOGGER.info("####################ResultRow Chk RESULT : " + exprtnMap.toString());
        return ResponseEntity.ok(exprtnMap);
    }
 //EXPERIAN PROJECT
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


	@RequestMapping(value = "/ccpCalInstallationAreaPop.do")
	public String ccpCalInstallationAreaPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/ccp/ccpCalInstallationAreaPop";
	}


	@RequestMapping(value = "/getCcpInstallationList")
	public ResponseEntity<List<EgovMap>> getCcpInstallationList(@RequestParam Map<String, Object> params) throws Exception{
		List<EgovMap> instList = null;
		instList = ccpCalculateService.getCcpInstallationList(params);
		return ResponseEntity.ok(instList);
	}

	@RequestMapping(value = "/ccpCalOrderModifyPop.do")
	public String orderModifyPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {

		String callCenterYn = "N";

		if(CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))){
			callCenterYn = "Y";
		}

		//[Tap]Basic Info
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);//APP_TYPE_ID CUST_ID
		EgovMap basicInfo = (EgovMap) orderDetail.get("basicInfo");

		model.put("orderDetail",  orderDetail);
		model.put("salesOrderId", params.get("salesOrderId"));
		model.put("ordEditType",  params.get("ordEditType"));
		model.put("custId",       basicInfo.get("custId"));
		model.put("appTypeId",    basicInfo.get("appTypeId"));
		model.put("appTypeDesc",  basicInfo.get("appTypeDesc"));
		model.put("salesOrderNo", basicInfo.get("ordNo"));
		model.put("custNric",     basicInfo.get("custNric"));
		model.put("ordStusId",    basicInfo.get("ordStusId"));
		model.put("toDay", 		  CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
		model.put("promoCode",    basicInfo.get("ordPromoCode"));
		model.put("promoDesc",    basicInfo.get("ordPromoDesc"));
		model.put("srvPacId",     basicInfo.get("srvPacId"));
		model.put("callCenterYn", callCenterYn);
		model.put("memType",      sessionVO.getUserTypeId());
		model.put("ordPvMonth",     basicInfo.get("ordPvMonth"));
		model.put("ordPvYear",     basicInfo.get("ordPvYear"));
		model.put("typeId",     basicInfo.get("typeId"));


		return "sales/ccp/ccpCalOrderModifyPop";
	}

	@RequestMapping(value = "/ccpEresubmit.do")
	  public String ccpEresubmit(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) throws Exception{
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){

			params.put("userId", sessionVO.getUserId());
			EgovMap result =  salesCommonService.getUserInfo(params);

			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
		}

	      return "sales/ccp/ccpEresubmitList";
	  }

	@RequestMapping(value = "/selectCcpEresubmitListAjax")
	public ResponseEntity<List<EgovMap>> selectCcpEresubmitListAjax(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{

		LOGGER.info("#############################################");
		LOGGER.info("#############selectCcpEresubmitListAjax Start");
		LOGGER.info("############# params : " + params.toString());
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

	@RequestMapping(value = "/ccpEresubmitNew.do")
	public String ccpEresubmitNew(@RequestParam Map<String, Object> params, ModelMap model) {

		return "sales/ccp/ccpEresubmitNewPop";
	}

	@RequestMapping(value = "/ccpEresubmitNewConfirm" ,method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>>  ccpEresubmitNewConfirm(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {

		if(params.containsKey("SalesmanCode")) {
            if(!"".equals(params.get("SalesmanCode").toString())) {
            	params.put("salesmanCode", params.get("SalesmanCode"));
                int memberID = ccpCalculateService.getMemberID(params);
                params.put("memID", memberID);
            }
        }

		List<EgovMap>  list = ccpCalculateService.ccpEresubmitNewConfirm(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/ccpEresubmitViewPop.do")
	public ResponseEntity<Map> ccpEresubmitViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		LOGGER.info("############################################################");
		LOGGER.info("############ ccpEresubmitViewPop Params : " + params.toString());
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

//    	EgovMap fieldMap = null;
    	//params Set
    	params.put("custId", tempMap.get("custId"));

//    	fieldMap = ccpCalculateService.getCalViewEditField(params);


    	//loadIncomRange
//    	Map<String, Object> incomMap = new HashMap<String, Object>();
//    	incomMap = ccpCalculateService.selectLoadIncomeRange(params);


    	//ccpId
    	EgovMap ccpInfoMap = null;
    	ccpInfoMap = ccpCalculateService.selectCcpInfoByOrderId(params);

    	//eResubmit
    	EgovMap ccpEresubmitMap = null;
    	ccpEresubmitMap = ccpCalculateService.selectCcpEresubmit(params);
    	LOGGER.info("Check 3");

    	//Model
//    	model.addAttribute("ccpId", ccpInfoMap.get("ccpId"));
//    	model.addAttribute("orderDetail", orderDetail);
//    	model.addAttribute("fieldMap", fieldMap);
//    	model.addAttribute("incomMap", incomMap);
//    	model.addAttribute("ccpInfoMap", ccpInfoMap);
//    	model.addAttribute("salesMan", salesMan);

		//return
//    	return "sales/ccp/ccpEresubmitViewPop";

    	Map<String, Object> map = new HashMap();
		map.put("ccpId", ccpInfoMap.get("ccpId"));
		map.put("orderDetail", orderDetail);
		map.put("ccpInfoMap", ccpInfoMap);
		map.put("ccpEresubmitMap", ccpEresubmitMap);

		//logger.debug("srvconfig====>"+srvconfig.toString());


		return ResponseEntity.ok(map);

	}


	@RequestMapping(value = "/ccpEresubmitList")
	public ResponseEntity<List<EgovMap>>  ccpEresubmitList(@RequestParam Map<String, Object> params,HttpServletRequest request, Model mode)	throws Exception {
		List<EgovMap> list = null;

		if(params.containsKey("SalesmanCode")) {
            if(!"".equals(params.get("SalesmanCode").toString())) {
            	params.put("salesmanCode", params.get("SalesmanCode"));
                int memberID = ccpCalculateService.getMemberID(params);
                params.put("memID", memberID);
            }
        }

		String arryCmbResubmitStatus[] = request.getParameterValues("cmbResubmitStatus");
		params.put("arryCmbResubmitStatus", arryCmbResubmitStatus);

		String arryCmbCcpStatus[] = request.getParameterValues("cmbCcpStatus");
		params.put("arryCmbCcpStatus", arryCmbCcpStatus);

		list = ccpCalculateService.ccpEresubmitList(params);

		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/ccpEresubmitSave", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> ccpEresubmitSave(@RequestBody Map<String, Object> params) throws Exception{
		//Session
		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());

		LOGGER.info("#####################################################");
		LOGGER.info("######  params.ToString : " + params.toString());
		LOGGER.info("#####################################################");

		//Service
		ccpCalculateService.ccpEresubmitNewSave(params);

		//Return MSG
		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("");

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/ccpEresubmitUpdate", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> ccpEresubmitUpdate(@RequestBody Map<String, Object> params) throws Exception{
		//Session
		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());

		LOGGER.info("#####################################################");
		LOGGER.info("######  params.ToString : " + params.toString());
		LOGGER.info("#####################################################");

		//Service
		ccpCalculateService.ccpEresubmitUpdate(params);

		//Return MSG
		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("");

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/ccpEresubmitViewEditPop.do")
	public String ccpEresubmitViewEditPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		LOGGER.info("############################################################");
		LOGGER.info("############ ccpEresubmitViewPop Params : " + params.toString());
		LOGGER.info("############################################################");

		params.put("userId", sessionVO.getUserId());
		params.put("userNm", sessionVO.getUserName());
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

//    	EgovMap fieldMap = null;
    	//params Set
    	params.put("custId", tempMap.get("custId"));

//    	fieldMap = ccpCalculateService.getCalViewEditField(params);


    	//loadIncomRange
//    	Map<String, Object> incomMap = new HashMap<String, Object>();
//    	incomMap = ccpCalculateService.selectLoadIncomeRange(params);


    	//ccpId
    	EgovMap ccpInfoMap = null;
    	ccpInfoMap = ccpCalculateService.selectCcpInfoByOrderId(params);
    	LOGGER.info("Check Ezy CCP");

    	//eResubmit
    	EgovMap ccpEresubmitMap = null;
    	ccpEresubmitMap = ccpCalculateService.selectCcpEresubmitView(params);
    	LOGGER.info("Check 4");

    	EgovMap tempMap1 = null;
    	tempMap1 = (EgovMap)orderDetail.get("salesmanInfo");

    	params.put("salesmanCode", params.get("userNm"));
        int memberID = ccpCalculateService.getMemberID(params);
        ccpInfoMap.put("memID", memberID);

        if(tempMap1.get("memId").toString().equals(ccpInfoMap.get("memID").toString())){
        	ccpInfoMap.put("isModify", "Y");
        }else{
        	ccpInfoMap.put("isModify", "N");
        }

    	//Model
    	model.addAttribute("ccpId", ccpInfoMap.get("ccpId"));
    	model.addAttribute("isModify", ccpInfoMap.get("isModify"));
    	model.addAttribute("funcChange", params.get("funcChange"));
    	model.addAttribute("orderDetail", orderDetail);
//    	model.addAttribute("fieldMap", fieldMap);
//    	model.addAttribute("incomMap", incomMap);
    	model.addAttribute("ccpInfoMap", ccpInfoMap);
    	model.addAttribute("ccpEresubmitMap", ccpEresubmitMap);
//    	model.addAttribute("salesMan", salesMan);

		//return
//    	return "sales/ccp/ccpEresubmitViewPop";

//    	Map<String, Object> map = new HashMap();
//		map.put("ccpId", ccpInfoMap.get("ccpId"));
//		map.put("orderDetail", orderDetail);
//		map.put("ccpInfoMap", ccpInfoMap);

		//logger.debug("srvconfig====>"+srvconfig.toString());


		return "sales/ccp/ccpEresubmitViewEditPop";

	}

	@RequestMapping(value = "/attachResubmitFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachResubmitFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);
		String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		try{
			 Set set = request.getFileMap().entrySet();
			 Iterator i = set.iterator();

			 while(i.hasNext()) {
			     Map.Entry me = (Map.Entry)i.next();
			     String key = (String)me.getKey();
			     seqs.add(key);
			 }

			 //int fileGroupId = params.get("atchFileGrpId") != null ? params.get("atchFileGrpId").toString().equals("") ? 0 : (Integer.parseInt(params.get("atchFileGrpId").toString())) : 0 ;

			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "sales" + File.separator + "membership", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			LOGGER.debug("list.size : {}", list.size());
			params.put(CommonConstants.USER_ID, sessionVO.getUserId());

			ccpCalculateService.insertPreOrderAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

			params.put("attachFiles", list);

			/*if(fileGroupId == 0){
				int fileGroupIdNew = params.get("atchFileGrpId") != null ? params.get("atchFileGrpId").toString().equals("") ? 0 : (Integer.parseInt(params.get("atchFileGrpId").toString())) : 0 ;
				if(fileGroupIdNew != 0){
					params.put("atchFileGrpIdNew", fileGroupIdNew);
					ccpCalculateService.updateCcpEresubmitAttach(params);
				}
			}*/

			code = AppConstants.SUCCESS;
		}catch(ApplicationException e){
			err = e.getMessage();
			code = AppConstants.FAIL;
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData(params);
		message.setMessage(err);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/attachResubmitFileUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachResubmitFileUpdate(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);
		String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		try{
			 Set set = request.getFileMap().entrySet();
			 Iterator i = set.iterator();

			 while(i.hasNext()) {
			     Map.Entry me = (Map.Entry)i.next();
			     String key = (String)me.getKey();
			     seqs.add(key);
			 }

			 int fileGroupId = params.get("atchFileGrpId") != null ? params.get("atchFileGrpId").toString().equals("") ? 0 : (Integer.parseInt(params.get("atchFileGrpId").toString())) : 0 ;

			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, File.separator + "sales" + File.separator + "membership", AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			LOGGER.debug("list.size : {}", list.size());
			params.put(CommonConstants.USER_ID, sessionVO.getUserId());

			ccpCalculateService.updatePreOrderAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, params, seqs);

			params.put("attachFiles", list);

			if(fileGroupId == 0){
				int fileGroupIdNew = params.get("atchFileGrpId") != null ? params.get("atchFileGrpId").toString().equals("") ? 0 : (Integer.parseInt(params.get("atchFileGrpId").toString())) : 0 ;
				if(fileGroupIdNew != 0){
					params.put("atchFileGrpIdNew", fileGroupIdNew);
					ccpCalculateService.updateCcpEresubmitAttach(params);
				}
			}

			code = AppConstants.SUCCESS;
		}catch(ApplicationException e){
			err = e.getMessage();
			code = AppConstants.FAIL;
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData(params);
		message.setMessage(err);

		return ResponseEntity.ok(message);
	}

    @RequestMapping(value = "/ezyCcpRawDataPop.do")
    public String ccpRawDataPop() {

      return "sales/ccp/ezyCcpRawDataPop";
    }

    @RequestMapping(value = "/checkHistoryPop.do")
    public String checkHistoryPop(@RequestParam Map<String, Object> params, ModelMap model)
        throws Exception {

      return "/sales/ccp/checkHistoryPop";
    }

    @RequestMapping(value = "/checkHistoryList.do")
    public ResponseEntity checkHistoryList(@RequestParam Map<String, Object> params, ModelMap model)
        throws Exception {

      List<EgovMap>  ccpHistory = ccpCalculateService.selectCcpHistory(params);

      model.addAttribute("ccpHistory", new Gson().toJson(ccpHistory));

      return ResponseEntity.ok(ccpHistory);
    }

	@RequestMapping(value = "/ccpEresubmitUpdateCancel", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> ccpEresubmitUpdateCancel(@RequestBody Map<String, Object> params) throws Exception{
		//Session
		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());

		LOGGER.info("#####################################################");
		LOGGER.info("######  params.ToString : " + params.toString());
		LOGGER.info("#####################################################");

		//Service
		ccpCalculateService.ccpEresubmitUpdateCancel(params);

		//Return MSG
		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("");

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/ccpCalReverseApproval", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> ccpCalReverseApproval(@RequestBody Map<String, Object> params) throws Exception{
		//Session
		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());

		LOGGER.info("#####################################################");
		LOGGER.info("######  params.ToString : " + params.toString());
		LOGGER.info("#####################################################");

		//Service
		ccpCalculateService.ccpCalReverseApproval(params);

		//Return MSG
		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("");

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectCcpStusHistJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCcpStusHistJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		LOGGER.debug("!@##############################################################################");
		LOGGER.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		LOGGER.debug("!@##############################################################################");

		List<EgovMap> list = ccpCalculateService.selectCcpStusHistList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/ccpQuery.do")
	public String ccpQuery(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		model.put("memType", session.getUserTypeId());

		params.put("userId", session.getUserId());
		EgovMap org = memberListService.getOrgDtls(params);
		if (org != null) {
			switch (((BigDecimal) org.get("memLvl")).intValue()) {
				case 1:
					model.put("deptCode", org.get("lastOrgCode"));
					break;
				case 2:
					model.put("deptCode", org.get("lastGrpCode"));
					break;
				default:
					model.put("deptCode", org.get("lastDeptCode"));
			}
		}

		return "sales/ccp/ccpQuery";
	}

	@RequestMapping(value="/selectCcpTicket.do", method=RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCcpTicket(@RequestParam Map<String, Object>params) throws Exception {

		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		params.put("userId", session.getUserId());

		return ResponseEntity.ok(ccpCalculateService.selectCCPTicket(params));
	}

	@RequestMapping(value="/newCCPTicketPop.do")
	public String newCCPTicketPop(@RequestParam Map<String, Object> p) throws Exception {
		return "sales/ccp/newCCPTicketPop";
	}

	@RequestMapping(value="/createCCPTicket.do", method=RequestMethod.POST)
	public ResponseEntity<ReturnMessage> createCCPTicket(@RequestBody Map<String, Object> p) throws Exception {

		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		p.put("userId", session.getUserId());

		p.put("status", "1");

		ccpCalculateService.createCCPTicket(p);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Ticket created!");

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value="/editCCPTicketPop.do")
	public String editCCPTicketPop(@RequestParam Map<String, Object> p, ModelMap model) throws Exception {
		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		String userName = session.getUserName();

		EgovMap ticketDetails = ccpCalculateService.ccpTicketDetails(p);

		List<EgovMap> logs = (List<EgovMap>) ticketDetails.get("logs");
		List<String> ccpMembers = ccpCalculateService.ccpMembers();
		List<EgovMap> ccpLogs = logs.stream().filter(log -> ccpMembers.contains(log.get("userName"))).collect(Collectors.toList());
		ticketDetails.put("ccpLogs", ccpLogs);

		model.put("ticketDetails", ticketDetails);

		if (ccpMembers.contains(userName)) {
			model.put("ccpMember", 1);
		} else {
			model.put("ccpMember", 0);
		}

		List<EgovMap> orgDetails = ccpCalculateService.orgDetails(ticketDetails);
		model.put("orgDetails", orgDetails);

		model.put("ticketId", p.get("ticketId"));

		return "sales/ccp/editCCPTicketPop";
	}

	@RequestMapping(value="/updateCCPTicket.do", method=RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCCPTicket(@RequestBody Map<String, Object> p) throws Exception {

		SessionVO session  = sessionHandler.getCurrentSessionInfo();
		p.put("userId", session.getUserId());

		ccpCalculateService.updateCCPTicket(p);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Ticket updated!");

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getScoreGrpByAjax")
	public ResponseEntity<EgovMap> getScoreGrpByAjax(@RequestParam Map<String, Object> params) {
		LOGGER.info("###########  CCP SCORE GROUP AJAX Params : " + params.toString());
    	EgovMap ccpScoreGrpMap = null;
    	ccpScoreGrpMap = ccpCalculateService.getScoreGrpByAjax(params);

    	return ResponseEntity.ok(ccpScoreGrpMap);

	}

	@RequestMapping(value = "/attachCcpReportFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachCcpReportFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "sales" + File.separator + "ccp", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		ccpCalculateService.insertCcpAttachAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params);

		params.put("attachFiles", list);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}

