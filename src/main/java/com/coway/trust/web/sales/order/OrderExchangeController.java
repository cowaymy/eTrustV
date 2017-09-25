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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderExchangeService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderExchangeController {

	private static final Logger logger = LoggerFactory.getLogger(OrderExchangeController.class);
	
	@Resource(name = "orderExchangeService")
	private OrderExchangeService orderExchangeService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/**
	 * Order Exchange List 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/orderExchangeList.do")
	public String orderExchangeList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		return "sales/order/orderExchangeList";
	}
	
	
	@RequestMapping(value = "/orderExchangeJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderExchangeList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		String[] arrExcType   = request.getParameterValues("cmbExcType"); 
		String[] arrExcStatus = request.getParameterValues("cmbExcStatus"); 
		String[] arrAppType = request.getParameterValues("cmbAppType");		//Application Type
		
		params.put("arrExcType", arrExcType);
		params.put("arrExcStatus", arrExcStatus);
		params.put("arrAppType", arrAppType);		
				
		List<EgovMap> orderExchangeList = orderExchangeService.orderExchangeList(params);
		
		
		
		// 데이터 리턴.
		return ResponseEntity.ok(orderExchangeList);
	}
	
	
	/**
	 * Exchange Information. - Product Exchange Type
	 */
	@RequestMapping(value = "/orderExchangeDetailPop.do")
	public String orderExchangeDetailPop(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
		logger.info("##### cmbExcType #####" +params.get("exchgType"));
		EgovMap exchangeDetailInfo = orderExchangeService.exchangeInfoProduct(params);
		
		params.put("soExchgOldCustId", exchangeDetailInfo.get("soExchgOldCustId"));
		params.put("soExchgNwCustId", exchangeDetailInfo.get("soExchgNwCustId"));
		
		EgovMap exchangeInfoOwnershipFr = orderExchangeService.exchangeInfoOwnershipFr(params);
		EgovMap exchangeInfoOwnershipTo = orderExchangeService.exchangeInfoOwnershipTo(params);
		
		model.addAttribute("exchangeDetailInfo", exchangeDetailInfo);
		model.addAttribute("initType", params.get("exchgType"));
		model.addAttribute("soExchgIdDetail", exchangeDetailInfo.get("soExchgId"));
		model.addAttribute("exchangeInfoOwnershipFr", exchangeInfoOwnershipFr);
		model.addAttribute("exchangeInfoOwnershipTo", exchangeInfoOwnershipTo);
		
		//[Tap]Basic Info
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params);//
		
		model.put("orderDetail", orderDetail);
		
		return "sales/order/orderExchangeDetailPop";
		
	}
	
	
	@RequestMapping(value = "/saveCancelReq.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveCancelReq(@RequestParam Map<String, Object> params, ModelMap mode)
			throws Exception {
		
		
		
		String retMsg = AppConstants.MSG_SUCCESS;
		
		Map<String, Object> map = new HashMap();
		
		try{
			orderExchangeService.saveCancelReq(params);
		}catch(Exception ex){
			retMsg = AppConstants.MSG_FAIL;
		}finally{
			map.put("msg", retMsg);
		}
		return ResponseEntity.ok(map);
	}
	
}
