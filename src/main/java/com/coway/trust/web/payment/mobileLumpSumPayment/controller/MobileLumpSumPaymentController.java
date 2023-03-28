package com.coway.trust.web.payment.mobileLumpSumPayment.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.MobileLumpSumPaymentKeyInService;
import com.coway.trust.biz.payment.mobilePaymentKeyIn.service.MobilePaymentKeyInService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment/mobileLumpSumPayment")
public class MobileLumpSumPaymentController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MobileLumpSumPaymentController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;


	  @Resource(name = "memberListService")
	  private MemberListService memberListService;

	  @Resource(name = "mobileLumpSumPaymentKeyInService")
	  private MobileLumpSumPaymentKeyInService mobileLumpSumPaymentKeyInService;


	  @Resource(name = "mobilePaymentKeyInService")
	  private MobilePaymentKeyInService mobilePaymentKeyInService;

	@RequestMapping(value = "/lumpSumEnrollmentList.do")
	public String lumpSumEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		List<EgovMap> userBranch = memberListService.selectUserBranch();

	    EgovMap memDetail = mobilePaymentKeyInService.selectMemDetails(sessionVO);
	    model.addAttribute("userBranch", userBranch);
	    model.addAttribute("memDetail", memDetail);
	    model.addAttribute("memLevel", sessionVO.getMemberLevel());
	    model.addAttribute("memCode", sessionVO.getUserName());
		return "payment/mobileLumpSumPayment/lumpSumEnrollmentList";
	}

	@RequestMapping(value = "/getlumpSumEnrollmentList.do")
	public ResponseEntity<List<EgovMap>> getlumpSumEnrollmentList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		List<EgovMap> resultList = mobileLumpSumPaymentKeyInService.getLumpSumEnrollmentList(params);
	    return ResponseEntity.ok(resultList);
	}
}
