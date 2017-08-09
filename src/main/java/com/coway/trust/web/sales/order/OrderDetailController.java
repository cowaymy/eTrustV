/**
 * 
 */
package com.coway.trust.web.sales.order;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderDetailController {

	private static Logger logger = LoggerFactory.getLogger(OrderDetailController.class);
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@RequestMapping(value = "/orderDetail.do")
	public String getOrderDetailPop(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
		
		//params.put("salesOrderId", 256488);
		
		int prgrsId = 0;
		
		params.put("prgrsId", prgrsId);
		
		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		//[Tap]Basic Info
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params);//
		
		model.put("orderDetail", orderDetail);
		
		return "sales/order/orderDetail";
	}
	
	@RequestMapping(value = "/selectSameRentalGrpOrderJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSameRentalGrpOrderJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> sameRentalGrpOrderJsonList = orderDetailService.selectSameRentalGrpOrderList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(sameRentalGrpOrderJsonList);
	}
	
	@RequestMapping(value = "/selectMembershipInfoJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMembershipInfoJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> memInfoList = orderDetailService.selectMembershipInfoList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}
	
	@RequestMapping(value = "/selectDocumentJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDocumentJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> memInfoList = orderDetailService.selectDocumentList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}
	
	@RequestMapping(value = "/selectCallLogJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCallLogJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> memInfoList = orderDetailService.selectCallLogList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}
	
	@RequestMapping(value = "/selectPaymentJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPaymentJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> memInfoList = orderDetailService.selectPaymentMasterList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}
	
	@RequestMapping(value = "/selectAutoDebitJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAutoDebitJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> memInfoList = orderDetailService.selectAutoDebitList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}
	
	@RequestMapping(value = "/selectDiscountJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDiscountJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> memInfoList = orderDetailService.selectDiscountList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}
	
	@RequestMapping(value = "/selectLast6MonthTransJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLast6MonthTransJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> memInfoList = null;//orderDetailService.selectLast6MonthTransList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(memInfoList);
	}
}
