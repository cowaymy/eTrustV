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
import com.coway.trust.biz.payment.billing.service.SrvMembershipBillingService;
import com.coway.trust.biz.sales.mambership.MembershipConvSaleService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;


@Controller
@RequestMapping(value = "/payment")
public class SrvMembershipBillingController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SrvMembershipBillingController.class);

	@Resource(name = "srvMembershipBillingService")
	private SrvMembershipBillingService srvMembershipBillingService;

	@Resource(name = "membershipConvSaleService")
	private MembershipConvSaleService membershipConvSaleService;

	/**
	 * Manual Billing - Membership 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initSrvMembershipBilling.do")
	public String initBillingMgnt(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/billing/srvMembershipBilling";
	}

	/**
	 * Manual Billing - Membership save 처리
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/saveSrvMembershipBilling.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSrvMembershipBilling(@RequestBody Map<String, Object> params, ModelMap model , SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		List<Object> gridList = (List<Object>) params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		Map<String, Object> formData = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기

		if (membershipConvSaleService.checkDuplicateRefNo(formData)){
			message.setCode(AppConstants.FAIL);
			message.setMessage("-1");

			return ResponseEntity.ok(message);
		}

		int result = -1;
    	result = srvMembershipBillingService.saveSrvMembershipBilling(formData, gridList,  sessionVO);

    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(String.valueOf(result));

    	return ResponseEntity.ok(message);
	}



}
