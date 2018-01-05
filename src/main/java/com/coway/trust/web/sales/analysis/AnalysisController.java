package com.coway.trust.web.sales.analysis;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.analysis.AnalysisService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/analysis") 
public class AnalysisController {

	
	@Resource(name = "analysisService")
	private AnalysisService analysisService;
	
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
	
	@RequestMapping(value = "/salesDropOut.do")
	public String salesDropOut() throws Exception{
		
		return "sales/analysis/salesDropOut";
	}
	
	@RequestMapping(value = "/maintanceSession")
	public ResponseEntity<EgovMap> maintanceSession()throws Exception{
		
		EgovMap rtnMap = null;
		
		rtnMap = analysisService.maintanceSession();
		
		return ResponseEntity.ok(rtnMap);
	}
}
