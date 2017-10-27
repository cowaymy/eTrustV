package com.coway.trust.web.sales.order;

import java.util.Map;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderRentalService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderRentalPaySetController {

	private static Logger logger = LoggerFactory.getLogger(OrderRentalPaySetController.class);
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@Resource(name = "orderRentalService")
	private OrderRentalService orderRentalService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	
	@RequestMapping(value = "/orderRentPaySetLimitPop.do")
	public String selectCalPaymentChannel(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{
		
		logger.info("#####################################################");
		logger.info("######  params.ToString : " + params.toString());
		logger.info("#####################################################");
		
		params.put("salesOrderId", params.get("salesOrdId"));
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		
		EgovMap payMap = null;
		payMap = orderRentalService.getPayTerm(params);
		
		model.addAttribute("payMap" , payMap);
		model.addAttribute("orderDetail", orderDetail);
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		
		return "sales/order/orderRentalPaySetLimitPop";
	}
	
	
	@RequestMapping(value = "/rentalPaySetEdit" , method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> ccpCalPayChannelUpdate(@RequestBody Map<String, Object> params) throws Exception{
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		
		//params Setting
		params.put("userId", sessionVO.getUserId());
		
		logger.info("#####################################################");
		logger.info("######  params.ToString : " + params.toString());
		logger.info("#####################################################");
		
		orderRentalService.updatePayChannel(params);
		
		//Return Message
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
		
	}
}
