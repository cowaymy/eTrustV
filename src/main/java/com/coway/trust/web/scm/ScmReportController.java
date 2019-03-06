package com.coway.trust.web.scm;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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

import com.coway.trust.biz.scm.ScmReportService;
import com.coway.trust.biz.scm.ScmCommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmReportController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ScmReportController.class);
	
	@Autowired
	private ScmCommonService scmCommonService;
	@Autowired
	private ScmReportService scmReportService;
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/*
	 * View
	 */
	//	Business Plan Report
	@RequestMapping(value = "/businessPlanReport.do")
	public String businessPlanReportView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/businessPlanReport";
	}
	//	Sales Plan Accuracy
	@RequestMapping(value = "/salesPlanAccuracy.do")
	public String salesPlanAccuracyView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/salesPlanAccuracy";
	}
	//	Ontime Delivery Report
	@RequestMapping(value = "/ontimeDeliveryReport.do")
	public String ontimeDeliveryReportView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/ontimeDeliveryReport";
	}
	//	Inventory Report
	/*@RequestMapping(value = "/inventoryReport.do")
	public String inventoryReportView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/inventoryReport";
	}*/
	
	/*
	 * Business Plan Report
	 */
	@RequestMapping(value = "/selectPlanVer.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPlanVer(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectPlanVer : {}", params.toString());
		
		List<EgovMap> selectPlanVer	= scmReportService.selectPlanVer(params);
		return ResponseEntity.ok(selectPlanVer);
	}
	@RequestMapping(value = "/selectBusinessPlanReport.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectBusinessPlanReport(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectBusinessPlanReport : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		List<EgovMap> selectBusinessPlanSummary	= scmReportService.selectBusinessPlanSummary(params);
		List<EgovMap> selectBusinessPlanDetail	= scmReportService.selectBusinessPlanDetail(params);
		
		map.put("selectBusinessPlanSummary", selectBusinessPlanSummary);
		map.put("selectBusinessPlanDetail", selectBusinessPlanDetail);
		
		return	ResponseEntity.ok(map);
	}
	
	/*
	 * Sales Plan Accuracy
	 */
	@RequestMapping(value = "/selectSalesAccuracyDetailHeader.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSalesAccuracyDetailHeader(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectSalesAccuracyDetailHeader : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		List<EgovMap> selectSalesAccuracyWeeklyDetailHeader		= scmReportService.selectSalesAccuracyWeeklyDetailHeader(params);
		List<EgovMap> selectSalesAccuracyMonthlyDetailHeader	= scmReportService.selectSalesAccuracyMonthlyDetailHeader(params);
		
		map.put("selectSalesAccuracyWeeklyDetailHeader", selectSalesAccuracyWeeklyDetailHeader);
		map.put("selectSalesAccuracyMonthlyDetailHeader", selectSalesAccuracyMonthlyDetailHeader);
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectSalesAccuracy.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSalesAccuracy(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectSalesAccuracy : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> weeklyParams	= new HashMap<>();
		Map<String, Object> monthlyParams	= new HashMap<>();
		
		List<EgovMap> selectSalesPlanAccuracyWeeklySummary	= scmReportService.selectSalesPlanAccuracyWeeklySummary(params);
		List<EgovMap> selectSalesPlanAccuracyMonthlySummary	= scmReportService.selectSalesPlanAccuracyMonthlySummary(params);
		
		//	Weekly Detail
		List<EgovMap> selectWeekly16Week	= scmReportService.selectWeekly16Week(params);
		
		//	조회결과는 항상 17 ROW
		//	i = 0 -> 클릭한 Summary Grid의 주차
		//	i = 1 -> Detail Grid의 가장 처음(왼쪽) 주차
		//	...
		//	i = 16 -> Detail Grid의 가장 마지막(오른쪽) 주차
		for ( int i = 0 ; i < selectWeekly16Week.size() ; i++ ) {
			weeklyParams.put("planYear" + (i + 1), Integer.parseInt(selectWeekly16Week.get(i).get("scmYear").toString()));
			weeklyParams.put("planWeek" + (i + 1), Integer.parseInt(selectWeekly16Week.get(i).get("scmWeek").toString()));
		}
		weeklyParams.put("year", Integer.parseInt(selectWeekly16Week.get(0).get("scmYear").toString()));
		weeklyParams.put("week", Integer.parseInt(selectWeekly16Week.get(0).get("scmWeek").toString()));
		weeklyParams.put("ordFrom", Integer.parseInt(selectWeekly16Week.get(0).get("ordFrom").toString()));
		weeklyParams.put("ordTo", Integer.parseInt(selectWeekly16Week.get(0).get("ordTo").toString()));
		weeklyParams.put("team", params.get("team").toString());
		weeklyParams.put("weeklyYear", Integer.parseInt(params.get("weeklyYear").toString()));
		weeklyParams.put("weeklyWeek", Integer.parseInt(params.get("weeklyWeek").toString()));
		List<EgovMap> selectWeeklyStartEnd	= scmReportService.selectWeeklyStartEnd(weeklyParams);
		
		weeklyParams.put("startWeek", selectWeeklyStartEnd.get(0).get("startWeek").toString());
		weeklyParams.put("endWeek", selectWeeklyStartEnd.get(0).get("endWeek").toString());
		LOGGER.debug("selectSalesAccuracy Weekly : {}", weeklyParams.toString());
		List<EgovMap> selectSalesPlanAccuracyWeeklyDetail	= scmReportService.selectSalesPlanAccuracyWeeklyDetail(weeklyParams);
		
		//	Monthly Detail
		List<EgovMap> selectMonthly16Week	= scmReportService.selectMonthly16Week(params);
		
		//	조회결과는 항상 16 ROW
		//	planYear, planWeek 파라미터 세팅
		for ( int i = 0 ; i < selectMonthly16Week.size() ; i++ ) {
			monthlyParams.put("planYear" + (i + 1), Integer.parseInt(selectMonthly16Week.get(i).get("scmYear").toString()));
			monthlyParams.put("planWeek" + (i + 1), Integer.parseInt(selectMonthly16Week.get(i).get("scmWeek").toString()));
		}
		monthlyParams.put("year", Integer.parseInt(selectMonthly16Week.get(0).get("scmYear").toString()));
		monthlyParams.put("week", Integer.parseInt(selectMonthly16Week.get(0).get("scmWeek").toString()));
		monthlyParams.put("ordFrom", Integer.parseInt(selectMonthly16Week.get(0).get("ordFrom").toString()));
		monthlyParams.put("ordTo"  , Integer.parseInt(selectMonthly16Week.get(0).get("ordTo").toString()));
		monthlyParams.put("team", params.get("team").toString());
		monthlyParams.put("monthlyYear", Integer.parseInt(params.get("monthlyYear").toString()));
		monthlyParams.put("monthlyMonth", Integer.parseInt(params.get("monthlyMonth").toString()));
		List<EgovMap> selectMonthlyStartEnd	= scmReportService.selectMonthlyStartEnd(monthlyParams);
		
		monthlyParams.put("startWeek", selectMonthlyStartEnd.get(0).get("startWeek").toString());
		monthlyParams.put("endWeek", selectMonthlyStartEnd.get(0).get("endWeek").toString());
		LOGGER.debug("selectSalesAccuracy Monthly : {}", monthlyParams.toString());
		List<EgovMap> selectSalesPlanAccuracyMonthlyDetail	= scmReportService.selectSalesPlanAccuracyMonthlyDetail(monthlyParams);
		
		map.put("selectSalesPlanAccuracyWeeklySummary", selectSalesPlanAccuracyWeeklySummary);
		map.put("selectSalesPlanAccuracyMonthlySummary", selectSalesPlanAccuracyMonthlySummary);
		map.put("selectSalesPlanAccuracyWeeklyDetail", selectSalesPlanAccuracyWeeklyDetail);
		map.put("selectSalesPlanAccuracyMonthlyDetail", selectSalesPlanAccuracyMonthlyDetail);
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectSalesAccuracyDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSalesAccuracyDetail(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectSalesAccuracyDetail : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> weeklyParams	= new HashMap<>();
		Map<String, Object> monthlyParams	= new HashMap<>();
		
		//	Weekly Detail
		List<EgovMap> selectWeekly16Week	= scmReportService.selectWeekly16Week(params);
		
		//	조회결과는 항상 17 ROW
		//	i = 0 -> 클릭한 Summary Grid의 주차
		//	i = 1 -> Detail Grid의 가장 처음(왼쪽) 주차
		//	...
		//	i = 16 -> Detail Grid의 가장 마지막(오른쪽) 주차
		for ( int i = 0 ; i < selectWeekly16Week.size() ; i++ ) {
			weeklyParams.put("planYear" + (i + 1), Integer.parseInt(selectWeekly16Week.get(i).get("scmYear").toString()));
			weeklyParams.put("planWeek" + (i + 1), Integer.parseInt(selectWeekly16Week.get(i).get("scmWeek").toString()));
		}
		weeklyParams.put("year", Integer.parseInt(selectWeekly16Week.get(0).get("scmYear").toString()));
		weeklyParams.put("week", Integer.parseInt(selectWeekly16Week.get(0).get("scmWeek").toString()));
		weeklyParams.put("ordFrom", Integer.parseInt(selectWeekly16Week.get(0).get("ordFrom").toString()));
		weeklyParams.put("ordTo"  , Integer.parseInt(selectWeekly16Week.get(0).get("ordTo").toString()));
		weeklyParams.put("team", params.get("team").toString());
		weeklyParams.put("weeklyYear", Integer.parseInt(params.get("weeklyYear").toString()));
		weeklyParams.put("weeklyWeek", Integer.parseInt(params.get("weeklyWeek").toString()));
		List<EgovMap> selectWeeklyStartEnd	= scmReportService.selectWeeklyStartEnd(weeklyParams);
		
		weeklyParams.put("startWeek", selectWeeklyStartEnd.get(0).get("startWeek").toString());
		weeklyParams.put("endWeek", selectWeeklyStartEnd.get(0).get("endWeek").toString());
		LOGGER.debug("selectSalesAccuracyDetail Weekly : {}", weeklyParams.toString());
		List<EgovMap> selectSalesPlanAccuracyWeeklyDetail	= scmReportService.selectSalesPlanAccuracyWeeklyDetail(weeklyParams);
		
		//	Monthly Detail
		List<EgovMap> selectMonthly16Week	= scmReportService.selectMonthly16Week(params);
		
		//	조회결과는 항상 16 ROW
		//	1 ~ 16 ROW 전부 ORD_FROM, ORD_TO는 같은 값
		for ( int i = 0 ; i < selectMonthly16Week.size() ; i++ ) {
			monthlyParams.put("planYear" + (i + 1), Integer.parseInt(selectMonthly16Week.get(i).get("scmYear").toString()));
			monthlyParams.put("planWeek" + (i + 1), Integer.parseInt(selectMonthly16Week.get(i).get("scmWeek").toString()));
		}
		monthlyParams.put("year", Integer.parseInt(selectMonthly16Week.get(0).get("scmYear").toString()));
		monthlyParams.put("week", Integer.parseInt(selectMonthly16Week.get(0).get("scmWeek").toString()));
		monthlyParams.put("ordFrom", Integer.parseInt(selectMonthly16Week.get(0).get("ordFrom").toString()));
		monthlyParams.put("ordTo"  , Integer.parseInt(selectMonthly16Week.get(0).get("ordTo").toString()));
		monthlyParams.put("team", params.get("team").toString());
		monthlyParams.put("monthlyYear", Integer.parseInt(params.get("monthlyYear").toString()));
		monthlyParams.put("monthlyMonth", Integer.parseInt(params.get("monthlyMonth").toString()));
		List<EgovMap> selectMonthlyStartEnd	= scmReportService.selectMonthlyStartEnd(weeklyParams);
		
		monthlyParams.put("startWeek", selectMonthlyStartEnd.get(0).get("startWeek").toString());
		monthlyParams.put("endWeek", selectMonthlyStartEnd.get(0).get("endWeek").toString());
		LOGGER.debug("selectSalesAccuracyDetail Monthly : {}", monthlyParams.toString());
		List<EgovMap> selectSalesPlanAccuracyMonthlyDetail	= scmReportService.selectSalesPlanAccuracyMonthlyDetail(monthlyParams);
		
		map.put("selectSalesPlanAccuracyWeeklyDetail", selectSalesPlanAccuracyWeeklyDetail);
		map.put("selectSalesPlanAccuracyMonthlyDetail", selectSalesPlanAccuracyMonthlyDetail);
		
		return	ResponseEntity.ok(map);
	}
	
	/*
	 * On-Time Delivery Report
	 */
	@RequestMapping(value = "/selectOntimeDelivery.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOntimeDelivery(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectOntimeDelivery : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		List<EgovMap> selectOntimeDeliverySummary	= scmReportService.selectOntimeDeliverySummary(params);
		List<EgovMap> selectOntimeDeliveryDetail	= scmReportService.selectOntimeDeliveryDetail(params);
		
		map.put("selectOntimeDeliverySummary", selectOntimeDeliverySummary);
		map.put("selectOntimeDeliveryDetail", selectOntimeDeliveryDetail);
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectOntimeDeliveryDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOntimeDeliveryDetail(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectOntimeDeliveryDetail : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		List<EgovMap> selectOntimeDeliveryDetail	= scmReportService.selectOntimeDeliveryDetail(params);
		
		map.put("selectOntimeDeliveryDetail", selectOntimeDeliveryDetail);
		
		return	ResponseEntity.ok(map);
	}
	
	/*
	 * Inventory Report
	 */
}