/**
 *
 */
package com.coway.trust.web.sales.order;

import java.text.ParseException;
import java.util.Date;
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
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.eRequestCancellationService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.installation.InstallationResultListService;
import com.coway.trust.biz.services.mlog.MSvcLogApiService;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/sales/order")
public class eRequestCancellationController {


private static Logger logger = LoggerFactory.getLogger(eRequestCancellationController.class);

	@Resource(name = "eRequestCancellationService")
	private eRequestCancellationService eRequestCancellationService;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/eRequestCancellationList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());

		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
			EgovMap getUserInfo = salesCommonService.getUserInfo(params);
			model.put("memType", getUserInfo.get("memType"));
			model.put("orgCode", getUserInfo.get("orgCode"));
			model.put("grpCode", getUserInfo.get("grpCode"));
			model.put("deptCode", getUserInfo.get("deptCode"));
			model.put("memCode", getUserInfo.get("memCode"));
			logger.info("memType ##### " + getUserInfo.get("memType"));
		}

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "sales/order/eRequestCancellation";
	}


	@RequestMapping(value = "/selectRequestOrderJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request,SessionVO sessionVO, ModelMap model) {

		String[] arrAppType   = request.getParameterValues("appType"); //Application Type
		String[] arrOrdStusId = request.getParameterValues("ordStusId"); //Order Status
		String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId"); //Key-In Branch
		String[] arrDscBrnchId = request.getParameterValues("dscBrnchId"); //DSC Branch
		String[] arrRentStus = request.getParameterValues("rentStus"); //Rent Status

		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");

    	params.put("userId", sessionVO.getUserId());
    	params.put("roleId",sessionVO.getRoleId());

    	params.put("ordStartDt", CommonUtils.changeFormat(String.valueOf(params.get("ordStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("ordEndDt", CommonUtils.changeFormat(String.valueOf(params.get("ordEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrAppType      != null && !CommonUtils.containsEmpty(arrAppType))      params.put("arrAppType", arrAppType);
		if(arrOrdStusId    != null && !CommonUtils.containsEmpty(arrOrdStusId))    params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   != null && !CommonUtils.containsEmpty(arrDscBrnchId))   params.put("arrDscBrnchId", arrDscBrnchId);
		if(arrRentStus     != null && !CommonUtils.containsEmpty(arrRentStus))     params.put("arrRentStus", arrRentStus);

		if(params.get("custIc") == null) {logger.debug("!@###### custIc is null");}
		if("".equals(params.get("custIc"))) {logger.debug("!@###### custIc ''");}

		logger.debug("!@##############################################################################");
		//logger.debug("!@###### userId : "+sessionVO.getUserId());
		//logger.debug("!@###### roleId : "+sessionVO.getRoleId());
		logger.debug("!@###### ordNo : "+params.get("ordNo"));
		logger.debug("!@###### ordStartDt : "+params.get("ordStartDt"));
		logger.debug("!@###### ordEndDt : "+params.get("ordEndDt"));
		logger.debug("!@###### ordDt : "+params.get("ordDt"));
		logger.debug("!@###### custIc : "+params.get("custIc"));
		logger.debug("!@##############################################################################");

		List<EgovMap> orderList = eRequestCancellationService.selectOrderList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orderList);
	}

	@RequestMapping(value = "/eRequestCancellationDetailPop.do")
	public String geteRequestCancellationDetailPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {

		//params.put("salesOrderId", 256488);

		int prgrsId = 0;
		String regStage = "";

		params.put("prgrsId", prgrsId);

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");

		//[Tap]Basic Info
		EgovMap orderDetail = eRequestCancellationService.selectOrderBasicInfo(params, sessionVO);//

		model.put("orderDetail", orderDetail);
		//model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
		// order detail end
		logger.info("##### params ########" + params);
		logger.info("##### salesOrderId #####" +(String)params.get("salesOrderId"));
		EgovMap cancelReqInfo = eRequestCancellationService.cancelReqInfo(params);

		model.addAttribute("cancelReqInfo", cancelReqInfo);

		return "sales/order/eRequestCancellationDetailPop";
	}


	@RequestMapping(value = "/eRequestCancellationPop.do")
	public String eRequestCancellationPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {

		String callCenterYn = "N";

		if(CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))){
			callCenterYn = "Y";
		}

		EgovMap orderDetail = eRequestCancellationService.selectOrderBasicInfo(params, sessionVO);//APP_TYPE_ID CUST_ID

		model.put("orderDetail", orderDetail);
		model.put("ordReqType",  params.get("ordReqType"));
		model.put("toDay", 		 CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("toDay", toDay);
		model.put("callCenterYn", callCenterYn);

		return "sales/order/eRequestCancellationPop";
	}


    @RequestMapping(value = "/checkeRequestAutoDebitDeduction.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> checkeRequestAutoDebitDeduction(@RequestParam Map<String, Object> params)    {
    	EgovMap rslt = eRequestCancellationService.checkeRequestAutoDebitDeduction(params);
    	return ResponseEntity.ok(rslt);
    }

    @RequestMapping(value = "/validRequestOCRStus.do", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> validRequestOCRStus(@RequestParam Map<String, Object> params)    {
    	EgovMap rslt = eRequestCancellationService.validRequestOCRStus(params);
    	return ResponseEntity.ok(rslt);
    }

	@RequestMapping(value = "/eRequestCancelOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> eRequestCancelOrder(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		int UserTypeID = sessionVO.getUserTypeId();

		if (UserTypeID == 1) {
			params.put("cmbRequestor", "526");
		}else if (UserTypeID == 2) {
			params.put("cmbRequestor", "528");
		}else{
			params.put("cmbRequestor", "4");

		}

		params.put("dpCallLogDate",  CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
		params.put("cmbReason","1998");
		params.put("txtRemark", "CANCEL & REFUND");

		logger.info("##### params #####" +params);
		ReturnMessage message = eRequestCancellationService.requestCancelOrder(params, sessionVO);

		if(params.get("auxOrdId") != ""){
	          params.put("salesOrdId",params.get("auxOrdId"));
	          params.put("appTypeId",params.get("auxAppType"));
	          eRequestCancellationService.requestCancelOrder(params, sessionVO);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value="/eRequestRawDataPop.do")
	public String orderCancelRequestRawDataPop(){
		return "sales/order/eRequestRawDataPop";
	}

	@RequestMapping(value="/eReqEditOrdInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> eReqEditOrdInfo(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

	  params.put("stus", 1);
	  params.put("userId", sessionVO.getUserId());

	  logger.debug("params : {} ", params);

	  eRequestCancellationService.insertReqEditOrdInfo(params);

        if(params.get("auxOrdId") != ""){
             params.put("salesOrdId",params.get("auxOrdId"));
             eRequestCancellationService.insertReqEditOrdInfo(params);
        }

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);

        return ResponseEntity.ok(message);
   }

	 @RequestMapping(value="/eRequestApproval.do")
	  public String eRequestApproval(@RequestParam Map<String, Object> params, ModelMap model){
	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	    params.put("userId", sessionVO.getUserId());

	    if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2){
	      EgovMap getUserInfo = salesCommonService.getUserInfo(params);
	      model.put("memType", getUserInfo.get("memType"));
	      model.put("orgCode", getUserInfo.get("orgCode"));
	      model.put("grpCode", getUserInfo.get("grpCode"));
	      model.put("deptCode", getUserInfo.get("deptCode"));
	      model.put("memCode", getUserInfo.get("memCode"));
	    }

	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	    model.put("bfDay", bfDay);
	    model.put("toDay", toDay);

	    return "sales/order/eRequestApproval";
	  }

   @RequestMapping(value="/selectRequestApprovalList.do", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> selectRequestApprovalList(@RequestParam Map<String, Object> params,HttpServletRequest request){

     String[] appTypeId = request.getParameterValues("cmbAppTypeId");
     String[] reqStageId = request.getParameterValues("reqStageId");
     String[] dscBranchId = request.getParameterValues("cmbDscBranchId");
     String[] reqStusId = request.getParameterValues("reqStusId");

     params.put("typeIdList", appTypeId);
     params.put("reqStageList", reqStageId);
     params.put("branchList", dscBranchId);
     params.put("reqStusList", reqStusId);

     List<EgovMap> list = eRequestCancellationService.selectRequestApprovalList(params);

     return ResponseEntity.ok(list);
   }

   @RequestMapping(value="/eRequestApprovalPop.do")
   public String eRequestApprovalPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {
     EgovMap orderDetail = eRequestCancellationService.selectOrderBasicInfo(params, sessionVO);

     EgovMap eRequestDetail = eRequestCancellationService.selectRequestApprovalList(params).get(0);
     EgovMap eRequestAux = null;

     String auxSalesOrdId = (((EgovMap)orderDetail.get("basicInfo")).get("auxSalesOrdId") != null) ? ((EgovMap)orderDetail.get("basicInfo")).get("auxSalesOrdId").toString() : null;

     if(auxSalesOrdId != null){

       Map<String, Object> paramsAux = new HashMap<>();
       String[] reqStusId = {"1"};

       paramsAux.put("salesOrdId", auxSalesOrdId);
       paramsAux.put("reqStusList", reqStusId);
       paramsAux.put("typeId", params.get("typeId"));

       eRequestAux = (eRequestCancellationService.selectRequestApprovalList(paramsAux).size() > 0) ? eRequestCancellationService.selectRequestApprovalList(paramsAux).get(0) : null;
     }

     model.put("orderDetail", orderDetail);
     model.put("eRequestDetail", eRequestDetail);
     model.put("eRequestAux", eRequestAux);

     return "sales/order/eRequestApprovalPop";
   }

   @RequestMapping(value="/saveApprovalCnct.do",method = RequestMethod.POST)
   public ResponseEntity<ReturnMessage> saveApprovalCnct(@RequestBody Map<String, Object>params, SessionVO sessionVO) throws Exception {
     System.out.println(params);
     params.put("updator",sessionVO.getUserId());
     params.put("rem",params.get("modRemCntc"));

     int updOrd = eRequestCancellationService.saveApprCnct(params);

     if(params.get("auxRqstId") != ""){
       params.put("rqstId",params.get("auxRqstId"));
       params.put("salesOrdId",params.get("auxOrdId"));
       eRequestCancellationService.saveApprCnct(params);
     }

     ReturnMessage message = new ReturnMessage();

     if(updOrd > 0)
       message.setCode(AppConstants.SUCCESS);
     else
       message.setCode(AppConstants.FAIL);

     return ResponseEntity.ok(message);
   }

   @RequestMapping(value="/saveApprovalInstAddr.do",method = RequestMethod.POST)
   public ResponseEntity<ReturnMessage> saveApprovalInstAddr(@RequestBody Map<String, Object>params, SessionVO sessionVO) throws Exception {
     params.put("updator",sessionVO.getUserId());
     params.put("rem",params.get("modRemInstAddr"));


     int updOrd = eRequestCancellationService.saveApprInstAddr(params);

     if(params.get("auxRqstId") != ""){
       params.put("rqstId",params.get("auxRqstId"));
       params.put("salesOrdId",params.get("auxOrdId"));
       eRequestCancellationService.saveApprInstAddr(params);
     }

     ReturnMessage message = new ReturnMessage();

     if(updOrd > 0)
       message.setCode(AppConstants.SUCCESS);
     else
       message.setCode(AppConstants.FAIL);

     return ResponseEntity.ok(message);
   }

}
