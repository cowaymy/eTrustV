package com.coway.trust.web.payment.billing.controller;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.billing.service.AdvRentalBillingService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class AdvRentalBillingController {

	private static final Logger logger = LoggerFactory.getLogger(AdvRentalBillingController.class);
	
	@Resource(name = "advRentalBillingService")
	private AdvRentalBillingService advRentalBillingService;
	
	
	/**
	 * Advance Rental Fee 초기 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initBillingRentalFee.do")
	public String initBillingRentalFee(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/billingRentalFee";
	}
	
	/**
	 * selectCustBillOrderList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCustBillOrderList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectCustBillOrderList(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
        
		List<EgovMap> orderList = advRentalBillingService.selectCustBillOrderList(params);
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("orderList", orderList);

        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectRentalBillingSchedule 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRentalBillingSchedule.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectRentalBillingSchedule(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
        
		List<EgovMap> billingScheduleList = advRentalBillingService.selectRentalBillingSchedule(params);
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("billingScheduleList", billingScheduleList);

        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * saveCreateBills 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveCreateBills.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCreateBills(@RequestBody Map<String, ArrayList<Object>> params, ModelMap mode, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
        
        List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
    	int result = -1;
    	result = advRentalBillingService.createTaxesBills(formList, gridList,  sessionVO);
    	
    	if(result > 0){
    		message.setCode(AppConstants.SUCCESS);
    		message.setMessage("Sucess.");
    	}else{
    		message.setCode(AppConstants.FAIL);
    		message.setMessage("Failed.");
    	}
    	
		return ResponseEntity.ok(message);
	}
	
}
