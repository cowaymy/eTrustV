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
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.AppConstants;
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
	@RequestMapping(value = "/salesPlanAccuracyMasterPopup.do")
	public String salesPlanAccuracyMasterPopup(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		model.addAttribute("params", params);
		
		return	"/scm/salesPlanAccuracyMasterPopup";
	}
	/*
	@RequestMapping(value = "/supplyPlanPsi1Pop.do")
	public String supplyPlanPsi1Pop(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		
		LOGGER.debug("supplyPlanPsi1Pop : {}", params.toString());
		
		//	POPUP으로 넘길 파라미터
		model.addAttribute("params", params);
		
		return "/scm/supplyPlanPsi1Pop";
	}
	*/
	//	Ontime Delivery Report
	@RequestMapping(value = "/ontimeDeliveryReport.do")
	public String ontimeDeliveryReportView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/ontimeDeliveryReport";
	}
	@RequestMapping(value = "/ontimeDeliveryReportPopup.do")
	public String ontimeDeliveryReportPopup(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		model.addAttribute("params", params);
		
		return	"/scm/ontimeDeliveryReportPopup";
	}
	//	Inventory Report
	@RequestMapping(value = "/inventoryReport.do")
	public String inventoryReportView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/inventoryReport";
	}
	//	Aging Inventory
	@RequestMapping(value = "/agingInventory.do")
	public String agingInventory(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/agingInventory";
	}
	
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
		List<EgovMap> selectBusinessPlanDetail1	= scmReportService.selectBusinessPlanDetail1(params);
		
		map.put("selectBusinessPlanSummary", selectBusinessPlanSummary);
		map.put("selectBusinessPlanDetail", selectBusinessPlanDetail);
		map.put("selectBusinessPlanDetail1", selectBusinessPlanDetail1);
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectBusinessPlanReportDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectBusinessPlanReportDetail(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectBusinessPlanReportDetail : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		List<EgovMap> selectBusinessPlanDetail	= scmReportService.selectBusinessPlanDetail(params);
		List<EgovMap> selectBusinessPlanDetail1	= scmReportService.selectBusinessPlanDetail1(params);
		
		map.put("selectBusinessPlanDetail", selectBusinessPlanDetail);
		map.put("selectBusinessPlanDetail1", selectBusinessPlanDetail1);
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/saveBusinessPlanAll.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveBusinessPlanAll(@RequestBody Map<String, List<Map<String, Object>>> params,	SessionVO sessionVO) {
		
		LOGGER.debug("saveBusinessPlanAll : {}", params.toString());
		
		List<Map<String, Object>> allList	= params.get(AppConstants.AUIGRID_ALL);
		int totCnt	= scmReportService.saveBusinessPlanAll(allList, sessionVO);
		
		ReturnMessage message = new ReturnMessage();
		
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/saveBusinessPlan.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveBusinessPlan(@RequestBody Map<String, List<Map<String, Object>>> params,	SessionVO sessionVO) {
		
		LOGGER.debug("saveBusinessPlan : {}", params.toString());
		
		List<Map<String, Object>> updList	= params.get(AppConstants.AUIGRID_UPDATE);
		int totCnt	= scmReportService.saveBusinessPlan(updList, sessionVO);
		
		ReturnMessage message = new ReturnMessage();
		
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	/*
	 * Sales Plan Accuracy
	 */
	@RequestMapping(value = "/selectSalesPlanAccuracyDetailHeader.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSalesPlanAccuracyDetailHeader(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectSalesPlanAccuracyDetailHeader : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		if ( "1".equals(params.get("gbn").toString()) ) {
			List<EgovMap> selectSalesPlanAccuracyWeeklyDetailHeader	= scmReportService.selectSalesPlanAccuracyWeeklyDetailHeader(params);
			map.put("selectSalesPlanAccuracyDetailHeader", selectSalesPlanAccuracyWeeklyDetailHeader);
		} else if ( "2".equals(params.get("gbn").toString()) ) {
			List<EgovMap> selectSalesPlanAccuracyMonthlyDetailHeader	= scmReportService.selectSalesPlanAccuracyMonthlyDetailHeader(params);
			map.put("selectSalesPlanAccuracyDetailHeader", selectSalesPlanAccuracyMonthlyDetailHeader);
		} else {
			LOGGER.debug("selectSalesPlanAccuracyDetailHeader : ERRRRRRRRRRRRRRRRRRRRRRRRROR", params.toString());
		}
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectSalesPlanAccuracy.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSalesPlanAccuracy(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectSalesPlanAccuracy : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> weeklyParams	= new HashMap<>();
		Map<String, Object> monthlyParams	= new HashMap<>();
		
		if ( "1".equals(params.get("gbn").toString()) ) {
			List<EgovMap> selectSalesPlanAccuracyMaster	= scmReportService.selectSalesPlanAccuracyMaster(params);
			
			weeklyParams.put("team", params.get("team").toString());
			weeklyParams.put("weeklyYear", Integer.parseInt(params.get("weeklyYear").toString()));
			weeklyParams.put("weeklyWeek", Integer.parseInt(params.get("weeklyWeek").toString()));
			weeklyParams.put("scmStockTypeCbBox", Integer.parseInt(params.get("scmStockTypeCbBox").toString()));
			
			List<EgovMap> selectSalesPlanAccuracyWeeklySummary	= scmReportService.selectSalesPlanAccuracyWeeklySummary(params);
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
			
			List<EgovMap> selectWeeklyStartEnd	= scmReportService.selectWeeklyStartEnd(weeklyParams);
			weeklyParams.put("startWeek", selectWeeklyStartEnd.get(0).get("startWeek").toString());
			weeklyParams.put("endWeek", selectWeeklyStartEnd.get(0).get("endWeek").toString());
			LOGGER.debug("selectSalesPlanAccuracy Weekly : {}", weeklyParams.toString());
			List<EgovMap> selectSalesPlanAccuracyWeeklyDetail	= scmReportService.selectSalesPlanAccuracyWeeklyDetail(weeklyParams);
			
			map.put("selectSalesPlanAccuracyMaster", selectSalesPlanAccuracyMaster);
			map.put("selectSalesPlanAccuracySummary", selectSalesPlanAccuracyWeeklySummary);
			map.put("selectSalesPlanAccuracyDetail", selectSalesPlanAccuracyWeeklyDetail);
		} else if ( "2".equals(params.get("gbn").toString()) ) {
			List<EgovMap> selectSalesPlanAccuracyMaster	= scmReportService.selectSalesPlanAccuracyMaster(params);
			
			monthlyParams.put("team", params.get("team").toString());
			monthlyParams.put("monthlyYear", Integer.parseInt(params.get("monthlyYear").toString()));
			monthlyParams.put("monthlyMonth", Integer.parseInt(params.get("monthlyMonth").toString()));
			monthlyParams.put("scmStockTypeCbBox", params.get("scmStockTypeCbBox").toString());
			
			List<EgovMap> selectSalesPlanAccuracyMonthlySummary	= scmReportService.selectSalesPlanAccuracyMonthlySummary(params);
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
			
			List<EgovMap> selectMonthlyStartEnd	= scmReportService.selectMonthlyStartEnd(monthlyParams);
			monthlyParams.put("startWeek", selectMonthlyStartEnd.get(0).get("startWeek").toString());
			monthlyParams.put("endWeek", selectMonthlyStartEnd.get(0).get("endWeek").toString());
			LOGGER.debug("selectSalesPlanAccuracy Monthly : {}", monthlyParams.toString());
			List<EgovMap> selectSalesPlanAccuracyMonthlyDetail	= scmReportService.selectSalesPlanAccuracyMonthlyDetail(monthlyParams);
			
			map.put("selectSalesPlanAccuracyMaster", selectSalesPlanAccuracyMaster);
			map.put("selectSalesPlanAccuracySummary", selectSalesPlanAccuracyMonthlySummary);
			map.put("selectSalesPlanAccuracyDetail", selectSalesPlanAccuracyMonthlyDetail);
		} else {
			LOGGER.debug("selectSalesPlanAccuracy : ERRRRRRRRRRRRRRRRRRRRRRRRROR", params.toString());
		}
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectSalesPlanAccuracyDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSalesPlanAccuracyDetail(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectSalesPlanAccuracyDetail : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		if ( "1".equals(params.get("gbn").toString()) ) {
			Map<String, Object> weeklyParams	= new HashMap<>();
			weeklyParams.put("team", params.get("team").toString());
			weeklyParams.put("weeklyYear", Integer.parseInt(params.get("weeklyYear").toString()));
			weeklyParams.put("weeklyWeek", Integer.parseInt(params.get("weeklyWeek").toString()));
			weeklyParams.put("scmStockTypeCbBox", params.get("scmStockTypeCbBox").toString());
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
			
			List<EgovMap> selectWeeklyStartEnd	= scmReportService.selectWeeklyStartEnd(weeklyParams);
			weeklyParams.put("startWeek", selectWeeklyStartEnd.get(0).get("startWeek").toString());
			weeklyParams.put("endWeek", selectWeeklyStartEnd.get(0).get("endWeek").toString());
			LOGGER.debug("selectSalesPlanAccuracyDetail Weekly : {}", weeklyParams.toString());
			List<EgovMap> selectSalesPlanAccuracyWeeklyDetail	= scmReportService.selectSalesPlanAccuracyWeeklyDetail(weeklyParams);
			
			map.put("selectSalesPlanAccuracyDetail", selectSalesPlanAccuracyWeeklyDetail);
		} else if ( "2".equals(params.get("gbn").toString()) ) {
			Map<String, Object> monthlyParams	= new HashMap<>();
			monthlyParams.put("team", params.get("team").toString());
			monthlyParams.put("monthlyYear", Integer.parseInt(params.get("monthlyYear").toString()));
			monthlyParams.put("monthlyMonth", Integer.parseInt(params.get("monthlyMonth").toString()));
			monthlyParams.put("scmStockTypeCbBox", params.get("scmStockTypeCbBox").toString());
			
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
			
			List<EgovMap> selectMonthlyStartEnd	= scmReportService.selectMonthlyStartEnd(monthlyParams);
			monthlyParams.put("startWeek", selectMonthlyStartEnd.get(0).get("startWeek").toString());
			monthlyParams.put("endWeek", selectMonthlyStartEnd.get(0).get("endWeek").toString());
			LOGGER.debug("selectSalesPlanAccuracyDetail Monthly : {}", monthlyParams.toString());
			List<EgovMap> selectSalesPlanAccuracyMonthlyDetail	= scmReportService.selectSalesPlanAccuracyMonthlyDetail(monthlyParams);
			
			map.put("selectSalesPlanAccuracyDetail", selectSalesPlanAccuracyMonthlyDetail);
		} else {
			LOGGER.debug("selectSalesPlanAccuracyDetail : ERRRRRRRRRRRRRRRRRRRRRRRRROR", params.toString());
		}
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectSalesPlanAccuracyMaster.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSalesPlanAccuracyMaster(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectSalesPlanAccuracyMaster : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		List<EgovMap> selectSalesPlanAccuracyMaster	= scmReportService.selectSalesPlanAccuracyMaster(params);
		
		map.put("selectSalesPlanAccuracyMaster", selectSalesPlanAccuracyMaster);
		
		return	ResponseEntity.ok(map);
	}
/*	public ResponseEntity<Map<String, Object>> selectSalesPlanAccuracyMaster(@RequestBody Map<String, Object> params) {
	//public ResponseEntity<List<EgovMap>> selectSalesPlanAccuracyMaster(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectSalesPlanAccuracyMaster : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		List<EgovMap> selectSalesPlanAccuracyMaster	= scmReportService.selectSalesPlanAccuracyMaster(params);
		
		map.put("selectSalesPlanAccuracyMaster", selectSalesPlanAccuracyMaster);
		
		return ResponseEntity.ok(map);
	}*/
	@RequestMapping(value = "/saveSalesPlanAccuracyMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSalesPlanAccuracyMaster(@RequestBody Map<String, List<Map<String, Object>>> params,	SessionVO sessionVO) {
		
		LOGGER.debug("saveSalesPlanAccuracyMaster : {}", params.toString());
		
		List<Map<String, Object>> updList	= params.get(AppConstants.AUIGRID_UPDATE);
		LOGGER.debug("saveSalesPlanAccuracyMaster updList : {}", params.toString());
		int totCnt	= scmReportService.saveSalesPlanAccuracyMaster(updList, sessionVO);
		
		ReturnMessage message = new ReturnMessage();
		
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
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
	@RequestMapping(value = "/selectOntimeDeliveryPopup.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOntimeDeliveryPopup(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectOntimeDeliveryPopup : {}", params.toString());
		
		Map<String, Object> map	= new HashMap<>();
		
		List<EgovMap> selectOntimeDeliveryPopup	= scmReportService.selectOntimeDeliveryPopup(params);
		
		map.put("selectOntimeDeliveryPopup", selectOntimeDeliveryPopup);
		
		return	ResponseEntity.ok(map);
	}
	
	/*
	 * Inventory Report
	 */
	@RequestMapping(value = "/selectInventoryReportTotal.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectInventoryReportTotal(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectInventoryReportTotal : {}", params.toString());
		String planYearMonth	= "";
		
		Map<String, Object> map	= new HashMap<>();
		planYearMonth	= params.get("planYearMonth").toString();
		planYearMonth	= planYearMonth.replace("/", "");
		planYearMonth	= planYearMonth.substring(2, 6) + planYearMonth.substring(0, 2);
		params.put("planYearMonth", planYearMonth);
		LOGGER.debug("selectInventoryReportTotal : {}", params.toString());
		
		List<EgovMap> selectScmCurrency	= scmReportService.selectScmCurrency(params);
		List<EgovMap> selectInventoryReportTotal	= scmReportService.selectInventoryReportTotal(params);
		List<EgovMap> selectInventoryReportDetail	= scmReportService.selectInventoryReportDetail(params);
		
		map.put("selectScmCurrency", selectScmCurrency);
		map.put("selectInventoryReportTotal", selectInventoryReportTotal);
		map.put("selectInventoryReportDetail", selectInventoryReportDetail);
		
		return	ResponseEntity.ok(map);
	}
	//	Search Detail
	@RequestMapping(value = "/selectInventoryReportDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectInventoryReportDetail(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectInventoryReportDetail : {}", params.toString());
		String planYearMonth	= "";
		
		Map<String, Object> map	= new HashMap<>();
		planYearMonth	= params.get("planYearMonth").toString();
		planYearMonth	= planYearMonth.replace("/", "");
		planYearMonth	= planYearMonth.substring(2, 6) + planYearMonth.substring(0, 2);
		params.put("planYearMonth", planYearMonth);
		LOGGER.debug("selectInventoryReportDetail : {}", params.toString());
		
		List<EgovMap> selectScmCurrency	= scmReportService.selectScmCurrency(params);
		List<EgovMap> selectInventoryReportDetail	= scmReportService.selectInventoryReportDetail(params);
		
		map.put("selectScmCurrency", selectScmCurrency);
		map.put("selectInventoryReportDetail", selectInventoryReportDetail);
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/updateScmCurrency.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateScmCurrency(@RequestBody Map<String, Object> params,	SessionVO sessionVO) {
		
		LOGGER.debug("updateScmCurrency : {}", params.toString());
		
		scmReportService.updateScmCurrency(params);
		
		ReturnMessage message = new ReturnMessage();
		
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/executeScmInventory.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> executeScmInventory(@RequestBody Map<String, Object> params,	SessionVO sessionVO) {
		
		LOGGER.debug("executeScmInventory : {}", params.toString());
		
		scmReportService.executeScmInventory(params);
		
		ReturnMessage message = new ReturnMessage();
		
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	/*
	 * Aging Inventory
	 */
	@RequestMapping(value = "/selectAgingInventoryHeader.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectAgingInventoryHeader(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		LOGGER.debug("selectAgingInventoryHeader : {}", params.toString());
		String planYearMonth	= "";
		
		Map<String, Object> map	= new HashMap<>();
		planYearMonth	= params.get("planYearMonth").toString();
		planYearMonth	= planYearMonth.replace("/", "");
		planYearMonth	= planYearMonth.substring(2, 6) + planYearMonth.substring(0, 2);
		params.put("planYearMonth", planYearMonth);
		
		List<EgovMap> selectAgingInventoryHeader	= scmReportService.selectAgingInventoryHeader(params);
		
		map.put("selectAgingInventoryHeader", selectAgingInventoryHeader);
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectAgingInventory.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectAgingInventory(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectAgingInventory : {}", params.toString());
		String planYearMonth	= "";
		
		Map<String, Object> map	= new HashMap<>();
		planYearMonth	= params.get("planYearMonth").toString();
		planYearMonth	= planYearMonth.replace("/", "");
		planYearMonth	= planYearMonth.substring(2, 6) + planYearMonth.substring(0, 2);
		params.put("planYearMonth", planYearMonth);
		
		List<EgovMap> selectAgingInventory	= scmReportService.selectAgingInventory(params);
		
		map.put("selectAgingInventory", selectAgingInventory);
		
		return	ResponseEntity.ok(map);
	}
}