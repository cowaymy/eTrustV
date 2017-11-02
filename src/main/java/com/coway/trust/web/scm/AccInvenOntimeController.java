package com.coway.trust.web.scm;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.scm.AccInvenOntimeService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class AccInvenOntimeController {

private static final Logger LOGGER = LoggerFactory.getLogger(ScmMasterMngmentController.class);
	
	@Autowired
	private AccInvenOntimeService accInvenOntimeService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	// view
	@RequestMapping(value = "/onTimeDelivery.do")
	public String poManager(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/onTimeDelivery";  	
	}  
	
	@RequestMapping(value = "/selectOnTimeMonthly.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOnTimeMonthly(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectOnTimeMonthly_Input : {}", params.toString());
		
		List<EgovMap> selectOnTimeMonthly = accInvenOntimeService.selectOnTimeMonthly(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectOnTimeMonthlyList", selectOnTimeMonthly);

		return ResponseEntity.ok(map);
		
	}	
	
	@RequestMapping(value = "/selectOnTimeWeeklyList.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOnTimeCalculStatus(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectOnTimeWeeklyList_Input : {}", params.toString());
		
		List<EgovMap> selectOnTimeWeeklyList = accInvenOntimeService.selectOnTimeWeeklyList(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectOnTimeWeeklyList", selectOnTimeWeeklyList);
		
		return ResponseEntity.ok(map);
		
	}	
	
	// search btn
	@RequestMapping(value = "/selectOnTimeDeliverySearch.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOnTimeDeliverySearch(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectOnTimeDeliverySearch_Input : {}", params.toString());
		
		List<EgovMap> selectOnTimeWeeklyStartPoint = accInvenOntimeService.selectOnTimeWeeklyStartPoint(params);
		List<EgovMap> selectOnTimeWeeklyList = accInvenOntimeService.selectOnTimeWeeklyList(params);
		List<EgovMap> selectOnTimeCalculStatus = accInvenOntimeService.selectOnTimeCalculStatus(params);
		List<EgovMap> selectOnTimeDeliverySearch = accInvenOntimeService.selectOnTimeDeliverySearch(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectOnTimeWeeklyStartPoint", selectOnTimeWeeklyStartPoint);
		map.put("selectOnTimeWeeklyList", selectOnTimeWeeklyList);
		map.put("selectOnTimeCalculStatusList", selectOnTimeCalculStatus);
		map.put("selectOnTimeDeliveryList", selectOnTimeDeliverySearch);
		
		return ResponseEntity.ok(map);
		
	}	


}
