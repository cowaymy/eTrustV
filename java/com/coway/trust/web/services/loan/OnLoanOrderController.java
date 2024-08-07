package com.coway.trust.web.services.loan;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.services.onLoan.OnLoanService;
import com.coway.trust.biz.services.onLoan.vo.LoanOrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * IHR- On Loan Product Controller
 * @author HQIT-HUIDING
 * @date 2020-01-31
 */

@Controller
@RequestMapping(value = "/services/onLoanOrder")
public class OnLoanOrderController {
	private static final Logger logger = LoggerFactory.getLogger(OnLoanOrderController.class);

	@Resource(name = "onLoanOrderService")
	private OnLoanService onLoanOrderService;

	@RequestMapping(value = "/onLoanOrderList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "services/onLoan/onLoanOrderList";
	}

	@RequestMapping(value = "/selectOnLoanJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOnLoanJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] arrOrdStusId = request.getParameterValues("ordStusId"); //Order Status
		String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId"); //Key-In Branch
		String[] arrDscBrnchId = request.getParameterValues("dscBrnchId"); //DSC Branch

		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
    	if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");

    	params.put("loanOrdStartDt", CommonUtils.changeFormat(String.valueOf(params.get("loanOrdStartDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));
    	params.put("loanOrdEndDt", CommonUtils.changeFormat(String.valueOf(params.get("loanOrdEndDt")), SalesConstants.DEFAULT_DATE_FORMAT1, SalesConstants.DEFAULT_DATE_FORMAT2));

		if(arrOrdStusId    != null && !CommonUtils.containsEmpty(arrOrdStusId))    params.put("arrOrdStusId", arrOrdStusId);
		if(arrKeyinBrnchId != null && !CommonUtils.containsEmpty(arrKeyinBrnchId)) params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		if(arrDscBrnchId   != null && !CommonUtils.containsEmpty(arrDscBrnchId))   params.put("arrDscBrnchId", arrDscBrnchId);

		if(params.get("custIc") == null) {logger.info("!@###### custIc is null");}
		if("".equals(params.get("custIc"))) {logger.info("!@###### custIc ''");}

		logger.info("!@##############################################################################");
		logger.info("!@###### ordNo : "+params.get("ordNo"));
		logger.info("!@###### loanOrdStartDt : "+params.get("loanOrdStartDt"));
		logger.info("!@###### loanOrdEndDt : "+params.get("loanOrdEndDt"));
		logger.info("!@###### ordDt : "+params.get("ordDt"));
		logger.info("!@###### custIc : "+params.get("custIc"));
		logger.info("!@##############################################################################");

		List<EgovMap> onLoanOrdList = onLoanOrderService.selectLoanOrdList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(onLoanOrdList);
	}

	@RequestMapping(value = "/onLoanOrderRegPop.do")
	  public String onLoanOrderRegPop(@RequestParam Map<String, Object> params, ModelMap model) {

	    logger.debug(CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
	    String nextDay = CommonUtils.changeFormat(CommonUtils.getCalDate(1), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);

	    model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));
	    model.put("nextDay", nextDay);

	    return "services/onLoan/onLoanOrderRegPop";
	  }

	@RequestMapping(value = "/cnfmLoanOrdDetailPop.do")
	  public String cnfmLoanOrdDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {
	    return "services/onLoan/cnfmLoanOrdDetailPop";
	  }

	@RequestMapping(value = "/registerOnLoanOrder.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> registerOnLoanOrder(@RequestBody LoanOrderVO loanOrderVO, HttpServletRequest request,
	      Model model, SessionVO sessionVO) throws Exception {

		logger.info("######relateOrdNo: " + loanOrderVO.getLoanOrderMVO().getRelateOrdNo());

		onLoanOrderService.registerOnLoanOrder(loanOrderVO, sessionVO);

		logger.info("###loanOrderVO : {}" + loanOrderVO.getLoanOrderMVO());


		String appTypeName = SalesConstants.APP_TYPE_CODE_IHR_LOAN_FULL;
		String msg = "Order successfully saved.<br />" +
							"Loan Order Number : " + loanOrderVO.getLoanOrderMVO().getLoanOrdNo() + "<br />";

		if (loanOrderVO.getLoanOrderDVO().getItmCompId() == 2 || loanOrderVO.getLoanOrderDVO().getItmCompId() == 3
		        || loanOrderVO.getLoanOrderDVO().getItmCompId() == 4) {
		      msg += "AS Number : " + loanOrderVO.getASEntryVO().getAsNo() + "<br />";
		    }

		ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(msg);

	    return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/onLoanOrdDtlPop.do")
	  public String getOrderDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

	    // params.put("salesOrderId", 256488);

	    int prgrsId = 0;

	    params.put("prgrsId", prgrsId);

	    logger.debug("!@##############################################################################");
	    logger.debug("!@###### salesOrderId : " + params.get("salesOrderId") + "  |  loanOrdId: " + params.get("loanOrdId"));
	    logger.debug("!@##############################################################################");

	    // [Tap]Basic Info
	    EgovMap orderDetail = onLoanOrderService.selectLoanOrdBasicInfo(params, sessionVO);//

	    model.put("orderDetail", orderDetail);

	    return "services/onLoan/onLoanOrderDtlPop";
	  }


	@RequestMapping(value = "/cancelReqPop.do")
	  public String orderRequestPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO)
	      throws Exception {

	    String callCenterYn = "N";

	    if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
	      callCenterYn = "Y";
	    }

	    EgovMap orderDetail = onLoanOrderService.selectLoanOrdBasicInfo(params, sessionVO);// APP_TYPE_ID
	                                                                                     // CUST_ID

	    model.put("orderDetail", orderDetail);
	    model.put("ordReqType", params.get("ordReqType"));
	    model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

	    String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

	    model.put("toDay", toDay);
	    model.put("callCenterYn", callCenterYn);

	    return "services/onLoan/onLoanCancelReqPop";
	  }


//	@RequestMapping(value = "/requestCancelLoanOrd.do", method = RequestMethod.POST)
//	  public ResponseEntity<ReturnMessage> requestCancelOrder(@RequestBody Map<String, Object> params, ModelMap model,
//	      SessionVO sessionVO) throws Exception {
//
//	    ReturnMessage message = orderRequestService.requestCancelOrder(params, sessionVO);
//
//	    return ResponseEntity.ok(message);
//	  }

}
