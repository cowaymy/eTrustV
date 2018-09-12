package com.coway.trust.web.scm;

import java.util.ArrayList;
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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.SupplyPlanManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class SupplyPlanManagementController {
	private static final Logger LOGGER = LoggerFactory.getLogger(SupplyPlanManagementController.class);
	
	@Autowired
	private SupplyPlanManagementService supplyPlanManagementService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@RequestMapping(value = "/supplyPlanManager.do")
	public String login(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/supplyPlanManagement";
	}
/*	@RequestMapping(value = "/selectScmYear.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmYear(@RequestParam Map<String, Object> params) {
		LOGGER.debug("selectScmYear : {}", params.toString());
		
		List<EgovMap> selectScmYear = supplyPlanManagementService.selectScmYear(params);
		
		return ResponseEntity.ok(selectScmYear);
	}
	@RequestMapping(value = "/selectScmWeekByYear.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmWeekByYear(@RequestParam Map<String, Object> params) {
		LOGGER.debug("selectScmWeekByYear : {}", params.toString());
		
		List<EgovMap> selectScmWeekByYear = supplyPlanManagementService.selectScmWeekByYear(params);
		
		return ResponseEntity.ok(selectScmWeekByYear);
	}
	@RequestMapping(value = "/selectScmCdc.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmCdc(@RequestParam Map<String, Object> params) {
		LOGGER.debug("selectScmCdc : {}", params.toString());
		
		List<EgovMap> selectScmCdc	= supplyPlanManagementService.selectScmCdc(params);
		
		return ResponseEntity.ok(selectScmCdc);
	}
	@RequestMapping(value = "/selectScmStockType.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmStockType(@RequestParam Map<String, Object> params) {
		LOGGER.debug("selectScmStockType : {}", params.toString());
		
		List<EgovMap> selectScmStockType	= supplyPlanManagementService.selectScmStockType(params);
		
		return ResponseEntity.ok(selectScmStockType);
	}
	@RequestMapping(value = "/selectScmStockCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmStockCode(@RequestParam Map<String, Object> params) {
		LOGGER.debug("selectScmStockCode : {}", params.toString());
		
		List<EgovMap> selectScmStockCode	= supplyPlanManagementService.selectScmStockCode(params);
		
		return ResponseEntity.ok(selectScmStockCode);
	}*/
}