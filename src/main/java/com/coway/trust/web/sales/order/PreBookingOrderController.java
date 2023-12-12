/**
 *
 */
package com.coway.trust.web.sales.order;

import java.io.File;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.ArrayList;
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
import com.coway.trust.biz.sales.common.SalesCommonService;
import com.coway.trust.biz.sales.order.PreOrderApplication;
import com.coway.trust.biz.sales.order.PreOrderService;
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
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/sales/order/preBooking")
public class PreBookingOrderController {

	private static Logger logger = LoggerFactory.getLogger(PreBookingOrderController.class);

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Resource(name = "preBookingOrderService")
	private PreBookingOrderService preBookingOrderService;

	@Autowired
	private PreOrderApplication preOrderApplication;

	@Resource(name = "salesCommonService")
	private SalesCommonService salesCommonService;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "preOrderService")
  private PreOrderService preOrderService;

	@Autowired
	private AdaptorService adaptorService;

	@RequestMapping(value = "/preBookingOrderList.do")
	public String preBookingOrderList(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 7){
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

		model.put("toDay", toDay);
		model.put("isAdmin", "true");

		EgovMap branchTypeRes = salesCommonService.getUserBranchType(params);
		if (branchTypeRes != null) {
			model.put("branchType", branchTypeRes.get("codeId"));
		}

		model.addAttribute("userRoleId", sessionVO.getRoleId());

		return "sales/order/preBookingOrderList";
	}

	@RequestMapping(value = "/preBookingOrderRegisterPop.do")
  public String preBookingOrderRegisterPop(@RequestParam Map<String, Object> params, ModelMap model) throws ParseException {
          String dayFrom = "", dayTo = "";

	        model.put("codeList_325", commonService.selectCodeList("325"));

	        EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

          if(checkExtradeSchedule!=null){
            dayFrom = checkExtradeSchedule.get("startDate").toString();
            dayTo = checkExtradeSchedule.get("endDate").toString();
          }
          else{
            dayFrom = "20"; // default 20-{month-1}
            dayTo = "02"; // default 2-{month}
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
	        logger.info("***[PreBookingOrderController] - selectPreBookingOrderList START!!! ***");
	        logger.info("[PreBookingOrderController] - selectPreBookingOrderList > params1 :: {} " + params);

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
          logger.info("[PreBookingOrderController] - selectPreBookingOrderList > result :: {} " + result);

          logger.info("***[PreBookingOrderController] - selectPreBookingOrderList END***");
      	  return ResponseEntity.ok(result);
	}

  @RequestMapping(value="/selectPreBookOrderVerifyStus.do", method = RequestMethod.GET)
  public ResponseEntity<EgovMap> selectPreBookOrderVerifyStus(@RequestParam Map<String, Object>params, ModelMap model) throws Exception{
    logger.info("***[PreBookingOrderController] - selectPreBookOrderVerifyStus START!!! ***");
    EgovMap result = preBookingOrderService.selectPreBookOrderVerifyStus(params);

    logger.info("***[PreBookingOrderController] - selectPreBookOrderVerifyStus END!!! ***");
    return ResponseEntity.ok(result);
  }

	 @RequestMapping(value = "/registerPreBooking.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> registerPreBooking(@RequestBody PreBookingOrderVO preBookingOrderVO, HttpServletRequest request, Model model, SessionVO sessionVO)
	      throws Exception {
	    logger.info("[PreBookingOrderController - registerPreBooking] START!!");
      logger.info("[PreBookingOrderController - registerPreBooking] preBookingOrderVO :: {} " + preBookingOrderVO);

	    preBookingOrderService.insertPreBooking(preBookingOrderVO, sessionVO);
	    String preBookingOrderNo = preBookingOrderVO.getPreBookOrdNo();

	    String msg = "";
	    msg += "Pre-Booking No : " + preBookingOrderNo+ "<br />";

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(msg);

	    logger.info("[PreBookingOrderController - registerPreBooking] END !!");
	    return ResponseEntity.ok(message);
	  }

	 @RequestMapping(value = "/selectPrevOrderNoList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectPrevOrderNoList(@RequestParam Map<String, Object> params) {
     logger.info("[PreBookingOrderController - selectPrevOrderNoList] START!!");
     logger.info("[PreBookingOrderController] - selectPrevOrderNoList > params :: {} " + params);

     List<EgovMap> result = preBookingOrderService.selectPrevOrderNoList(params);
	   logger.info("[PreBookingOrderController] - selectPrevOrderNoList > result :: {} " + result);

	    logger.info("[PreBookingOrderController - selectPrevOrderNoList] END!!");
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
}
