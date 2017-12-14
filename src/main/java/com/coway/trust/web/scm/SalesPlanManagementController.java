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
public class SalesPlanManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SalesPlanManagementController.class);
	//private static final Logger LOGGER  = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SalesPlanMngementService salesPlanMngementService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/salesPlanManager.do")
	public String login(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/salesPlanManagement";  
	}
	
	@RequestMapping(value = "/selectCalendarHeader.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectCalendarHeaderList(@RequestParam Map<String, Object> params) 
	{
		LOGGER.debug("selectCalendarHeaderList : {}", params.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		List<EgovMap> selectCalendarHeaderList = salesPlanMngementService.selectCalendarHeader(params);
		List<EgovMap> planInfo = salesPlanMngementService.selectPlanId(params);
		
		map.put("header", selectCalendarHeaderList);
		
		if (!planInfo.isEmpty())
		{
			LOGGER.debug("planMonth_map : {}", planInfo.get(0).toString() );
			String selectPlanMonth = String.valueOf(planInfo.get(0).get("planMonth"));
			LOGGER.debug("selectPlanMonth : {}", selectPlanMonth);	
			
            ((Map<String, Object>) params).put("selectPlanMonth", selectPlanMonth);
			
			LOGGER.debug("selectCalendarHeaderList : {}", params.toString());
			
			List<EgovMap> seperaionInfo = salesPlanMngementService.selectSeperation(params);  // WeekCount per month
			List<EgovMap> childFieldList_M0 = salesPlanMngementService.selectChildField(params);
			
			LOGGER.debug("seperaionInfo : {}", seperaionInfo.toString());
			
			map.put("planInfo",planInfo);
			map.put("seperaionInfo",seperaionInfo);
			map.put("getChildField",childFieldList_M0);			
		}
		
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/selectPlanMstIdDetailSeqForIns.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectPlanDetailIdSeq(@RequestParam Map<String, Object> params) 
	{
		LOGGER.debug("selectPlanMstIdDetailSeqForIns : {}", params.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		List<EgovMap> selectPlanDetailIdSeq = salesPlanMngementService.selectPlanDetailIdSeq(params);
		List<EgovMap> selectPlanMasterId = salesPlanMngementService.selectPlanMasterId(params);
		
		map.put("selectPlanDetailIdSeq",selectPlanDetailIdSeq);
		map.put("selectPlanMasterId",selectPlanMasterId);
		
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/selectAccuracyMonthlyHeaderList.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectAccuracyMonthlyHeaderList(@RequestParam Map<String, Object> params) 
	{
		LOGGER.debug("selectAccuracyMonthlyHeaderList : {}", params.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		List<EgovMap> selectWeekThAccuracy = salesPlanMngementService.selectAccuracyMonthlyHeaderList(params);
		List<EgovMap> seperaionCnt = salesPlanMngementService.selectSeperation(params);  // WeekCount per month
		
		map.put("selectWeekThAccuracy",selectWeekThAccuracy);
		map.put("accuracyHeadCount",seperaionCnt);
		
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/selectStockIdByStCode.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectStockIdByStCode(@RequestParam Map<String, Object> params) 
	{
		LOGGER.debug("selectStockIdByStCode : {}", params.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		List<EgovMap> selectStockIdByStCode = salesPlanMngementService.selectStockIdByStCode(params);
		
		map.put("selectStockIdByStCode",selectStockIdByStCode);
		
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/selectPlanId.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPlanId(@RequestParam Map<String, Object> params) 
	{
		LOGGER.debug("selectPlanId : {}", params.toString());
		
		List<EgovMap> selectPlanIdList = salesPlanMngementService.selectPlanId(params);
		return ResponseEntity.ok(selectPlanIdList);
	}
	
	@RequestMapping(value = "/selectStockCtgrySummary.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectStockCtgrySummaryList(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectStockCtgrySummaryList : {}", params.toString());
		LOGGER.debug("stkCodes : {}", stkCodes.toString());
		
		if (stkCodes != null) {
			for (Integer id : stkCodes) {
				LOGGER.debug("summary_StkCode : {}", id);
			}
			
			params.put("stkCodes", stkCodes);
		}
		
		List<EgovMap> planInfo = salesPlanMngementService.selectPlanId(params);		
		String selectPlanMonth = String.valueOf(planInfo.get(0).get("planMonth"));		
		((Map<String, Object>) params).put("selectPlanMonth", selectPlanMonth);	
		
		LOGGER.debug("addMonth_Param : {}", params.toString());
		
		List<EgovMap> selectStockCtgrySummaryList = salesPlanMngementService.selectStockCtgrySummary(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectSalesSummaryList", selectStockCtgrySummaryList);
		
		return ResponseEntity.ok(map);
		
	}
	@RequestMapping(value = "/selectSalesPlanMngmentSearch.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSalesPlanMngmentList(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectSalesPlanMngmentList : {}", params.toString());
		LOGGER.debug("stkCodes : {}", stkCodes.toString());
		
		if (stkCodes != null) {
			for (Integer id : stkCodes) {
				LOGGER.debug("stkCode : {}", id);
			}
			
			params.put("stkCodes", stkCodes);
		}
		
		List<EgovMap> planInfo = salesPlanMngementService.selectPlanId(params);		
		String selectPlanMonth = String.valueOf(planInfo.get(0).get("planMonth"));		
		((Map<String, Object>) params).put("selectPlanMonth", selectPlanMonth);	
		
		LOGGER.debug("addMonth_Param : {}", params.toString());
		
		List<EgovMap> selectSalesPlanMngmentList = salesPlanMngementService.selectSalesPlanMngmentList(params);
		
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("salesPlanMainList", selectSalesPlanMngmentList);

		return ResponseEntity.ok(map);
		
	}
	
	@RequestMapping(value = "/selectSalesCnt.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSalesCnt(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectSalesCnt : {}", params.toString());
		
		List<EgovMap> selectSalesCntList = salesPlanMngementService.selectSalesCnt(params);
		return ResponseEntity.ok(selectSalesCntList);
	}
	
	@RequestMapping(value = "/selectExcuteYear.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectExcuteYearList(@RequestParam Map<String, Object> params) {
	
		LOGGER.debug("selectExcuteYearList : {}", params.toString());
		
		List<EgovMap> selectExcuteYearList = salesPlanMngementService.selectExcuteYear(params);
		return ResponseEntity.ok(selectExcuteYearList);
	}
	
	@RequestMapping(value = "/selectPeriodByYear.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPeriodByYearList(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectPeriodByYearList : {}", params.toString());
		
		List<EgovMap> selectPeriodByYearList = salesPlanMngementService.selectPeriodByYear(params);
		return ResponseEntity.ok(selectPeriodByYearList);
	}
	
	@RequestMapping(value = "/selectMonthCombo.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMonthCombo(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectMonthComboList : {}", params.toString());
		
		List<EgovMap> selectMonthCombo = salesPlanMngementService.selectMonthCombo(params);
		return ResponseEntity.ok(selectMonthCombo);
	}
	
	@RequestMapping(value = "/selectWeekThList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWeekThList(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectWeekThComboList : {}", params.toString());
		
		List<EgovMap> selectWeekThComboList = salesPlanMngementService.selectChildField(params);
		return ResponseEntity.ok(selectWeekThComboList);
	}
	
	@RequestMapping(value = "/selectWeekThSnComboList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWeekThSn(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectWeekThSnComboList : {}", params.toString());
		
		List<EgovMap> selectWeekThSnComboList = salesPlanMngementService.selectWeekThSn(params);
		return ResponseEntity.ok(selectWeekThSnComboList);
	}
	
	@RequestMapping(value = "/selectScmTeamCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmTeamCodeList(@RequestParam Map<String, Object> params) {
		Precondition.checkNotNull(params.get("codeMasterId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "codeMasterId" }));

		LOGGER.debug("codeMasterId : {}", params.get("codeMasterId"));

		List<EgovMap> selectScmTeamCodeList = salesPlanMngementService.selectScmTeamCode(params);
		return ResponseEntity.ok(selectScmTeamCodeList);
	}
	
	@RequestMapping(value = "/selectStockCategoryCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStockCategoryCode(@RequestParam Map<String, Object> params) {
	
		LOGGER.debug("selectStockCategoryCodeList : {}", params.toString());
		
		List<EgovMap> selectStockCategoryCodeList = salesPlanMngementService.selectStockCategoryCode(params);
		return ResponseEntity.ok(selectStockCategoryCodeList);
	}
	
	@RequestMapping(value = "/selectStockCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStockCode(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectStockCode : {}", params.toString());
		
		List<EgovMap> selectStockCodeList = salesPlanMngementService.selectStockCode(params);
		return ResponseEntity.ok(selectStockCodeList);
	}
	
	@RequestMapping(value = "/selectDefaultStockCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDefaultStockCode(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectDefaultStockCode : {}", params.toString());
		
		List<EgovMap> selectDefaultStockCode = salesPlanMngementService.selectDefaultStockCode(params);
		return ResponseEntity.ok(selectDefaultStockCode);
	}
	
	// update save 
	@RequestMapping(value = "/saveScmSalesPlan.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveUserExceptAuthMapping(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO)
	{
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		//List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		//List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList
		// 콘솔로 찍어보기
		LOGGER.info("salesPlanMngementService_수정 : {}", udtList.toString());
		//LOGGER.info("salesPlanMngementService_추가 : {}", addList.toString());
		//LOGGER.info("salesPlanMngementService_삭제 : {}", delList.toString());
		
		
		int tmpCnt = 0;
		int totCnt = 0;
	
/*		if (addList.size() > 0) {
			tmpCnt = salesPlanMngementService.insertSalesPlanDetail(addList, sessionVO.getUserId()); 
			totCnt = totCnt + tmpCnt;
		}*/

		if (udtList.size() > 0) {
			tmpCnt = salesPlanMngementService.updateSCMPlanMaster(udtList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}
		/*
		if (delList.size() > 0) {
			tmpCnt = salesPlanMngementService.deleteGSTExportation(delList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}*/
		
		LOGGER.info("salesPlan Saves카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/saveInsScmSalesPlan.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveInsScmSalesPlan(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO)
	{
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		// 콘솔로 찍어보기
		LOGGER.info("salesPlanMngementService_추가 : {}", addList.toString());
		
		int tmpCnt = 0;
		int totCnt = 0;
		
		if (addList.size() > 0) {
			tmpCnt = salesPlanMngementService.insertSalesPlanDetail(addList, sessionVO.getUserId()); 
			totCnt = totCnt + tmpCnt;
		}
		
		LOGGER.info("salesPlan Saves카운트 : {}", totCnt);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	// SALES PLAN ACCURACY	
	@RequestMapping(value = "/selectAccuracyWeeklyDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectAccuracyWeeklyDetail(@RequestParam Map<String, Object> params) 
	{
		LOGGER.debug("selectAccuracyWeeklyDetail_Params : {}", params.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		List<EgovMap> selectAccuracyWeeklyDetail = salesPlanMngementService.selectAccuracyWeeklyDetail(params);
		
		map.put("accuracyWeeklyDetailList",selectAccuracyWeeklyDetail);
		
		return ResponseEntity.ok(map);
	}

}
