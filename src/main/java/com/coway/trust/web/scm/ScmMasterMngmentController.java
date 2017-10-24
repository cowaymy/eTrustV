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
import com.coway.trust.biz.scm.PoMngementService;
import com.coway.trust.biz.scm.SalesPlanMngementService;
import com.coway.trust.biz.scm.ScmMasterMngMentService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmMasterMngmentController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmMasterMngmentController.class);
	
	@Autowired
	private ScmMasterMngMentService scmMasterMngMentService;
	@Autowired
	private SalesPlanMngementService salesPlanMngementService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	// view
	@RequestMapping(value = "/scmMasterManagement.do")
	public String masterMngmentView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/scmMasterManagement";  	
	}  

	// search btn
	@RequestMapping(value = "/selectMasterMngmentSerch.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectMasterMngmentSerch(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectMasterMngmentSerch_Input : {}", params.toString());
		
		List<EgovMap> scmMasterMngMentServiceList = scmMasterMngMentService.selectMasterMngmentSearch(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("scmMasterMngMentServiceList", scmMasterMngMentServiceList);

		return ResponseEntity.ok(map);
		
	}	
	
	/*****************************************
	 *   CDC WareHouse MAPPING  
	 *****************************************/
	// view
	@RequestMapping(value = "/cdcWhMappingManager.do")
	public String cdcWareHouseMappingView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/cdcWhMappingManager";  	
	}
	
	@RequestMapping(value = "/selectWHouseMappingSerch.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectWhLocationMapping(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectWhLocationMapping_Input : {}", params.toString());
		
		List<EgovMap> selectCdcWareMappingList = scmMasterMngMentService.selectCdcWareMapping(params);
		List<EgovMap> selectWhLocationMappingList = scmMasterMngMentService.selectWhLocationMapping(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectCdcWareMappingListList", selectCdcWareMappingList);
		map.put("selectWhLocationMappingList", selectWhLocationMappingList);

		return ResponseEntity.ok(map);
		
	}
	
	@RequestMapping(value = "/saveCdcWhMappingList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommMstGrid(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get gride delList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> updList = params.get(AppConstants.AUIGRID_UPDATE); // Get grid updList

		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		int tmpCnt = 0;
		int totCnt = 0;
		
		if (updList.size() > 0) {
			tmpCnt = scmMasterMngMentService.insetCdcWhMapping(updList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (delList.size() > 0) {
			tmpCnt = scmMasterMngMentService.deleteCdcWhMapping(delList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		// 콘솔로 찍어보기
		LOGGER.info("CdcWareHouse_수정 : {}", delList.toString());
		LOGGER.info("CdcWareHouse_추가 : {}", addList.toString());
		LOGGER.info("CdcWareHouse_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}	
	
	
	/*****************************************
	 *   Business Plan Manager
	 *****************************************/
	// view
	@RequestMapping(value = "/businessPlanManager.do")
	public String bizPlanManagerView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/businessPlanManager";  	
	}  	


}
