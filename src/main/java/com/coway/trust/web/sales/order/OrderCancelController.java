package com.coway.trust.web.sales.order;

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

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderCancelController {

	private static final Logger logger = LoggerFactory.getLogger(OrderCancelController.class);
	
	@Resource(name = "orderCancelService")
	private OrderCancelService orderCancelService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	
	/**
	 * Order Cancellation List 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/orderCancelList.do")
	public String orderCancelList(@ModelAttribute("orderCancelVO") OrderCancelVO orderCancelVO,
			@RequestParam Map<String, Object>params, ModelMap model){
		
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
		
		List<EgovMap> orderCancelList = orderCancelService.orderCancellationList(params);
		
		return ResponseEntity.ok(orderCancelList);
	}
	
	
	/**
	 * 화면 호출. - Cancellation Request Information
	 */
	@RequestMapping(value = "/cancelReqInfoPop.do")
	public String cancelReqInfoPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);
		
		model.addAttribute("cancelReqInfo", cancelReqInfo);
		
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
		
		params.put("typeId", "296");	//임시 CT Assignment
		params.put("docId", "101795");	//임시 CT Assignment
		
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
		
		params.put("typeId", "296");	//임시 CT Assignment
		params.put("refId", "8725");	//임시 CT Assignment
		
		List<EgovMap> productReturnTransList = orderCancelService.productReturnTransctionList(params);
		
		return ResponseEntity.ok(productReturnTransList);
	}
	
	
	/**
	 * 화면 호출. - Assignment CT Information
	 */
	@RequestMapping(value = "/ctAssignmentInfoPop.do")
	public String ctAssignmentInfoPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		params.put("typeId", "296");	//임시 CT Assignment
		params.put("refId", "8725");	//임시 CT Assignment
		
		List<EgovMap> selectAssignCTList = orderCancelService.selectAssignCT(params);
		
		EgovMap cancelReqInfo = orderCancelService.cancelReqInfo(params);
		EgovMap ctAssignmentInfo = orderCancelService.ctAssignmentInfo(params);
		
		model.addAttribute("cancelReqInfo", cancelReqInfo);
		model.addAttribute("selectAssignCTList", selectAssignCTList);
		model.addAttribute("ctAssignmentInfo", ctAssignmentInfo);
		
		return "sales/order/orderCancelCTAssignmentPop";
		
	}
}
