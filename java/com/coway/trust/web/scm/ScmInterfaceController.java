package com.coway.trust.web.scm;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.scm.PoMngementService;
import com.coway.trust.biz.scm.SalesPlanMngementService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmInterfaceController {

private static final Logger LOGGER = LoggerFactory.getLogger(ScmMasterMngmentController.class);
	
	@Autowired
	private PoMngementService poMngementService;
	
	@Autowired
	private SalesPlanMngementService salesPlanMngementService;
	
	// view
	@RequestMapping(value = "/interfaceNoUse.do")
	public String poManager(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/interface";  	
	}  
	
	// search btn
	@RequestMapping(value = "/selectInterfaceSearch.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectInterfaceList(@RequestBody Map<String, Object> params) 
	{
		LOGGER.debug("selectInterfaceList_Input : {}", params.toString());
		
		List<EgovMap> selectInterfaceList = poMngementService.selectInterfaceList(params);
		List<EgovMap> selectInterfaceLastState = poMngementService.selectInterfaceLastState(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectInterfaceList", selectInterfaceList);
		map.put("selectInterfaceLastState", selectInterfaceLastState);

		return ResponseEntity.ok(map);
		
	}	
	
	@RequestMapping(value = "/selectComboInterfaceDate.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectComboInterfaceDate(@RequestParam Map<String, Object> params) {
		// Code Master Id : 351
		LOGGER.debug("selectComboInterfaceDate : {}", params.toString());
		
		List<EgovMap> selectComboInterfaceDate = salesPlanMngementService.selectComboSupplyCDC(params);
		return ResponseEntity.ok(selectComboInterfaceDate);
	}
	


}
