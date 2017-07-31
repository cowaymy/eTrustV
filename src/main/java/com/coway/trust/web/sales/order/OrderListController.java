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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.order.OrderListService;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/sales/order")
public class OrderListController {

	private static Logger logger = LoggerFactory.getLogger(OrderListController.class);
	
	@Resource(name = "orderListService")
	private OrderListService orderListService;
	
	@RequestMapping(value = "/orderList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderList";
	}
	
	@RequestMapping(value = "/selectOrderJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		String[] arrAppType   = request.getParameterValues("appType"); //Application Type
		String[] arrOrdStusId = request.getParameterValues("ordStusId"); //Order Status 
		String[] arrKeyinBrnchId = request.getParameterValues("keyinBrnchId"); //Key-In Branch
		String[] arrDscBrnchId = request.getParameterValues("dscBrnchId"); //DSC Branch 
		String[] arrRentStus = request.getParameterValues("rentStus"); //Rent Status
				
		if(StringUtils.isEmpty(params.get("ordStartDt"))) params.put("ordStartDt", "01/01/1900");
		if(StringUtils.isEmpty(params.get("ordEndDt")))   params.put("ordEndDt",   "31/12/9999");

		params.put("arrAppType", arrAppType);
		params.put("arrOrdStusId", arrOrdStusId);
		params.put("arrKeyinBrnchId", arrKeyinBrnchId);
		params.put("arrDscBrnchId", arrDscBrnchId);
		params.put("arrRentStus", arrRentStus);
		
		if(params.get("custIc") == null) {logger.debug("!@###### custIc is null");}
		if("".equals(params.get("custIc"))) {logger.debug("!@###### custIc ''");}
		
		logger.debug("!@##############################################################################");
		logger.debug("!@###### ordNo : "+params.get("ordNo"));
		logger.debug("!@###### ordStartDt : "+params.get("ordStartDt"));
		logger.debug("!@###### ordEndDt : "+params.get("ordEndDt"));
		logger.debug("!@###### arrAppType : "+arrAppType);
		logger.debug("!@###### arrOrdStusId : "+arrOrdStusId);
		logger.debug("!@###### arrKeyinBrnchId : "+arrKeyinBrnchId);
		logger.debug("!@###### arrRentStus : "+arrRentStus);
		logger.debug("!@###### custIc : "+params.get("custIc"));
		logger.debug("!@##############################################################################");
		
		List<EgovMap> orderList = orderListService.selectOrderList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(orderList);
	}
}
