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
import com.coway.trust.biz.scm.ScmMasterMngMentService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmMasterMngmentController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmMasterMngmentController.class);
	
	@Autowired
	private ScmMasterMngMentService scmMasterMngMentService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	// view
	@RequestMapping(value = "/scmMasterManagement.do")
	public String masterMngmentView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/scmMasterManagement";  	
	}  

	// search btn
	@RequestMapping(value = "/scmMasterManagement.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectMasterMngment(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("scmMasterMngMentList_Input : {}", params.toString());
		
		//List<EgovMap> scmMasterMngMentServiceList = scmMasterMngMentService.selectMasterMngment(params);
		//List<EgovMap> selectInterfaceLastState = scmMasterMngMentService.selectInterfaceLastState(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		//map.put("scmMasterMngMentServiceList", scmMasterMngMentServiceList);
		//map.put("selectInterfaceLastState", selectInterfaceLastState);

		return ResponseEntity.ok(map);
		
	}	
	
	/*****************************************
	 *   CDC WareHouse MAPPING
	 *****************************************/
	// view
	@RequestMapping(value = "/cdcWhMappingManager.do")
	public String cdcWareHouseMappingView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/cdcWhMappingManager";  	
	}  	
	
	
	/*****************************************
	 *   Business Plan Manager
	 *****************************************/
	// view
	@RequestMapping(value = "/businessPlanManager.do")
	public String bizPlanManagerView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/businessPlanManager";  	
	}  	


}
