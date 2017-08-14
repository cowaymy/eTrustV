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
public class DailyCollectionController {

	private static final Logger Logger = LoggerFactory.getLogger(DailyCollectionController.class);

	/******************************************************
	 * Daily Collection Raw 
	 *****************************************************/	
	/**
	 * Daily Collection Raw 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initDailyCollection.do")
	public String initDailyCollection(@RequestParam Map<String, Object> params, ModelMap model) {
		return "payment/payment/dailyCollectionRaw";
	}
	
}
