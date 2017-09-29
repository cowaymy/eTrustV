package com.coway.trust.web.services.orderCall;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.orderCall.OrderCallListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/callCenter")
public class OrderCallListController {
	private static final Logger logger = LoggerFactory.getLogger(OrderCallListController.class);
	
	@Resource(name = "orderCallListService")
	private OrderCallListService orderCallListService;
	
	/**
	 * Call Center - Order Call 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/orderCallList.do")
	public String orderCallList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/orderCall/orderCallList";
	}
	
	/**
	 * Call Center - order Call List SEARCH
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchOrderCallList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOrderCallListSearch(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("params : {}", params);
		List<EgovMap> orderCallList = orderCallListService.selectOrderCall(params);
		
		logger.debug("orderCallList : {}", orderCallList);
		return ResponseEntity.ok(orderCallList);
	}
	
	/**
	 * Call Center - order Call List - Add Call Log Result 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addCallResultPop.do")
	public String insertCallResultPop(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap orderCall = orderCallListService.getOrderCall(params);
		List<EgovMap> callStatus = orderCallListService.selectCallStatus();
		logger.debug("orderCall : {}", orderCall);
		model.addAttribute("callStusCode", params.get("callStusCode"));
		model.addAttribute("callStusId", params.get("callStusId"));
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		model.addAttribute("callEntryId", params.get("callEntryId"));
		model.addAttribute("salesOrdNo", params.get("salesOrdNo"));
		model.addAttribute("orderCall", orderCall);
		model.addAttribute("callStatus", callStatus);
		return "services/orderCall/addCallLogResultPop";
	}
	
	/**
	 * Call Center - order Call List - Save Call Log Result 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addCallLogResult.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>  insertCallResult(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		boolean success = false;
		logger.debug("params : {}", params);
		String installationNo = "";
		Map<String, Object> resultValue = new HashMap<String, Object>();
		resultValue = orderCallListService.insertCallResult(params,sessionVO);
		message.setMessage("success Installation No : " + resultValue.get("installationNo") +"</br>SELES ORDER NO : " +  resultValue.get("salesOrdNo"));
		return ResponseEntity.ok(message);
	}
	
}
