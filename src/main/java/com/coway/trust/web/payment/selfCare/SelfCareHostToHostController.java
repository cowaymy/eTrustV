package com.coway.trust.web.payment.selfCare;

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
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.payment.selfcare.service.SelfCareHostToHostService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.payment.requestBillingGroup.controller.RequestBillingGroupController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment/selfCareHostToHost")
public class SelfCareHostToHostController {
	private static final Logger LOGGER = LoggerFactory.getLogger(SelfCareHostToHostController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;
	@Autowired
	private SessionHandler sessionHandler;
	@Resource(name = "selfCareHostToHostService")
	private SelfCareHostToHostService selfCareHostToHostService;

	@RequestMapping(value = "/selfCareTransactionList.do")
	public String selfCareTransaction(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		return "payment/selfCare/selfCareTransactionList";
	}

	@RequestMapping(value = "/getSelfCareTransactionList.do")
	public ResponseEntity<List<EgovMap>> getSelfCareTransactionList(@RequestParam Map<String, Object> params, HttpServletRequest request,ModelMap model, SessionVO sessionVO) {

		String[] statusIdList = request.getParameterValues("status");
		 params.put("statusIdList",statusIdList);

		List<EgovMap> result = selfCareHostToHostService.getSelfCareTransactionList(params);;
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selfCareDetailPop.do")
	public String selfCareDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		model.addAttribute("detail", params);
		return "payment/selfCare/selfCareDetailPop";
	}

	@RequestMapping(value = "/getSelfCareTransactionDetails.do")
	public ResponseEntity<List<EgovMap>> getSelfCareTransactionDetails(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		if(CommonUtils.nvl(params.get("prcssStatusId")).equals("") == false) {
			String[] status = params.get("prcssStatusId").toString().split(",");
			 params.put("statusIdList",status);
		}
		List<EgovMap> result = selfCareHostToHostService.getSelfCareTransactionDetails(params);;
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selfCareReportDetailPop.do")
	public String selfCareReportDetailPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		model.addAttribute("detail", params);
		return "payment/selfCare/selfCareReportDetailPop";
	}

	@RequestMapping(value = "/getSelfcareBatchDetailReport.do")
	public ResponseEntity<List<EgovMap>> getSelfcareBatchDetailReport(@RequestParam Map<String, Object> params, HttpServletRequest request,ModelMap model, SessionVO sessionVO) {

		String[] statusIdList = request.getParameterValues("payModeStus");
		 params.put("paymentModeList",statusIdList);
		List<EgovMap> result = selfCareHostToHostService.getSelfcareBatchDetailReport(params);;
		return ResponseEntity.ok(result);
	}
}
