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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.order.OrderColorGridService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderColorGridController {

	private static final Logger logger = LoggerFactory.getLogger(OrderColorGridController.class);
	
	@Resource(name = "orderColorGridService")
	private OrderColorGridService orderColorGridService;
	
	/**
	 * 화면 호출. order Color Grid
	 */
	@RequestMapping(value = "/orderColorGridList.do")
	public String orderColorGridList(@RequestParam Map<String, Object>params, ModelMap model) {
		
		return "sales/order/orderColorGridList";
	}
	
	@RequestMapping(value = "/orderColorGridJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderColorGridJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		logger.info("##################### params #####" +params.toString());
		
		List<EgovMap> colorGridList = orderColorGridService.colorGridList(params);
		
		return ResponseEntity.ok(colorGridList);
	}
}
