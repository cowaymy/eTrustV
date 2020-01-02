package com.coway.trust.web.homecare.sales.order;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.HomecareCmService;
import com.coway.trust.biz.homecare.sales.order.HcOrderCancelService;
import com.coway.trust.biz.homecare.sales.order.HcOrderListService;
import com.coway.trust.biz.sales.order.OrderCancelService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcOrderCancelController.java
 * @Description : Homecare Cancel Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 28.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/sales/order")
public class HcOrderCancelController {

	@Resource(name = "orderCancelService")
	private OrderCancelService orderCancelService;

	@Resource(name = "hcOrderCancelService")
	private HcOrderCancelService hcOrderCancelService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	@Resource(name = "hcOrderListService")
	private HcOrderListService hcOrderListService;

	@Resource(name = "homecareCmService")
	private HomecareCmService homecareCmService;

	/**
	 * Homecare Order Cancellation List 초기화 화면
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcOrderCancelList.do")
	public String HcOrderCancelList(@RequestParam Map<String, Object>params, ModelMap model){
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		List<EgovMap> dscBranchList = orderCancelService.dscBranch(params);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		model.addAttribute("dscBranchList", dscBranchList);

		return "homecare/sales/order/hcOrderCancelList";
	}


	/**
	 * Homecare Order Cancellation List 데이터조회
	 * @Author KR-SH
	 * @Date 2019. 10. 28.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcOrderCancellationList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> hcOrderCancellationList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] appTypeId = request.getParameterValues("cmbAppTypeId");
		String[] callStusId = request.getParameterValues("callStusId");
		String[] reqStageId = request.getParameterValues("reqStageId");
		String[] dscBranchId = request.getParameterValues("cmbDscBranchId");

		params.put("typeIdList", appTypeId);
		params.put("stusIdList", callStusId);
		params.put("reqStageList", reqStageId);
		params.put("branchList", dscBranchId);

		List<EgovMap> orderCancelList = hcOrderCancelService.hcOrderCancellationList(params);

		return ResponseEntity.ok(orderCancelList);
	}

	/**
	 * 화면 호출. - New Cancellation Log Result
	 * @Author KR-SH
	 * @Date 2019. 10. 29.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcCancelNewLogResultPop.do")
	public String hcCancelNewLogResultPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {
        // order detail
		params.put("prgrsId", 0);
		params.put("salesOrderId", CommonUtils.nvl(params.get("salesOrdId")));
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);

		EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);

		List<EgovMap> selectFeedback = orderCancelService.selectFeedback(params);
		// homecare 주문 조회
		params.put("ordNo", CommonUtils.nvl(params.get("paramSalesOrdNo")));
		EgovMap hcOrder = hcOrderListService.selectHcOrderInfo(params);

		model.put("orderDetail", orderDetail);
		model.put("hcOrder", hcOrder);
		model.addAttribute("salesOrderNo", CommonUtils.nvl(params.get("salesOrderNo")));
		model.addAttribute("cancelReqInfo", cancelReqInfo);
		model.addAttribute("paramTypeId", CommonUtils.nvl(params.get("typeId")));
		model.addAttribute("paramDocId", CommonUtils.nvl(params.get("docId")));
		model.addAttribute("paramRefId", CommonUtils.nvl(params.get("refId")));
		model.addAttribute("selectFeedback", selectFeedback);
		model.addAttribute("reqStageId", params.get("paramReqStageId"));
	    model.addAttribute("rcdTms", params.get("rcdTms"));
	    model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);

		return "homecare/sales/order/hcCancelNewLogResultPop";

	}

	/**
	 * Homecare Order 취소
	 * @Author KR-SH
	 * @Date 2019. 10. 30.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/hcSaveCancel.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveCancel(@RequestParam Map<String, Object> params, SessionVO sessionVO) throws Exception {
		Map<String, Object> rtnMap = hcOrderCancelService.hcSaveCancel(params, sessionVO);

		return ResponseEntity.ok(rtnMap);
	}

}
