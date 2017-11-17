package com.coway.trust.web.sales.order;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.order.OrderLedgerService;
import com.coway.trust.util.CommonUtils;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderLedgerController {

	private static final Logger logger = LoggerFactory.getLogger(OrderLedgerController.class);
	
	@Resource(name = "orderLedgerService")
	private OrderLedgerService orderLedgerService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/orderLedgerViewPop.do")
	public String orderLedgerViewPop(@RequestParam Map<String, Object>params, ModelMap model){
		
		logger.debug("params ======================================>>> " + params);
				
		EgovMap orderInfo = orderLedgerService.selectOrderLedgerView(params);
		model.addAttribute("orderInfo", orderInfo);
		
		EgovMap insInfo = orderLedgerService.selectInsInfo(params);
		model.addAttribute("insInfo", insInfo);
		
		EgovMap mailInfo = orderLedgerService.selectMailInfo(params);
		model.addAttribute("mailInfo", mailInfo);

		EgovMap salesInfo = orderLedgerService.selectSalesInfo(params);
		model.addAttribute("salesInfo", salesInfo);
		
		List<EgovMap> orderLdgrList = orderLedgerService.getOderLdgr(params);
		model.addAttribute("orderLdgrList", new Gson().toJson(orderLdgrList));
		
		List<EgovMap> agreList = orderLedgerService.selectAgreInfo(params);
		model.addAttribute("agreList", new Gson().toJson(agreList));
		
		List<EgovMap> ordOutInfoList = orderLedgerService.getOderOutsInfo(params);
				
		EgovMap ordOutInfo = ordOutInfoList.get(0);
		
		logger.debug("ordOutInfo =====================>>> " + ordOutInfo);
		
		model.addAttribute("ordOutInfo", ordOutInfo);
		
		return "sales/order/orderLedgerPop";
	}

	@RequestMapping(value = "/orderLedger2ViewPop.do")
	public String orderLedger2ViewPop(@RequestParam Map<String, Object>params, ModelMap model){
		
		logger.debug("params ======================================>>> " + params);
		
		params.put("ordId", 134619);//TODO TEST 
		params.put("CutOffDate", "01/01/1900");//TODO TEST 
		
		EgovMap orderInfo = orderLedgerService.selectOrderLedgerView(params);
		model.addAttribute("orderInfo", orderInfo);
		
		EgovMap insInfo = orderLedgerService.selectInsInfo(params);
		model.addAttribute("insInfo", insInfo);
		
		EgovMap mailInfo = orderLedgerService.selectMailInfo(params);
		model.addAttribute("mailInfo", mailInfo);

		EgovMap salesInfo = orderLedgerService.selectSalesInfo(params);
		model.addAttribute("salesInfo", salesInfo);
		
		List<EgovMap> orderLdgrList = orderLedgerService.getOderLdgr2(params);
		model.addAttribute("orderLdgrList", new Gson().toJson(orderLdgrList));
		
		List<EgovMap> agreList = orderLedgerService.selectAgreInfo(params);
		model.addAttribute("agreList", new Gson().toJson(agreList));
		
		List<EgovMap> ordOutInfoList = orderLedgerService.getOderOutsInfo(params);
				
		EgovMap ordOutInfo = ordOutInfoList.get(0);
		
		logger.debug("ordOutInfo =====================>>> " + ordOutInfo);
		
		model.addAttribute("ordOutInfo", ordOutInfo);
		
		return "sales/order/orderLedger2Pop";
	}
	
}