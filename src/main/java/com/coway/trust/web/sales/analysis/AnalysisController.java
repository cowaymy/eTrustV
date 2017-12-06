package com.coway.trust.web.sales.analysis;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value = "/sales/analysis") 
public class AnalysisController {

	
	@RequestMapping(value = "/moveAccSlaesKeyIn.do")
	public String moveAccSlaesKeyIn (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		return "sales/analysis/accSalesKeyIn";
	}
	
	@RequestMapping(value = "/moveAutoDebitAndAging.do")
	public String moveAutoDebitAndAging(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/analysis/autoDebitAndAging";
	}
	
	@RequestMapping(value = "/moveAccmulated.do")
	public String moveAccmulated (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		return "sales/analysis/accumulated";
	}
}
