package com.coway.trust.web.services.report;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.report.ASReportService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/as/report")
public class ASReportController {
	private static final Logger logger = LoggerFactory.getLogger(ASReportController.class);

	@Resource(name = "ASReportService")
	private ASReportService ASReportService;


	@RequestMapping(value = "/asReportPop.do")
	public String asReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap orderNum = ASReportService.selectOrderNum();
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		model.addAttribute("orderNum", orderNum);
		// 호출될 화면
		return "services/as/asReportPop";
	}

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMemberCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemberCode( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		/*
		 *BY KV - branch - CT
		 */
		List<EgovMap> memberCode = ASReportService.selectMemberCodeList(params);
		//model.addAttribute("branchList", branchList);
		logger.debug("memberCode {}", memberCode);
		return ResponseEntity.ok(memberCode);
	}

	@RequestMapping(value = "/asRawDataPop.do")
	public String asRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/as/asRawDataPop";
	}

	@RequestMapping(value = "/asYellowSheetPop.do")
	public String asYellowSheetPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/as/asYellowSheetPop";
	}

	@RequestMapping(value = "/asLogBookListPop.do")
	public String asPerformanceReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/as/asLogBookListPop";
	}

	@RequestMapping(value = "/asSummaryListPop.do")
	public String asSummaryListPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/as/asSummaryListPop";
	}

	@RequestMapping(value = "/asLedgerPop.do")
	public String asLedgerPop(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("params {}", params);

		model.addAttribute("ASRNo", params.get("ASRNO"));
		// 호출될 화면
		return "services/as/asLedgerPop";
	}


	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getViewLedger.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getViewLedger( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		List<EgovMap> viewLedger = ASReportService.selectViewLedger(params);
		return ResponseEntity.ok(viewLedger);
	}


	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMemCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemCodeList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> memberCode = ASReportService.selectMemCodeList();
		//model.addAttribute("branchList", branchList);
		logger.debug("memberCode {}", memberCode);
		return ResponseEntity.ok(memberCode);
	}

}
