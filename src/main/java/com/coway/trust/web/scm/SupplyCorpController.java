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

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class SupplyCorpController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SupplyCorpController.class);

	@Autowired
	private SalesPlanMngementService salesPlanMngementService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	// Supply Plan Summary By CDC
	@RequestMapping(value = "/supplyPlanByCDC.do")
	public String supplyPlanByCdcMain(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/supplyPlanByCDC";  
	}  
	
	@RequestMapping(value = "/selectSupplyCDC.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSupplyCDC(@RequestParam Map<String, Object> params) {
	
		LOGGER.debug("selectSupplyCDC_ComboList : {}", params.toString());
		
		List<EgovMap> selectSupplyCDCCodeList = salesPlanMngementService.selectSupplyCDC(params);
		return ResponseEntity.ok(selectSupplyCDCCodeList);
	}
	
	@RequestMapping(value = "/selectComboSupplyCDC.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectComboSupplyCDC(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectComboSupplyCDC_ComboList : {}", params.toString());
		
		List<EgovMap> selectComboListSupplyCDC = salesPlanMngementService.selectComboSupplyCDC(params);
		return ResponseEntity.ok(selectComboListSupplyCDC);
	}
	
	@RequestMapping(value = "/selectSupplyPlanMaster.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSupplyPlanMaster(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectSupplyPlanMaster_ComboList : {}", params.toString());
		
		List<EgovMap> selectSupplyPlanMaster = salesPlanMngementService.selectSupplyPlanMaster(params);
		return ResponseEntity.ok(selectSupplyPlanMaster);
	}
	
	@RequestMapping(value = "/selectSalesPlanMaster.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSalesPlanMaster(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectSalesPlanMaster_ComboList : {}", params.toString());
		
		List<EgovMap> selectSalesPlanMaster = salesPlanMngementService.selectSalesPlanMaster(params);
		return ResponseEntity.ok(selectSalesPlanMaster);
	}

	@RequestMapping(value = "/selectSupplyPlanByCdcSearch.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSupplyPlanByCdcSearch(@RequestBody Map<String, Object> params) 
	{
		LOGGER.debug("selectSupplyPlanCDC_Input : {}", params.toString());
		
		List<EgovMap> selectSupplyPlanCDCList = salesPlanMngementService.selectSupplyCdcMainList(params);
		List<EgovMap> selectSupplyCdcSaveFlag = salesPlanMngementService.selectSupplyCdcSaveFlag(params);
		List<EgovMap> selectSalesPlanMasterList = salesPlanMngementService.selectSalesPlanMaster(params);
		List<EgovMap> selectSupplyPlanMasterList = salesPlanMngementService.selectSupplyPlanMaster(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectSupplyPlanCDCList", selectSupplyPlanCDCList);
		map.put("selectSupplyCdcSaveFlag", selectSupplyCdcSaveFlag);
		map.put("selectSalesPlanMasterList", selectSalesPlanMasterList);
		map.put("selectSupplyPlanMasterList", selectSupplyPlanMasterList);

		return ResponseEntity.ok(map);
	}
	
	// 
	@RequestMapping(value = "/supplyPlanByCdcDetailPop.do")
	public String supplyPlanByCdcDetailPopup(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		return "/scm/supplyPlanByCdcDetailPop";  	
	} 
	
	@RequestMapping(value = "/selectSupplyCdcPop.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSupplyCdcPop(@RequestBody Map<String, Object> params)
	{
		LOGGER.debug("selectSupplyCdcPop_InpParams : {}", params.toString());
		
		String  selectPlanDate = salesPlanMngementService.selectPlanDatePlanByCdc(params).get(0).get("planDate").toString();
		
		params.put("planDate", selectPlanDate);   
		
		List<EgovMap> selectSupplyCdcPop = salesPlanMngementService.selectSupplyCdcPop(params);
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectSupplyCdcPopList", selectSupplyCdcPop);
		return ResponseEntity.ok(map);
	}	
	
	// Supply Plan Summary View
	@RequestMapping(value = "/supplyPlanSummary.do")
	public String login(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return "/scm/supplyPlanSummaryView";  
	}  
	
	@RequestMapping(value = "/selectSupplyCorpListSearch.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSalesPlanMngmentList(@RequestBody Map<String, Object> params)
	{
		LOGGER.debug("selectSupplyCorpList_InpParams : {}", params.toString());
		
		List<EgovMap> selectSupplyCorpList = salesPlanMngementService.selectSupplyCorpList(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectSupplyCorpList", selectSupplyCorpList);

		return ResponseEntity.ok(map);
		
	}
	
	// saveUpdatePlanByCDC
	@RequestMapping(value = "/saveUpdatePlanByCDC.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveUpdatePlanByCDC(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO)
	{
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 

		LOGGER.info("updatePlanByCDC_수정 : {}", udtList.toString());
		
		int tmpCnt = 0;
		int totCnt = 0;
		
		if (udtList.size() > 0) {
			tmpCnt = salesPlanMngementService.updatePlanByCDC(udtList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}
		
		LOGGER.info("PlanByCDC Saves카운트 : {}", totCnt);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	// supplyPlanByCDC Stored Procedure
	@RequestMapping(value = "/insertOrderSummarySPCall.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertOrderSummarySPCall(@RequestBody Map<String, Object> params,SessionVO sessionVO) 
	{
		/* Stored Procedure Call (SP_SCM_PLAN_BY_CDC_INS) */
		String retval = salesPlanMngementService.callSpCreateSupplyPlanSummary(params, sessionVO);
		LOGGER.debug("SPCall_Retvalue : {}", retval.toString());

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(retval);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}

}
