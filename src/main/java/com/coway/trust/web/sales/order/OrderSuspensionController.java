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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.order.OrderSuspensionService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderSuspensionController {
	private static final Logger logger = LoggerFactory.getLogger(OrderSuspensionController.class);
	
	@Resource(name = "orderSuspensionService")
	private OrderSuspensionService orderSuspensionService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;

	/**
	 * Order Exchange List 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/orderSuspensionList.do")
	public String orderSuspensionList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		return "sales/order/orderSuspentionList";
	}
	
	
	@RequestMapping(value = "/orderSuspensionJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderSuspensionList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		String[] susStusList   = request.getParameterValues("susStusId"); 
		
		params.put("susStusList", susStusList);
		
		String stDate = (String)params.get("startCrtDt");
		if(stDate != null && stDate != ""){
			String createStDate = stDate.substring(6) + "-" + stDate.substring(3, 5) + "-" + stDate.substring(0, 2);
			logger.info("##### createStDate #####" +createStDate);
			params.put("startCrtDt", createStDate);
		}
		String enDate = (String)params.get("endCrtDt");
		if(enDate != null && enDate != ""){
			String createEnDate = enDate.substring(6) + "-" + enDate.substring(3, 5) + "-" + enDate.substring(0, 2);
			logger.info("##### createEnDate #####" +createEnDate);
			params.put("endCrtDt", createEnDate);
		}
		
		List<EgovMap> orderSuspensionList = orderSuspensionService.orderSuspensionList(params);
				
		// 데이터 리턴.
		return ResponseEntity.ok(orderSuspensionList);
				
	}
	
	
	@RequestMapping(value = "/orderSuspensionDetailPop.do")
	public String orderSuspensionDetailPop(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {
		
		EgovMap suspensionInfo = orderSuspensionService.orderSuspendInfo(params);
		
		model.addAttribute("suspensionInfo", suspensionInfo);
		model.addAttribute("susId", params.get("susId"));
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		
		return "sales/order/orderSuspensionDetailPop";
	}
	
	
	@RequestMapping(value = "/inchargePersonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> inchargePersonList(@RequestParam Map<String, Object>params, ModelMap model)throws Exception{
		
		List<EgovMap> inchargePersonList = orderSuspensionService.suspendInchargePerson(params);
		return ResponseEntity.ok(inchargePersonList);
	}
	
	
	@RequestMapping(value = "/suspendCallResultList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> suspendCallResultList(@RequestParam Map<String, Object>params, ModelMap model)throws Exception{
		
		List<EgovMap> suspendCallResultList = orderSuspensionService.suspendCallResult(params);
		return ResponseEntity.ok(suspendCallResultList);
	}
	
	
	@RequestMapping(value = "/callResultLogList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> callResultLogList(@RequestParam Map<String, Object>params, ModelMap model)throws Exception{
		
		List<EgovMap> callResultLogList = orderSuspensionService.callResultLog(params);
		return ResponseEntity.ok(callResultLogList);
	}
	
}
