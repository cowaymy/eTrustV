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

	private static final Logger logger = LoggerFactory.getLogger(OrderDetailController.class);
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@RequestMapping(value = "/orderDetail.do")
	public String getOrderDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {
		
		//params.put("salesOrderId", 256488);
		
		int prgrsId = 0;
		
		params.put("prgrsId", prgrsId);
		
		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		//[Tap]Basic Info
		EgovMap orderDetail = orderDetailService.getOrderBasicInfo(params);//
		
		model.put("orderDetail", orderDetail);
		
		return "sales/order/orderDetail";
	}
	
	@RequestMapping(value = "/selectSameRentalGrpOrderJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSameRentalGrpOrderJsonList(@RequestParam Map<String, Object>params, ModelMap model) {

		logger.debug("!@##############################################################################");
		logger.debug("!@###### salesOrderId : "+params.get("salesOrderId"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> sameRentalGrpOrderJsonList = orderDetailService.getSameRentalGrpOrderList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(sameRentalGrpOrderJsonList);
	}
}
