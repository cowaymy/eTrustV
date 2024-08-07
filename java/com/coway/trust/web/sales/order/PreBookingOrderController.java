/**
 *
 */
package com.coway.trust.web.sales.order;

import java.io.File;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.common.WhatappsApiService;
import com.coway.trust.biz.homecare.sales.order.HcPreBookingOrderService;
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.PreOrderApplication;
import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.PreBookingOrderService;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderListVO;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/sales/order/preBooking")
public class PreBookingOrderController {

	private static Logger logger = LoggerFactory.getLogger(PreBookingOrderController.class);

	@Value("${watapps.api.country.code}")
  private String waApiCountryCode;

	 @Value("${watapps.api.button.webUrl.domains}")
   private String waApiBtnUrlDomains;

	 @Value("${watapps.api.button.template}")
	 private String waApiBtnTemplate;

	@Resource(name = "preBookingOrderService")
	private PreBookingOrderService preBookingOrderService;

	@Resource(name = "hcPreBookingOrderService")
  private HcPreBookingOrderService hcPreBookingOrderService;

	@Autowired
	private PreOrderApplication preOrderApplication;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "preOrderService")
  private PreOrderService preOrderService;

  @Resource(name = "orderDetailService")
  private OrderDetailService orderDetailService;

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

  @Autowired
  private WhatappsApiService whatappsApiService;


	@RequestMapping(value = "/preBookingWA.do", method = RequestMethod.GET)
  public String preBookingWA(@RequestParam Map<String, Object> params, ModelMap model) {

  logger.debug("==================== preBookingWA.do ====================");

  Precondition.checkNotNull(params.get("nric"), messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "nric" }));
  Precondition.checkNotNull(params.get("prebookno"), messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "prebookno" }));
  Precondition.checkNotNull(params.get("salesOrdNoOld"), messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "salesOrdNoOld" }));
  Precondition.checkNotNull(params.get("telno"), messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "telno" }));
  Precondition.checkNotNull(params.get("isHomeCare"), messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "isHomeCare" }));

  String nric = ((String) params.get("nric"));
  String prebookno = ((String) params.get("prebookno"));
  String salesOrdNoOld = ((String) params.get("salesOrdNoOld"));
  String telno = ((String) params.get("telno"));
  String isHomeCare = ((String) params.get("isHomeCare"));

  EgovMap preBookOrderInfo = null;

  if(isHomeCare.equals("false")){
       preBookOrderInfo = preBookingOrderService.selectPreBookOrdDtlWA(params);
  }else{
       preBookOrderInfo = hcPreBookingOrderService.selectPreBookOrdDtlWA(params);
  }

  Map<String, Object> preBookOrdInfoList = new HashMap<String, Object>();
  String status = AppConstants.FAIL;

  if(preBookOrderInfo != null){
      if(Integer.parseInt(preBookOrderInfo.get("preBookPeriod").toString()) <= 3 && preBookOrderInfo.get("custVerifyStus").toString().equals("ACT")){
          preBookOrdInfoList.put("preBookId", preBookOrderInfo.get("preBookId").toString());
          preBookOrdInfoList.put("prebookno", preBookOrderInfo.get("preBookNo").toString());
          preBookOrdInfoList.put("custVerifyStus", "Y");
          preBookOrdInfoList.put("updUserId", "349");

          status = preBookingOrderService.updatePreBookOrderCustVerifyStus(preBookOrdInfoList);
       } else if(Integer.parseInt(preBookOrderInfo.get("preBookPeriod").toString()) <= 3 && preBookOrderInfo.get("custVerifyStus").toString().equals("Y")){
             status = AppConstants.SUCCESS;
       }
  }
  logger.info("[PreBookingOrderController - preBookingWA] STATUS :: " + status);
  model.addAttribute("status", status);

  return "/sales/order/preBookingWARespond";
}

	@RequestMapping(value = "/preBookingOrderList.do")
	public String preBookingOrderList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		if(sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
		  params.put("userId", sessionVO.getUserId());

			EgovMap result =  salesCommonService.getUserInfo(params);
			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
		}

		int userTypeId = 14;

    if (sessionVO.getUserTypeId() == 1) { // HP
      userTypeId = 29;
    } else if (sessionVO.getUserTypeId() == 2) { // CODY
      userTypeId = 28;
    }

		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	   // BranchCodeList
    params.clear();
    params.put("groupCode", 1);
    List<EgovMap> branchCdList = commonService.selectBranchList(params);

		model.put("toDay", toDay);
		model.put("isAdmin", "true");

		EgovMap branchTypeRes = salesCommonService.getUserBranchType(params);
		if (branchTypeRes != null) {
			model.put("branchType", branchTypeRes.get("codeId"));
		}

		model.addAttribute("userRoleId", sessionVO.getRoleId());
	  model.put("branchCdList", branchCdList);


		return "sales/order/preBookingOrderList";
	}

	@RequestMapping(value = "/preBookingOrderRegisterPop.do")
  public String preBookingOrderRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) throws ParseException {
          String dayFrom = "", dayTo = "";

	        model.put("codeList_325", commonService.selectCodeList("325"));
	        model.put("branchCdList_1", commonService.selectBranchList("1", "-"));
	        model.put("branchCdList_5", commonService.selectBranchList("5", "-"));

	        EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

          if(checkExtradeSchedule!=null){
            dayFrom = checkExtradeSchedule.get("startDate").toString();
            dayTo = checkExtradeSchedule.get("endDate").toString();
          }
          else{
            dayFrom = "20"; // default 20-{month-1}
       	  dayTo = "31"; // default LAST DAY OF THE MONTH
          }

         String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
         String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

         model.put("hsBlockDtFrom", dayFrom);
         model.put("hsBlockDtTo", dayTo);
         model.put("bfDay", bfDay);
         model.put("toDay", toDay);

         return "sales/order/preBookingOrderRegisterPop";
  }

	 @RequestMapping(value = "/preBookPrevOrderNoPop.do")
	  public String preBookPrevOrderNoPop(@RequestParam Map<String, Object> params, ModelMap model) {
	    model.put("custId", params.get("custId"));
	    return "sales/order/preBookingPrevOrderNoPop";
	 }

	 @RequestMapping(value = "/preBookOrderDetailPop.do")
	  public String preBookOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

	   // Search Pre Book Order Info
	    EgovMap preBookOrderInfo = preBookingOrderService.selectPreBookingOrderInfo(params);

	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,SalesConstants.DEFAULT_DATE_FORMAT1);
	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	    model.put("bfDay", bfDay);
	    model.put("toDay", toDay);
	    model.put("preBookOrderInfo", preBookOrderInfo);


	    return "sales/order/preBookingOrderDetailPop";
	  }


	@RequestMapping(value="/selectPreBookingOrderList.do")
	public ResponseEntity<List<EgovMap>>  selectPreBookingOrderList(@RequestParam Map<String,Object> params, HttpServletRequest request, ModelMap map)
	{
      	  String[] arrAppType = request.getParameterValues("_appTypeId"); // Application Type
          String[] arrPreOrdStusId = request.getParameterValues("_stusId"); // Pre-Book Order Status
          String[] arrDiscWaive = request.getParameterValues("discountWaive"); // Pre-Booking period

          if (arrAppType != null && !CommonUtils.containsEmpty(arrAppType))
            params.put("arrAppType", arrAppType);
          if (arrPreOrdStusId != null && !CommonUtils.containsEmpty(arrPreOrdStusId))
            params.put("arrPreOrdStusId", arrPreOrdStusId);
          if (arrDiscWaive != null && !CommonUtils.containsEmpty(arrDiscWaive))
            params.put("arrDiscWaive", arrDiscWaive);

      	  List<EgovMap> result = preBookingOrderService.selectPreBookingOrderList(params);

      	  return ResponseEntity.ok(result);
	}

  @RequestMapping(value="/selectPreBookOrderVerifyStus.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectPreBookOrderVerifyStus(@RequestParam Map<String, Object>params, ModelMap model) throws Exception{
    EgovMap result = preBookingOrderService.selectPreBookOrderEligibleInfo(params);

    return ResponseEntity.ok(result);
  }

	 @RequestMapping(value = "/registerPreBooking.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> registerPreBooking(@RequestBody PreBookingOrderVO preBookingOrderVO, Model model, SessionVO sessionVO)
	      throws Exception {
	    ReturnMessage message = new ReturnMessage();
	    String msg = "";

	    preBookingOrderService.insertPreBooking(preBookingOrderVO, sessionVO);
	    String preBookingOrderNo = preBookingOrderVO.getPreBookOrdNo();

	    //call the whatapps API - send message
	    Map<String, Object> preBookList = new HashMap();
	    preBookList.put("salesOrderId", preBookingOrderVO.getSalesOrdIdOld());

	    EgovMap ordDtl = orderDetailService.selectOrderBasicInfo(preBookList, sessionVO);
	    EgovMap basicInfo = (EgovMap)ordDtl.get("basicInfo");
	    EgovMap mailingInfo = (EgovMap)ordDtl.get("mailingInfo");

	    if(mailingInfo.get("mailCntTelM") == null){
    	      msg +="Pre Booking Order Register Failed - Mailing Info - Mobile No is empty.";
    	      message.setCode(AppConstants.FAIL);
    	      message.setMessage(msg);
	    }else{
	         String telno = waApiCountryCode + mailingInfo.get("mailCntTelM");

		        //message
      	    Map<String, Object> msgMap = new HashMap();
      	    msgMap.put("type", "wa_template");

      	    //template
      	    Map<String, Object> templateMap = new HashMap();
      	    templateMap.put("template_name", "prebook_prd_04012024_2");
      	    templateMap.put("language", "en");
      	    msgMap.put("template", templateMap);

      	    //data
      	    Map<String, Object> dataMap = new HashMap();

      	    //body_params
      	    String[] bodyParams = new String[5];
      	    bodyParams[0] = preBookingOrderNo;
      	    bodyParams[1] = preBookingOrderVO.getSalesOrdNoOld();
      	    bodyParams[2] = preBookingOrderVO.getPostCode();
      	    bodyParams[3] = preBookingOrderVO.getMemCode();
      	    bodyParams[4] = "3";
      	    dataMap.put("body_params", bodyParams);

      	    //buttons
      	    Map<String, Object> buttonsMap = new HashMap();
      	    String payload = "?nric="+ CommonUtils.nvl(basicInfo.get("custNric")) + "&prebookno=" + preBookingOrderNo + "&salesOrdNoOld=" + preBookingOrderVO.getSalesOrdNoOld()
      	                            + "&telno=" + telno + "&isHomeCare=false";
      	    String type = waApiBtnUrlDomains + "sales/order/preBooking/preBookingWA.do?{{1}}";

      	    buttonsMap.put("type", type);
      	    buttonsMap.put("payload", payload);

      	    List<Map<String, Object>> btnList = new ArrayList<>();
            btnList.add(buttonsMap);
      	    dataMap.put("buttons", btnList);

      	    msgMap.put("data", dataMap);

      	    //body
            Map<String, Object> bodyMap = new HashMap();
      	    bodyMap.put("platform", "whatsapp");
      	    bodyMap.put("user_id", telno);
      	    bodyMap.put("message", msgMap);

      	    whatappsApiService.preBookWhatappsReqApi(bodyMap);

      	    msg += "Pre-Booking No : " + preBookingOrderNo+ "<br />";
      	    message.setCode(AppConstants.SUCCESS);
      	    message.setMessage(msg);
	    }

	    return ResponseEntity.ok(message);
	  }

	 @RequestMapping(value = "/selectPrevOrderNoList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectPrevOrderNoList(@RequestParam Map<String, Object> params) {
     List<EgovMap> result = preBookingOrderService.selectPrevOrderNoList(params);

	    return ResponseEntity.ok(result);
	  }

	 @RequestMapping(value = "/checkOldOrderId.do", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> selectOldOrderId(@RequestParam Map<String, Object> params, ModelMap model)
	      throws Exception {
	    EgovMap RESULT;
	    RESULT = preBookingOrderService.checkOldOrderId(params);

	    return ResponseEntity.ok(RESULT);
	  }

	 @RequestMapping(value = "/preBookOrderReqCancelPop.do")
	  public String preBookOrderReqCancelPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

	    // Search Pre Book Order Info
	    EgovMap preBookOrderInfo = preBookingOrderService.selectPreBookingOrderInfo(params);

	    String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	    model.put("bfDay", bfDay);
	    model.put("toDay", toDay);
	    model.put("preBookOrderInfo", preBookOrderInfo);

	    return "sales/order/preBookingOrderReqCancelPop";
	  }

	 @RequestMapping(value = "/requestCancelPreBookOrder.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> updatePreBookOrderCancel(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
	    preBookingOrderService.updatePreBookOrderCancel(params, sessionVO);

	    String msg = "Pre-Booking Cancel successfully.<br />";

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(msg);

	    return ResponseEntity.ok(message);
	  }

	 @RequestMapping(value = "/selectPreBookOrderCancelStatus.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectPreBookOrderCancelStatus( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
	    List<EgovMap> result = preBookingOrderService.selectPreBookOrderCancelStatus(params) ;
	    return ResponseEntity.ok(result);
	  }

	  @RequestMapping(value = "/checkPreBookSalesPerson.do", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> checkPreBookSalesPerson(@RequestParam Map<String, Object> params) {
	    EgovMap result = preBookingOrderService.checkPreBookSalesPerson(params);

	    return ResponseEntity.ok(result);
	  }

	  @RequestMapping(value = "/checkPreBookConfigurationPerson.do", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> checkPreBookConfigurationPerson(@RequestParam Map<String, Object> params) {
	    EgovMap result = preBookingOrderService.checkPreBookConfigurationPerson(params);

	    return ResponseEntity.ok(result);
	  }

	  @RequestMapping(value = "/selectPreBookOrderEligibleCheck.do", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> selectPreBookOrderEligibleCheck(@RequestParam Map<String, Object> params) {

	    EgovMap result = preBookingOrderService.selectPreBookOrderEligibleCheck(params);

	    return ResponseEntity.ok(result);
	  }

}
