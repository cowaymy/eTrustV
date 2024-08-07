package com.coway.trust.web.common;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.ChartService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/chart")
public class ChartController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ChartController.class);

	@Autowired
	private ChartService chartService;

	@RequestMapping(value = "/salesKeyInAnalysisPop.do")
	public String salesKeyInAnalysisPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("salesKeyInAnalysisPop");
		return "chart/salesKeyInAnalysisPop";
	}

	@RequestMapping(value = "/netSalesChartPop.do")
	public String netSalesChartPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("netSalesChartPop");
		return "chart/netSalesChartPop";
	}

	@RequestMapping(value = "/getSalesKeyInAnalysis.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSalesKeyInAnalysis(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		params.put("pYear", CommonUtils.nvl((String) params.get("pYear"), "2017"));

		List<EgovMap> list = chartService.getSalesKeyInAnalysis(params);
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/getNetSalesChart.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getNetSalesChart(@RequestParam Map<String, Object> params, Model model)
			throws Exception {

		params.put("pYear", CommonUtils.nvl((String) params.get("pYear"), "2017"));

		List<EgovMap> list = chartService.getNetSalesChart(params);
		return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/wpSalesFigurePop.do")
    public String wpSalesFigurePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("wpSalesFigurePop");
        return "chart/wpSalesFigurePop";
    }

	@RequestMapping(value = "/getSalesMonth.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSalesMonth(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
	    List<EgovMap> salesMonth = chartService.getSalesMonth(params);
	    return ResponseEntity.ok(salesMonth);
	}

    @RequestMapping(value = "/getWpSales.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> getWpSales(@RequestParam Map<String, Object> params, SessionVO sessionVO) {
        List<EgovMap> wpSales = chartService.getWpSales(params);
        return ResponseEntity.ok(wpSales);
    }
}
