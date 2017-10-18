package com.coway.trust.web.sales.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderInvestService;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/order")
public class OrderInvestController {

	private static Logger logger = LoggerFactory.getLogger(OrderListController.class);
	
	@Resource(name = "orderInvestService")
	private OrderInvestService orderInvestService; 
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/orderInvestList.do")
	public String orderInvestList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderInvestigationList";
	}
	
	
	@RequestMapping(value = "/orderInvestJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderInvestJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		logger.debug("!@###### startCrtDt : "+params.get("startCrtDt"));
		logger.debug("!@###### ::::::::::: : "+params.toString());
		
		
		String[] invReqStusId = request.getParameterValues("invReqStusId");
		params.put("invReqStusIdList", invReqStusId);
		
		List<EgovMap> orderInvestList = orderInvestService.orderInvestList(params);
		return ResponseEntity.ok(orderInvestList);
	}
	
	
	/**
	 * 
	 * Investigation View
	 * @param params
	 * @param model
	 * @return
	 * @author 
	 * */
	@RequestMapping(value = "/orderInvestInfoPop.do")
	public String orderInvestInfoPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		EgovMap orderInvestInfo = null;
		EgovMap orderCustomerInfo = null;
		logger.info("##### orderInvestInfoPop START #####");
		
		orderInvestInfo = orderInvestService.orderInvestInfo(params);
		orderCustomerInfo = orderInvestService.orderCustomerInfo(params);
		
		List<EgovMap> cmbRejReasonList = orderInvestService.cmbRejReasonList(params);
		
		model.addAttribute("orderInvestInfo", orderInvestInfo);
		model.addAttribute("orderCustomerInfo", orderCustomerInfo);
		model.addAttribute("cmbRejReasonList", cmbRejReasonList);
		
		return "sales/order/orderInvestigationDetailPop";
	}
	
	
	@RequestMapping(value = "/orderInvestDetailGridJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderInvestDetailGridJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> orderCustomerInfoGrid = orderInvestService.orderInvestInfoGrid(params);
		logger.info("##### orderCustomerInfoGrid #####" +orderCustomerInfoGrid.toString());
		return ResponseEntity.ok(orderCustomerInfoGrid);
	}
	
	
	@RequestMapping(value = "/inchargeJsonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> inchargeJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		logger.info("##### params #####" +params.toString());
		List<EgovMap> inchargeList = orderInvestService.inchargeList(params);

		return ResponseEntity.ok(inchargeList);
	}
	
	
	@RequestMapping(value = "/saveInvest.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveInvest(@RequestParam Map<String, Object> params, ModelMap mode)
			throws Exception {
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		params.put("inchargeNmId", params.get("inchargeNm"));
		
		String retMsg = "SUCCESS";
		
		Map<String, Object> map = new HashMap();
		
		orderInvestService.saveInvest(params);
		
		map.put("msg", retMsg);

		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/orderNewRequestSingleList.do")
	public String singleInvestList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderNewRequestSingleList";
	}
	
	
	@RequestMapping(value = "/orderNewRequestSingleChk", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> orderNewRequestSingleChk(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {
		
		String retMsg = "";
		
		Map<String, Object> map = new HashMap();
		
		try{
			int orderInvestClosedDateChk = orderInvestService.orderInvestClosedDateChk();
			
			if(orderInvestClosedDateChk < 1){
				EgovMap orderNoChk = orderInvestService.orderNoChk(params);
				logger.debug("##### orderNoChk #####" +orderNoChk.toString());
				logger.debug("##### orderNoChk #####" +orderNoChk);
				if(orderNoChk != null && !"".equals(orderNoChk)){
					retMsg = "OK";
					EgovMap singleInvestView = orderInvestService.singleInvestView(params);
					map.put("salesOrdNo", singleInvestView.get("salesOrdNo"));
					map.put("salesDt", singleInvestView.get("salesDt"));
					map.put("name", singleInvestView.get("name"));
					map.put("stusCodeId", singleInvestView.get("stusCodeId"));
					map.put("codeName", singleInvestView.get("codeName"));
					map.put("stkCode", singleInvestView.get("stkCode"));
					map.put("stkDesc", singleInvestView.get("stkDesc"));
					map.put("name1", singleInvestView.get("name1"));
					map.put("nric", singleInvestView.get("nric"));
				}else{
					retMsg = "NO";
				}
			}else{
				retMsg = "NO";
			}
		}catch(Exception ex){
			retMsg = "Err";
		}finally{
			map.put("msg", retMsg);
		}
		
		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/orderNewRequestSingleOk", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> orderNewRequestSingleOk(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {
		
		String retMsg = AppConstants.MSG_SUCCESS;
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		String callDt = (String)params.get("callDt");
		if(callDt != null && callDt != ""){
			String insCallDt = callDt.substring(6) + "-" + callDt.substring(3, 5) + "-" + callDt.substring(0, 2) + " 00:00:00";
			logger.info("##### callDt #####" +insCallDt);
			params.put("callDt", insCallDt);
		}
		String visitDt = (String)params.get("visitDt");
		if(visitDt != null && visitDt != ""){
			String insVisitDt = visitDt.substring(6) + "-" + visitDt.substring(3, 5) + "-" + visitDt.substring(0, 2) + " 00:00:00";
			logger.info("##### visitDt #####" +insVisitDt);
			params.put("visitDt", insVisitDt);
		}
		
		Map<String, Object> map = new HashMap();
		
		try{
//			int orderInvestClosedDateChk = orderInvestService.orderInvestClosedDateChk();

//			EgovMap singleInvestView = orderInvestService.singleInvestView(params);

			orderInvestService.insertNewRequestSingleOk(params);
			EgovMap orderNoInfo = orderInvestService.orderNoInfo(params);
			
			map.put("invReqId", orderNoInfo.get("invReqId"));
			
		}catch(Exception ex){
			retMsg = AppConstants.MSG_FAIL;
		}finally{
			map.put("msg", retMsg);
		}
		
		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/orderInvestReject", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> orderInvestReject(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {
		
		String retMsg = AppConstants.MSG_SUCCESS;
		
		Map<String, Object> map = new HashMap();
		
		try{

			int existChk = orderInvestService.searchBSScheduleM(params);
			logger.info("##### existChk count #####" +existChk);
			map.put("existChkCnt", existChk);
			
		}catch(Exception ex){
			retMsg = AppConstants.MSG_FAIL;
		}finally{
			map.put("msg", retMsg);
		}
		
		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/saveOrderInvestOk", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveOrderInvestOk(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {
		
		String retMsg = AppConstants.MSG_SUCCESS;
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		String callDt = (String)params.get("callDt");
		if(callDt != null && callDt != ""){
			String insCallDt = callDt.substring(6) + "-" + callDt.substring(3, 5) + "-" + callDt.substring(0, 2) + " 00:00:00";
			logger.info("##### callDt #####" +insCallDt);
			params.put("callDt", insCallDt);
		}
		String visitDt = (String)params.get("visitDt");
		if(visitDt != null && visitDt != ""){
			String insVisitDt = visitDt.substring(6) + "-" + visitDt.substring(3, 5) + "-" + visitDt.substring(0, 2) + " 00:00:00";
			logger.info("##### visitDt #####" +insVisitDt);
			params.put("visitDt", insVisitDt);
		}
		
		Map<String, Object> map = new HashMap();
		
		try{
//			int orderInvestClosedDateChk = orderInvestService.orderInvestClosedDateChk();

//			EgovMap singleInvestView = orderInvestService.singleInvestView(params);

			orderInvestService.saveOrderInvestOk(params);
			EgovMap orderNoInfo = orderInvestService.orderNoInfo(params);
			
			map.put("invReqId", orderNoInfo.get("invReqId"));
			
		}catch(Exception ex){
			retMsg = AppConstants.MSG_FAIL;
		}finally{
			map.put("msg", retMsg);
		}
		
		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/orderInvestCallRecallList.do")
	public String orderInvestCallRecallList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "sales/order/orderInvestCallRecallList";
	}
	
	
	@RequestMapping(value = "/investCallResultJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> investCallResultJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		logger.debug("!@###### startCrtDt : "+params.get("startCrtDt"));
		logger.debug("!@###### ::::::::::: : "+params.toString());
		
		String[] invStusList = request.getParameterValues("invStusId");
		params.put("invStusList", invStusList);
		
		List<EgovMap> investCallResultList = orderInvestService.orderInvestCallRecallList(params);
		return ResponseEntity.ok(investCallResultList);
	}
	
	
	/**
	 * 
	 * Investigation Call/Result View
	 * @param params
	 * @param model
	 * @return
	 * @author 
	 * */
	@RequestMapping(value = "/orderInvestCallResultDtPop.do")
	public String orderInvestCallResultDtPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		EgovMap investCallResultInfo = null;
		EgovMap investCallResultCust = null;
		
		investCallResultInfo = orderInvestService.investCallResultInfo(params);
		investCallResultCust = orderInvestService.investCallResultCust(params);
		
		List<EgovMap> inchargeList = orderInvestService.inchargeList(params);
		
		model.addAttribute("investCallResultInfo", investCallResultInfo);
		model.addAttribute("investCallResultCust", investCallResultCust);
		model.addAttribute("inchargeList", inchargeList);
		
		
		return "sales/order/orderInvestCallResultDtPop";
	}
	
	
	@RequestMapping(value = "/ordInvestCallLogDtGridJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> ordInvestCallLogDtGridJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> investCallResultLog = orderInvestService.investCallResultLog(params);
		logger.info("##### investCallResultLog #####" +investCallResultLog.toString());
		return ResponseEntity.ok(investCallResultLog);
	}
	
	
	@RequestMapping(value = "/saveCallResultOk.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> saveCallResultOk(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {
		
		String retMsg = AppConstants.MSG_SUCCESS;
		
		Map<String, Object> map = new HashMap();
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		try{

			orderInvestService.saveCallResultOk(params);
			
		}catch(Exception ex){
			retMsg = AppConstants.MSG_FAIL;
		}finally{
			map.put("msg", retMsg);
		}
		
		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/bsMonthCheck.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> bsMonthCheck(@RequestParam Map<String, Object> params, ModelMap model)
			throws Exception {
		
		Map<String, Object> saveOkMap = new HashMap();
		
//		String regSaveMsg = orderInvestService.bsMonthCheck(params);
		String regSaveMsg = "0";
		
		saveOkMap.put("regSaveMsg", regSaveMsg);
		
		
		return ResponseEntity.ok(saveOkMap);
	}
	
	
	@RequestMapping(value = "/bsMonthCheckOKPop.do")
	public String bsMonthCheckOKPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("salesOrdNo", params.get("saveSalesOrdNo"));
		return "sales/order/orderInvestCallResultRegSavePop";
	}
	
	
	@RequestMapping(value = "/bsMonthCheckNoPop.do")
	public String bsMonthCheckNoPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("salesOrdNo", params.get("saveSalesOrdNo"));
		return "sales/order/orderInvestCallResultRegSave2Pop";
	}
	
}
