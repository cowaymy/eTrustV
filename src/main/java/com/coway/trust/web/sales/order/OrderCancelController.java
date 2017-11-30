package com.coway.trust.web.sales.order;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.order.OrderCancelService;
import com.coway.trust.biz.sales.order.OrderCancelVO;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderCancelController {

	private static final Logger logger = LoggerFactory.getLogger(OrderCancelController.class);
	
	@Resource(name = "orderCancelService")
	private OrderCancelService orderCancelService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	
	/**
	 * Order Cancellation List 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/orderCancelList.do")
	public String orderCancelList(@ModelAttribute("orderCancelVO") OrderCancelVO orderCancelVO,
			@RequestParam Map<String, Object>params, ModelMap model){
		
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		
		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		
		List<EgovMap> dscBranchList = orderCancelService.dscBranch(params);
		model.addAttribute("dscBranchList", dscBranchList);
		
		return "sales/order/orderCancelList";
	}
	
	
	/**
	 * Order Cancellation List 데이터조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/orderCancelJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderCancelJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		String[] appTypeId = request.getParameterValues("cmbAppTypeId");
		String[] callStusId = request.getParameterValues("callStusId");
		String[] reqStageId = request.getParameterValues("reqStageId");
		String[] dscBranchId = request.getParameterValues("cmbDscBranchId");
		
		params.put("typeIdList", appTypeId);
		params.put("stusIdList", callStusId);
		params.put("reqStageList", reqStageId);
		params.put("branchList", dscBranchId);
//		String stDate = (String)params.get("startCrtDt");
//		if(stDate != null && stDate != ""){
//			String createStDate = stDate.substring(6) + "-" + stDate.substring(3, 5) + "-" + stDate.substring(0, 2);
//			params.put("startCrtDt", createStDate);
//		}
//		String enDate = (String)params.get("endCrtDt");
//		if(enDate != null && enDate != ""){
//			String createEnDate = enDate.substring(6) + "-" + enDate.substring(3, 5) + "-" + enDate.substring(0, 2);
//			params.put("endCrtDt", createEnDate);
//		}
//		String recallStDate = (String)params.get("startRecallDt");
//		if(recallStDate != null && recallStDate != ""){
//			String createStDate1 = recallStDate.substring(6) + "-" + recallStDate.substring(3, 5) + "-" + recallStDate.substring(0, 2);
//			params.put("startRecallDt", createStDate1);
//		}
//		String recallEnDate = (String)params.get("endRecallDt");
//		if(recallEnDate != null && recallEnDate != ""){
//			String createEnDate1 = recallEnDate.substring(6) + "-" + recallEnDate.substring(3, 5) + "-" + recallEnDate.substring(0, 2);
//			params.put("endRecallDt", createEnDate1);
//		}
		List<EgovMap> orderCancelList = orderCancelService.orderCancellationList(params);
		
		return ResponseEntity.ok(orderCancelList);
	}
	
	
	/**
	 * 화면 호출. - Cancellation Request Information
	 */
	@RequestMapping(value = "/cancelReqInfoPop.do")
	public String cancelReqInfoPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO ) throws Exception {
		
		logger.info("##### salesOrdId #####" +params.get("salesOrdId"));
		// order detail start
		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);
	
		params.put("salesOrderId", params.get("salesOrdId"));
        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		
		model.put("orderDetail", orderDetail);
		model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
		// order detail end
		
		String paramTypeId = (String)params.get("typeId");
		String paramDocId = (String)params.get("docId");
		String paramRefId = (String)params.get("refId");
		logger.info("##### paramRefId #####" +paramRefId);
		logger.info("##### paramRefId #####" +(String)params.get("refId"));
		EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);
		
		model.addAttribute("cancelReqInfo", cancelReqInfo);
		model.addAttribute("paramTypeId", paramTypeId);
		model.addAttribute("paramDocId", paramDocId);
		model.addAttribute("paramRefId", paramRefId);
		model.addAttribute("reqStageId", params.get("paramReqStageId"));
		
		return "sales/order/orderCancelDetailPop";
		
	}
	
	
	/**
	 * Cancellation Log Transaction 데이터조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/cancelLogTransList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> cancelLogTransList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		//params.put("typeId", "296");	//임시 CT Assignment
		//params.put("docId", "101795");	//임시 CT Assignment
		
		List<EgovMap> cancelLogTransList = orderCancelService.cancelLogTransctionList(params);
		
		return ResponseEntity.ok(cancelLogTransList);
	}
	
	
	/**
	 * Product Return Transaction 데이터조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/productReturnTransList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> productReturnTransList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		//params.put("typeId", "296");	//임시 CT Assignment
		//params.put("refId", "8725");	//임시 CT Assignment
		
		List<EgovMap> productReturnTransList = orderCancelService.productReturnTransctionList(params);
		
		return ResponseEntity.ok(productReturnTransList);
	}
	
	
	@RequestMapping(value = "/saveCancel.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveCancel(@RequestParam Map<String, Object> params, ModelMap mode)
			throws Exception {
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		logger.info("##### sessionVO.getUserId() #####" +sessionVO.getUserId());
		logger.info("##### params ###############" +params.toString());
		//String retMsg = AppConstants.MSG_SUCCESS;
		String retMsg = "SUCCESS";
		
		Map<String, Object> map = new HashMap();

			orderCancelService.saveCancel(params);

			map.put("msg", retMsg);

		return ResponseEntity.ok(map);
	}
	
	
	/**
	 * 화면 호출. - Assignment CT Information
	 */
	@RequestMapping(value = "/ctAssignmentInfoPop.do")
	public String ctAssignmentInfoPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		String paramTypeId = (String)params.get("typeId");
		String paramDocId = (String)params.get("docId");
		String paramRefId = (String)params.get("refId");
		
		List<EgovMap> selectAssignCTList = orderCancelService.selectAssignCT(params);
		
		EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);
		EgovMap ctAssignmentInfo = orderCancelService.ctAssignmentInfo(params);
		
		model.addAttribute("cancelReqInfo", cancelReqInfo);
		model.addAttribute("paramTypeId", paramTypeId);
		model.addAttribute("paramDocId", paramDocId);
		model.addAttribute("paramRefId", paramRefId);
		model.addAttribute("selectAssignCTList", selectAssignCTList);
		model.addAttribute("ctAssignmentInfo", ctAssignmentInfo);
		
		return "sales/order/orderCancelCTAssignmentPop";
		
	}
	
	
	/**
	 * 화면 호출. - New Cancellation Log Result
	 */
	@RequestMapping(value = "/cancelNewLogResultPop.do")
	public String cancelNewLogResultPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		// order detail start
		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);
	
		params.put("salesOrderId", params.get("salesOrdId"));
        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		
		model.put("orderDetail", orderDetail);
		model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
		// order detail end
				
		String paramTypeId = (String)params.get("typeId");
		String paramDocId = (String)params.get("docId");
		String paramRefId = (String)params.get("refId");
		
		EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);
		List<EgovMap> selectAssignCTList = orderCancelService.selectAssignCT(params);
		List<EgovMap> selectFeedback = orderCancelService.selectFeedback(params);
		
		model.addAttribute("cancelReqInfo", cancelReqInfo);
		model.addAttribute("paramTypeId", paramTypeId);
		model.addAttribute("paramDocId", paramDocId);
		model.addAttribute("paramRefId", paramRefId);
		model.addAttribute("selectAssignCTList", selectAssignCTList);
		model.addAttribute("selectFeedback", selectFeedback);
		model.addAttribute("reqStageId", params.get("paramReqStageId"));
		
		logger.info("##### selectAssignCTList #####" +selectAssignCTList.get(0));
		logger.info("##### selectAssignCTList #####" +selectAssignCTList.get(1));
		
		return "sales/order/orderCancelDetailAddPop";
		
	}
	
	
	@RequestMapping(value = "/saveCtAssignment.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveCtAssignment(@RequestParam Map<String, Object> params, ModelMap mode)
			throws Exception {
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		logger.info("##### sessionVO.getUserId() #####" +sessionVO.getUserId());
		logger.info("##### params ###############" +params.toString());
		//String retMsg = AppConstants.MSG_SUCCESS;
		String retMsg = "SUCCESS";
		
		Map<String, Object> map = new HashMap();

			orderCancelService.saveCtAssignment(params);

			map.put("msg", retMsg);

		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/ctSearchPop.do")
	public String memberPop(@RequestParam Map<String, Object> params, ModelMap model) {

		return "sales/order/orderCancelCTSearchPop";
	}
	
	@RequestMapping(value="/orderCancelRequestRawDataPop.do")
	public String orderCancelRequestRawDataPop(){
		
		return "sales/order/orderCancelRequestRawDataPop";
	}
	
}
