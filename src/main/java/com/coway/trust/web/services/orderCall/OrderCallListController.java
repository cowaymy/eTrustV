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

import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
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
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;
	
	
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
		//FeedBack Code
		List<EgovMap> callStatus = orderCallListService.selectCallStatus();
		List<EgovMap> productList = orderCallListService.selectProductList();
		model.addAttribute("callStatus", callStatus);
		model.addAttribute("productList", productList);
		// 호출될 화면
		return "services/orderCall/orderCallList";
	}
	
	
	
	
	@RequestMapping(value = "/getstateList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getstateList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		List<EgovMap> stateList = orderCallListService.getstateList();
		return ResponseEntity.ok(stateList);
	}

	
	@RequestMapping(value = "/getAreaList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getAreaList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		List<EgovMap> areaList = orderCallListService.getAreaList(params);
		return ResponseEntity.ok(areaList);
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
	public ResponseEntity<List<EgovMap>> selectOrderCallListSearch(@RequestParam Map<String, Object> params, HttpServletRequest request,ModelMap model) {
		logger.debug("params : {}", params);
		
		String[] appTypeList =  request.getParameterValues("appType");
		String[] callLogTypeList =  request.getParameterValues("callLogType");
		String[] callLogStatusList =  request.getParameterValues("callLogStatus");
		String[] DSCCodeList =  request.getParameterValues("DSCCode");
		
		params.put("appTypeList", appTypeList);
		params.put("callLogTypeList", callLogTypeList);
		params.put("callLogStatusList", callLogStatusList);
		params.put("DSCCodeList", DSCCodeList);
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
	public String insertCallResultPop(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) throws Exception {
		EgovMap orderCall = orderCallListService.getOrderCall(params);
		List<EgovMap> callStatus = orderCallListService.selectCallStatus();
		
		String productCode = orderCall.get("productCode").toString();
		params.put("productCode", productCode);
		logger.debug("jinmu : {}", params);
		EgovMap cdcAvaiableStock = orderCallListService.selectCdcAvaiableStock(params);
		logger.debug("jinmu1 : {}", cdcAvaiableStock);
		EgovMap  rdcStock = orderCallListService.selectRdcStock(params);
		
		
		//Order Detail Tab
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params ,sessionVO);
		logger.debug("orderCall : {}", orderCall);
		model.addAttribute("callStusCode", params.get("callStusCode"));
		model.addAttribute("callStusId", params.get("callStusId"));
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		model.addAttribute("callEntryId", params.get("callEntryId"));
		model.addAttribute("salesOrdNo", params.get("salesOrdNo"));
		model.addAttribute("cdcAvaiableStock", cdcAvaiableStock);
		model.addAttribute("rdcStock", rdcStock);
		model.addAttribute("orderCall", orderCall);
		model.addAttribute("callStatus", callStatus);
		model.addAttribute("orderDetail", orderDetail);
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
		
		if( null !=resultValue){
			HashMap   spMap =(HashMap)resultValue.get("spMap");
			logger.debug("spMap :"+ spMap.toString());   
			if(! "000".equals(spMap.get("P_RESULT_MSG"))){
				resultValue.put("logerr","Y");
				
				message.setMessage("Error in Logistics Transaction");
				message.setCode("99");
				
			}else{
				message.setMessage("success Installation No : " + resultValue.get("installationNo") +"</br>SELES ORDER NO : " +  resultValue.get("salesOrdNo"));
				message.setCode("1");
			}
			
			
			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
		}
		
		
		
		
		
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * Call Center - order Call List - Save Call Log Result 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getCallLogTransaction.do", method = RequestMethod.GET)
	public  ResponseEntity<List<EgovMap>>  selectCallLogTransaction(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		logger.debug("params : {}", params);
		//Call Log Transation
		List<EgovMap> callLogTran = orderCallListService.selectCallLogTransaction(params);
		
		logger.debug("callLogTran : {}", callLogTran);
		return ResponseEntity.ok(callLogTran);
	}
	
	/**
	 * Call Center - order Call List - Add Call Log Result 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/viewCallResultPop.do")
	public String selectCallResultPop(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) throws Exception {
		EgovMap orderCall = orderCallListService.getOrderCall(params);
		List<EgovMap> callStatus = orderCallListService.selectCallStatus();
		
		EgovMap rdcincdc = orderCallListService.getRdcInCdc(orderCall);
		
		//Order Detail Tab
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params ,sessionVO);
		logger.debug("orderCall : {}", orderCall);
		model.addAttribute("callStusCode", params.get("callStusCode"));
		model.addAttribute("callStusId", params.get("callStusId"));
		model.addAttribute("salesOrdId", params.get("salesOrdId"));
		model.addAttribute("callEntryId", params.get("callEntryId"));
		model.addAttribute("salesOrdNo", params.get("salesOrdNo"));
		model.addAttribute("orderCall", orderCall);
		model.addAttribute("callStatus", callStatus);
		model.addAttribute("orderDetail", orderDetail);
		model.addAttribute("orderRdcInCdc", rdcincdc);
		return "services/orderCall/viewCallLogResultPop";
	}
	
}
