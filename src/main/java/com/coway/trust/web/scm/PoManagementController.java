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

import com.coway.trust.biz.scm.PoMngementService;
import com.coway.trust.biz.scm.SalesPlanMngementService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class PoManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PoManagementController.class);
	//private static final Logger LOGGER  = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SalesPlanMngementService salesPlanMngementService;
	
	@Autowired
	private PoMngementService poMngementService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	// PO Management - PO Issue
	@RequestMapping(value = "/poManager.do")
	public String poManager(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/poManagement";  	
	}  
	
	// search btn
	@RequestMapping(value = "/selectScmPrePoItemView.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSupplyPlanCDCSearch(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectScmPrePoItemView_Input : {}", params.toString());
		
		List<EgovMap> selectScmPrePoItemViewList = poMngementService.selectScmPrePoItemView(params);
		List<EgovMap> selectScmPoViewList = poMngementService.selectScmPoView(params);
		List<EgovMap> selectScmPoStatusCntList = poMngementService.selectScmPoStatusCnt(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectScmPrePoItemViewList", selectScmPrePoItemViewList);
		map.put("selectScmPoViewList", selectScmPoViewList);
		map.put("selectScmPoStatusCntList", selectScmPoStatusCntList);

		return ResponseEntity.ok(map);
		
	}	
	
	// 
	@RequestMapping(value = "/selectScmPoView.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectScmPoView(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectScmPoView_Input : {}", params.toString());
		
		List<EgovMap> selectScmPoViewList = poMngementService.selectScmPoView(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectScmPoViewList", selectScmPoViewList);
		
		return ResponseEntity.ok(map);
		
	}	

}
