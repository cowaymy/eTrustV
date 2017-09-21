package com.coway.trust.web.payment.billing.controller;


import java.util.ArrayList;
import java.util.Calendar;
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
import com.coway.trust.biz.payment.billing.service.RentalMemberShipBillingService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class RentalMemberShipBillingController {

	private static final Logger logger = LoggerFactory.getLogger(RentalMemberShipBillingController.class);
	
	@Resource(name = "rentalMemberShipBillingService")
	private RentalMemberShipBillingService rentalMemberShipBillingService;
	
	/**
	 * UnBilled_RentalMembership 초기 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initUnBilledRentalMembership.do")
	public String initBillingRentalFee(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("UnBilled_RentalMembership 초기 화면 ");
		return "payment/billing/unBilledRentalMembership";
	}
	
	/**
	 * selectCustBillOrderNoList 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCustBillOrderNoList_M.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectCustBillOrderNoList_M(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
        
		List<EgovMap> orderList = rentalMemberShipBillingService.selectCustBillOrderList_M(params);
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("orderList", orderList);

        // 조회 결과 리턴.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(resultMap);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * selectRentalMembershipBillingSchedule 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRentalMembershipBillingSchedule.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectUnbilledRentalBillingSchedule_M(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
        
		List<EgovMap> rentalMembershipScheduleList = rentalMemberShipBillingService.selectRentalMembershipBillingSchedule(params);
        
        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("rentalMembershipScheduleList", rentalMembershipScheduleList);

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
	@RequestMapping(value = "/saveCreateTaxesManualBillRentalMbrsh.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCreateBills(@RequestBody Map<String, ArrayList<Object>> params, ModelMap mode, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
        
        List<Object> gridList = params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
    	List<Object> formList = params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
    	int result = -1;
    	result = rentalMemberShipBillingService.confirmTaxesManualBillRentalMbrsh(formList, gridList,  sessionVO);
    	
    	if(result > 0){
    		message.setCode(AppConstants.SUCCESS);
    		message.setMessage("Sucess.");
    	}else{
    		message.setCode(AppConstants.FAIL);
    		message.setMessage("Failed.");
    	}
    	logger.debug("result===="+result);
    	
		return ResponseEntity.ok(message);
	}
	
}
