package com.coway.trust.web.homecare.sales.order;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.homecare.sales.order.HcOrderRequestService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderRequestController.java
 * @Description : Homecare Order Request
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 24.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderRequestController {

	@Resource(name = "hcOrderRequestService")
	private HcOrderRequestService hcOrderRequestService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;


	/**
	 * Order Request Popup
	 *
	 * @Author KR-SH
	 * @Date 2019. 10. 24.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcOrderRequestPop.do")
	public String hcOrderRequestPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		String callCenterYn = "N";

		if (CommonUtils.isNotEmpty(params.get(AppConstants.CALLCENTER_TOKEN_KEY))) {
			callCenterYn = "Y";
		}
		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);

        params.put("salesOrderId", CommonUtils.nvl(hcOrder.get("srvOrdId")));
        params.put("ordNo", CommonUtils.nvl(hcOrder.get("matOrdNo")));
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);		// Mattress Order
		hcOrder = hcOrderListService.selectHcOrderInfo(params);

		EgovMap orderDetail2 = null;
		// has frame order
		if(hcOrder != null) {
			int anoOrdId = CommonUtils.intNvl(hcOrder.get("anoOrdId"));

			if(anoOrdId > 0) {
				Map<String, Object> fraParams = new HashMap<String, Object>();
				fraParams.put("salesOrderId", CommonUtils.nvl(anoOrdId));
				fraParams.put("ordNo", CommonUtils.nvl(hcOrder.get("fraOrdNo")));
				orderDetail2 = orderDetailService.selectBasicInfo(fraParams);		// Mattress Order
			}
		}

		model.put("orderDetail", orderDetail);
		model.put("orderDetail2", orderDetail2);
		model.put("hcOrder", hcOrder);
		model.put("ordReqType", params.get("ordReqType"));
		model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("toDay", toDay);
		model.put("callCenterYn", callCenterYn);
		model.put("userId", sessionVO.getUserId());

		return "homecare/sales/order/hcOrderRequestPop";
	}


	/**
	 * Request Cancel Order
	 * @Author KR-SH
	 * @Date 2019. 10. 24.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcRequestCancelOrder.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcRequestCancelOrder(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage message = hcOrderRequestService.hcRequestCancelOrder(params, sessionVO);
		return ResponseEntity.ok(message);
	}

	/**
	 * Request Check Validation
	 * @Author KR-SH
	 * @Date 2019. 12. 4.
	 * @param params
	 * @return
	 * @throws Exception
	 */
    @RequestMapping(value = "/validOCRStus.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> validOCRStus(@RequestParam Map<String, Object> params) throws Exception {
    	ReturnMessage message = hcOrderRequestService.validOCRStus(params);

    	return ResponseEntity.ok(message);
    }

  	/**
  	 * Homecare Order Request - Transfer Ownership
  	 * @Author KR-SH
  	 * @Date 2020. 1. 13.
  	 * @param params
  	 * @return
  	 * @throws Exception
  	 */
	@RequestMapping(value = "/hcReqOwnershipTransfer.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcReqOwnershipTransfer(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage rtnMsg = hcOrderRequestService.hcReqOwnershipTransfer(params, sessionVO);

		return ResponseEntity.ok(rtnMsg);
    }

	/**
	 * Homecare Order Request - Product Exchange
	 * @Author KR-SH
	 * @Date 2020. 1. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcRequestProdExch.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> hcRequestProdExch(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage rtnMsg = hcOrderRequestService.hcRequestProdExch(params, sessionVO);

		return ResponseEntity.ok(rtnMsg);
    }

}
