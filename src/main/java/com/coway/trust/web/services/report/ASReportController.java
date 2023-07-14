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
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT --------------------------------------------------------------------------------------------
 * 26/07/2019 ONGHC 1.0.1 - Add Recall Status 17/09/2019 ONGHC 1.0.2 - Amend asLedgerPop 03/10/2019 ONGHC 1.0.3 - Add AS
 * Raw Report for 31Days 25/01/2021 KV 1.0.4 - Add AOAS Data Listing- Ombak
 *********************************************************************************************/

@Controller
@RequestMapping(value = "/services/as/report")
public class ASReportController {
	private static final Logger logger = LoggerFactory.getLogger(ASReportController.class);

	@Resource(name = "ASReportService")
	private ASReportService ASReportService;

	@RequestMapping(value = "/asReportPop.do")
	public String asReportPop(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap orderNum = ASReportService.selectOrderNum();
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
				SalesConstants.DEFAULT_DATE_FORMAT1);
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
	public ResponseEntity<List<EgovMap>> selectMemberCode(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		/*
		 * BY KV - branch - CT
		 */
		List<EgovMap> memberCode = ASReportService.selectMemberCodeList(params);
		// model.addAttribute("branchList", branchList);
		logger.debug("memberCode {}", memberCode);
		return ResponseEntity.ok(memberCode);
	}

	@RequestMapping(value = "/selectMemberCodeList2.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemberCode2(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);

		String search = (String) params.get("groupCode");
		String[] searchValue = search.split("∈");

		params.put("groupCode", searchValue);
		/*
		 * BY KV - branch - CT
		 */
		List<EgovMap> memberCode = ASReportService.selectMemberCodeList2(params);
		// model.addAttribute("branchList", branchList);
		logger.debug("memberCode {}", memberCode);
		return ResponseEntity.ok(memberCode);
	}

	@RequestMapping(value = "/asRawDataPop.do")
	public String asRawDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("ind", params.get("ind"));
		return "services/as/asRawDataPop";
	}

	@RequestMapping(value = "/asYellowSheetPop.do")
	public String asYellowSheetPop(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> asYsTyp = ASReportService.selectAsYsTyp();
		model.addAttribute("asYsTyp", asYsTyp);

		List<EgovMap> asYsAge = ASReportService.selectAsYsAge();
		model.addAttribute("asYsAge", asYsAge);
		return "services/as/asYellowSheetPop";
	}

	/* KV */
	@RequestMapping(value = "/aoAsDataListingPop.do")
	public String aoAsDataListingPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		params.put("memberLevel", sessionVO.getMemberLevel());
		params.put("userName", sessionVO.getUserName());
		params.put("userType", sessionVO.getUserTypeId());

		List<EgovMap> branchList = ASReportService.selectBranchList(params);

		logger.debug("=======================================================================================");
		logger.debug("==============aoAsDataListingPop params{} ", params);
		logger.debug("=======================================================================================");

		model.addAttribute("branchList", branchList);
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("memberLevel", sessionVO.getMemberLevel());
		model.addAttribute("userType", sessionVO.getUserTypeId());

		return "services/as/aoAsDataListingPop";
	}

	@RequestMapping(value = "/asLogBookListPop.do")
	public String asPerformanceReportPop(@RequestParam Map<String, Object> params, ModelMap model) {

		List<EgovMap> asLogBookTyp = ASReportService.selectAsLogBookTyp();
		model.addAttribute("asLogBookTyp", asLogBookTyp);

		List<EgovMap> asLogBookGrp = ASReportService.selectAsLogBookGrp();
		model.addAttribute("asLogBookGrp", asLogBookGrp);

		return "services/as/asLogBookListPop";
	}

	@RequestMapping(value = "/asSummaryListPop.do")
	public String asSummaryListPop(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> asSumTyp = ASReportService.selectAsSumTyp();
		model.addAttribute("asSumTyp", asSumTyp);

		List<EgovMap> asSumStat = ASReportService.selectAsSumStat();
		model.addAttribute("asSumStat", asSumStat);

		List<EgovMap> asSumGrp = ASReportService.selectAsLogBookGrp();
		model.addAttribute("asSumGrp", asSumGrp);
		return "services/as/asSummaryListPop";
	}

	@RequestMapping(value = "/asLedgerPop.do")
	public String asLedgerPop(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("params {}", params);

		model.addAttribute("ASNo", params.get("ASNO"));
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
	public ResponseEntity<List<EgovMap>> getViewLedger(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
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
	public ResponseEntity<List<EgovMap>> selectMemCodeList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> memberCode = ASReportService.selectMemCodeList();
		// model.addAttribute("branchList", branchList);
		logger.debug("memberCode {}", memberCode);
		return ResponseEntity.ok(memberCode);
	}

	@RequestMapping(value = "/selectProductTypeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductTypeList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		List<EgovMap> productList = ASReportService.selectProductTypeList();
		return ResponseEntity.ok(productList);
	}

	@RequestMapping(value = "/selectProductList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProductCodeList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		List<EgovMap> productList = ASReportService.selectProductList();
		return ResponseEntity.ok(productList);
	}

	@RequestMapping(value = "/selectDefectTypeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDefectTypeList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		List<EgovMap> defectTypeList = ASReportService.selectDefectTypeList();
		return ResponseEntity.ok(defectTypeList);
	}

	@RequestMapping(value = "/selectDefectRmkList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDefectRmkList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		List<EgovMap> defectRmkList = ASReportService.selectDefectRmkList();
		return ResponseEntity.ok(defectRmkList);
	}

	@RequestMapping(value = "/selectDefectDescList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDefectDescList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		List<EgovMap> defectDescList = ASReportService.selectDefectDescList();
		return ResponseEntity.ok(defectDescList);
	}

	@RequestMapping(value = "/selectDefectDescSymptomList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDefectDescSymptomList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) {
		List<EgovMap> defectDescSymptomList = ASReportService.selectDefectDescSymptomList();
		return ResponseEntity.ok(defectDescSymptomList);
	}

}
