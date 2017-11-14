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
			
			LOGGER.debug("selectCalendarHeaderList2 : {}", params.toString());
			
			List<EgovMap> group_M1_List = salesPlanMngementService.selectSeperation(params);  // WeekCount per month
			List<EgovMap> childFieldList_M0 = salesPlanMngementService.selectChildField(params);
			
			map.put("planInfo",planInfo);
			map.put("seperaionInfo",group_M1_List);
			map.put("getChildField",childFieldList_M0);			
		}
		
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

	// save 
	@RequestMapping(value = "/saveScmSalesPlan.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveUserExceptAuthMapping(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO)
	{
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		int tmpCnt = 0;
		int totCnt = 0;
	/*	
		if (addList.size() > 0) {
			tmpCnt = salesPlanMngementService.insertGSTExportation(addList, sessionVO.getUserId()); 
			totCnt = totCnt + tmpCnt;
		}
*/
		//{add=[], update=[{planDtlId=5621, planMasterId=248, team=DST, code=620001, preM3AvgOrded=102, preM3AvgIssu=65, m3AvgIssueOrder=65/102, m1Ord=120, m2Ord=93, m3Ord=93, m3=112, m2=106, m1=98, m0Plan=90, m0Ord=8, m0PlanOrder=90/8, m4=12, w00=20, w01=9999, w02=30, w03=10, w04=10, w05=20, w06=29, w07=29, w08=10, w09=0, w10=11, w11=21, w12=32, w13=42, w14=0, w15=11, w16=22, w17=34, w18=45, w19=0, w20=12, w21=0, w22=0, w23=0, w24=0, w25=0, w26=0, w27=0, w28=0, w29=0, w30=0, name=POE-14A (BAMBOO MINI), category=POE, _$uid=3B5C262A-C95E-C71C-96E7-A406B4975825, crtUserId=184, updUserId=184}], remove=[]}
		if (udtList.size() > 0) {
			tmpCnt = salesPlanMngementService.updateSCMPlanMaster(udtList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}
		/*
		if (delList.size() > 0) {
			tmpCnt = salesPlanMngementService.deleteGSTExportation(delList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}*/

		// 콘솔로 찍어보기
		LOGGER.info("salesPlanMngementService_수정 : {}", udtList.toString());
		LOGGER.info("salesPlanMngementService_추가 : {}", addList.toString());
		LOGGER.info("salesPlanMngementService_삭제 : {}", delList.toString());
		LOGGER.info("salesPlanMngementService_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

}
