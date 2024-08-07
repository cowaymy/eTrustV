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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sales.order.OrderSuspensionService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderSuspensionController {
	private static final Logger logger = LoggerFactory.getLogger(OrderSuspensionController.class);
	
	@Resource(name = "orderSuspensionService")
	private OrderSuspensionService orderSuspensionService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;

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
		
		List<EgovMap> orderSuspensionList = orderSuspensionService.orderSuspensionList(params);
				
		// 데이터 리턴.
		return ResponseEntity.ok(orderSuspensionList);
				
	}
	
	
	@RequestMapping(value = "/orderSuspensionDetailPop.do")
	public String orderSuspensionDetailPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		// order detail start
		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);
	
		params.put("salesOrderId", params.get("salesOrdId"));
        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		
		model.put("orderDetail", orderDetail);
		model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
		// order detail end
		
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
	
	
	@RequestMapping(value = "/orderSuspendNewResultPop.do")
	public String orderSuspendNewResultPop(@RequestParam Map<String, Object>params, ModelMap model, SessionVO sessionVO) throws Exception {
		
		// order detail start
		int prgrsId = 0;
		EgovMap orderDetail = null;
		params.put("prgrsId", prgrsId);
	
		params.put("salesOrderId", params.get("salesOrdId"));
        orderDetail = orderDetailService.selectOrderBasicInfo(params, sessionVO);
		
		model.put("orderDetail", orderDetail);
		model.addAttribute("salesOrderNo", params.get("salesOrderNo"));
		// order detail end
				
		EgovMap suspensionInfo = orderSuspensionService.orderSuspendInfo(params);
		
		model.addAttribute("suspensionInfo", suspensionInfo);
		model.addAttribute("susId", params.get("susId"));
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		
		return "sales/order/orderSuspendNewResultPop";
	}
	
	
	@RequestMapping(value = "/newSuspendResult.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> newSuspendResult(@RequestParam Map<String, Object> params, ModelMap mode)
			throws Exception {
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		logger.info("##### sessionVO.getUserId() #####" +sessionVO.getUserId());
		
		//String retMsg = AppConstants.MSG_SUCCESS;
		String retMsg = "SUCCESS";
		
		Map<String, Object> map = new HashMap();
		
		orderSuspensionService.newSuspendResult(params);

		map.put("msg", retMsg);

		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/inchargePersonPop.do")
	public String inchargePersonPop(@RequestParam Map<String, Object>params, ModelMap model) throws Exception {

		model.addAttribute("susId", params.get("susId"));
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		
		return "sales/order/orderAssignInchargePop";
	}
	
	
	@RequestMapping(value = "/saveReAssign.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveReAssign(@RequestParam Map<String, Object> params, ModelMap mode)
			throws Exception {
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		logger.info("##### paramssssssssssss ##### " +params.toString());
		
		orderSuspensionService.saveReAssign(params);
		
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
}
