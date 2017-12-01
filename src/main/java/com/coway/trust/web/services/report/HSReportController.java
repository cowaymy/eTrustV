package com.coway.trust.web.services.report;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.services.report.HSReportService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/bs/report")
public class HSReportController {
	private static final Logger logger = LoggerFactory.getLogger(HSReportController.class);

	@Resource(name = "HSReportService")
	private HSReportService HSReportService;
	
	@RequestMapping(value = "/hsCountForecastListingPop.do")
	public String hsCountForecastListingPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/bs/hsCountForecastListingPop";
	}
	
	@RequestMapping(value = "/hsReportGroupPop.do")
	public String hsReportGroupPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/bs/hsReportGroupPop";
	}
	
	@RequestMapping(value = "/hsReportSinglePop.do")
	public String hsReportSinglePop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/bs/hsReportSinglePop";
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectHSReportSingle.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHSReportSingle(@RequestParam Map<String, Object> params, ModelMap model) {
		
		List<EgovMap>  HSReportSingle = HSReportService.selectHSReportSingle(params);
		logger.debug("HSReportSingle {}", HSReportSingle);
		return ResponseEntity.ok(HSReportSingle);
	}
}
