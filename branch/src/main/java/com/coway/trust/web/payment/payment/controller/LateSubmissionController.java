package com.coway.trust.web.payment.payment.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.model.ReturnMessage;

@Controller
@RequestMapping(value = "/payment")
public class LateSubmissionController {

	//private static final Logger LOGGER = LoggerFactory.getLogger(LateSubmissionController.class);

	/******************************************************
	 * Late Submission Raw 
	 *****************************************************/	
	/**
	 * Late Submission Raw 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initLateSubmission.do")
	public String initLateSubmission(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/payment/lateSubmissionRaw";
	}
	
}
