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

import com.coway.trust.biz.sales.order.OrderInvestService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderInvestController {

	private static Logger logger = LoggerFactory.getLogger(OrderListController.class);
	
	@Resource(name = "orderInvestService")
	private OrderInvestService orderInvestService; 
	
	
	@RequestMapping(value = "/orderInvestList.do")
	public String orderInvestList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderInvestigationList";
	}
	
	
	@RequestMapping(value = "/orderInvestJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderInvestJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		
		logger.debug("!@###### startCrtDt : "+params.get("startCrtDt"));
		logger.debug("!@###### ::::::::::: : "+params.toString());
		String stDate = (String)params.get("startCrtDt");
		if(stDate != null && stDate != ""){
			String createStDate = stDate.substring(6) + "-" + stDate.substring(3, 5) + "-" + stDate.substring(0, 2);
			params.put("startCrtDt", createStDate);
		}
		String enDate = (String)params.get("endCrtDt");
		if(enDate != null && enDate != ""){
			String createEnDate = enDate.substring(6) + "-" + enDate.substring(3, 5) + "-" + enDate.substring(0, 2);
			params.put("endCrtDt", createEnDate);
		}
		List<EgovMap> orderInvestList = orderInvestService.orderInvestList(params);
		return ResponseEntity.ok(orderInvestList);
	}
	
	
}
