package com.coway.trust.web.sales.analysis;

import java.util.List;
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

	@RequestMapping(value = "/salesAnalysis.do")
	public String salesAnalysis() throws Exception{

		return "sales/analysis/salesAnalysis";
	}

	@RequestMapping(value = "/maintanceSession")
	public ResponseEntity<EgovMap> maintanceSession()throws Exception{

		EgovMap rtnMap = null;

		rtnMap = analysisService.maintanceSession();

		return ResponseEntity.ok(rtnMap);
	}

	@RequestMapping(value = "/predictiveLifetimeValue.do")
	public String pltv(ModelMap model) throws Exception {

		String maxAccYm = analysisService.selectMaxAccYm();
		model.put("maxAccYm", maxAccYm);

		return "sales/analysis/predictiveLifetimeValue";
	}

	@RequestMapping(value = "/selectPltvProductCodeList")
	public ResponseEntity<List<EgovMap>> selectPltvProductCodeList(@RequestParam Map<String, Object> params) throws Exception {

		List<EgovMap> productList = analysisService.selectPltvProductCodeList(params);

		return ResponseEntity.ok(productList);
	}

	 @RequestMapping(value = "/selectPltvProductCategoryList")
	  public ResponseEntity<List<EgovMap>> selectPltvProductCategoryList(@RequestParam Map<String, Object> params) throws Exception {

	    List<EgovMap> productCategoryList = analysisService.selectPltvProductCategoryList(params);

	    return ResponseEntity.ok(productCategoryList);
	  }
}
