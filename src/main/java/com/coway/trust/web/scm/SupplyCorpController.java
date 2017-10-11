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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.SalesPlanMngementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class SupplyCorpController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SupplyCorpController.class);
	//private static final Logger LOGGER  = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SalesPlanMngementService salesPlanMngementService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/supplyPlanSummary.do")
	public String login(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/supplyPlanSummaryView";  
	}  
	
	@RequestMapping(value = "/selectSupplyCorpListSearch.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSalesPlanMngmentList(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectSupplyCorpList_InpParams : {}", params.toString());
/*		LOGGER.debug("stkCodes : {}", stkCodes.toString());
		
		if (stkCodes != null) {
			for (Integer id : stkCodes) {
				LOGGER.debug("stkCode : {}", id);
			}
			
			params.put("stkCodes", stkCodes);
		}
		
		List<EgovMap> planInfo = salesPlanMngementService.selectPlanId(params);		
		String selectPlanMonth = String.valueOf(planInfo.get(0).get("planMonth"));		
		((Map<String, Object>) params).put("selectPlanMonth", selectPlanMonth);	
		
		LOGGER.debug("addMonth_Param : {}", params.toString());*/
		
		List<EgovMap> selectSupplyCorpList = salesPlanMngementService.selectSupplyCorpList(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectSupplyCorpList", selectSupplyCorpList);

		return ResponseEntity.ok(map);
		
	}

}
