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
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class PoManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PoManagementController.class);
	//private static final Logger LOGGER  = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private SalesPlanMngementService salesPlanMngementService;
	
	@Autowired
	private PoMngementService poMngementService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	
   /**********************************************/
   /*********** PO Management && PO Issue ********/
   /**********************************************/	
	// 
	@RequestMapping(value = "/poManager.do")
	public String poManager(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/poManagement";  	
	}
	
	// search btn
	@RequestMapping(value = "/selectScmPrePoItemView.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSupplyPlanCDCSearch(@RequestBody Map<String, Object> params) 
	{
		LOGGER.debug("selectScmPrePoItemView_Input : {}", params.toString());
		
		List<EgovMap> selectScmPrePoItemViewList = poMngementService.selectScmPrePoItemView(params);
		List<EgovMap> selectScmPoViewList = poMngementService.selectScmPoView(params);
		List<EgovMap> selectScmPoStatusCntList = poMngementService.selectScmPoStatusCnt(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectScmPrePoItemViewList", selectScmPrePoItemViewList);
		map.put("selectScmPoViewList", selectScmPoViewList);
		map.put("selectScmPoStatusCntList", selectScmPoStatusCntList);

		return ResponseEntity.ok(map);
		
	}	
	
	// 
	@RequestMapping(value = "/selectScmPoView.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectScmPoView(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectScmPoView_Input : {}", params.toString());
		
		List<EgovMap> selectScmPoViewList = poMngementService.selectScmPoView(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectScmPoViewList", selectScmPoViewList);
		
		return ResponseEntity.ok(map);
		
	}
	
	@RequestMapping(value = "/selectPoRightMove.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectPoRightMove(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectPoRightMove_Input : {}", params.toString());
		
		List<EgovMap> selectPoRightMoveList = poMngementService.selectPoRightMove(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectPoRightMoveList", selectPoRightMoveList);
		
		return ResponseEntity.ok(map);
		
	}	
	
	@RequestMapping(value = "/savePOIssuItem.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePOIssuItem(@RequestBody Map<String, List<Map<String, Object>>> params,	SessionVO sessionVO)
	{
		//List<Map<String, Object>> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Map<String, Object>> updList = params.get(AppConstants.AUIGRID_UPDATE); // Get grid addList

		int tmpCnt = 0;
		int totCnt = 0;
		
		LOGGER.info("InsUpdPoIssueItem_수정 >> Add_Size: {}, Upd_Size: {}, params: {}", updList.size(), params.toString());
		
		if (updList.size() > 0) 
		{
			// Step1. Update SCMPrePOItem   Step2. Insert SCMPODetail
			tmpCnt = poMngementService.updatePOIssuItem(updList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		// 콘솔로 찍어보기
		LOGGER.info("InsUpdPoIssueItem_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}	
	
	@RequestMapping(value = "/deletePOMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deletePOMaster(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO)
	{                                                   
        List<Object> checkList = params.get(AppConstants.AUIGRID_CHECK);
		
		LOGGER.info("deletePOMasterList : {}", checkList.toString());
		
		int totCnt = 0;
		
		if (checkList.size() > 0) {  
			totCnt = poMngementService.deletePOMaster(checkList, sessionVO.getUserId());
		}
		
		// 콘솔로 찍어보기
		LOGGER.info("deletePOMaster카운트 : {}", totCnt);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}	
	
	   /**************************************/
	   /************* PO Approval*************/
	   /**************************************/
	
	@RequestMapping(value = "/poApproval.do")
	public String poApprovalManager(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/poApproval";  	
	}  
	
	// search btn
	@RequestMapping(value = "/selectPoApprovalSearchBtn.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectPoApprovalSearchBtn(@RequestBody Map<String, Object> params) 
	{
		LOGGER.debug("selectPoApprovalSearchBtn_Input : {}", params.toString());
		
		List<EgovMap> selectPoApprovalSummaryList = poMngementService.selectPoApprovalSummary(params);
		List<EgovMap> selectPoApprovalSummaryHiddenList = poMngementService.selectPoApprovalSummaryHidden(params);
		List<EgovMap> selectPoApprovalMainListList = poMngementService.selectPoApprovalMainList(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectPoApprovalSummaryList", selectPoApprovalSummaryList);
		map.put("selectPoApprovalSummaryHiddenList", selectPoApprovalSummaryHiddenList);
		map.put("selectPoApprovalMainListList", selectPoApprovalMainListList);

		return ResponseEntity.ok(map);
		
	}
	
	@RequestMapping(value = "/updatePoApprovalDetail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePoApprovalDetail(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO)
	{
		List<Object> checkList = params.get(AppConstants.AUIGRID_CHECK);

		int tmpCnt = 0;
		int totCnt = 0;

		if (checkList.size() > 0) {
			tmpCnt = poMngementService.updatePoApprovalDetail(checkList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		// 콘솔로 찍어보기
		LOGGER.info("updatePoApprovalDetail_수정 : {}", checkList.toString());
		LOGGER.info("updatePoApprovalDetail_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	
   /**************************************/
   /*********** OTD Status Viewer ********/
   /**************************************/
	
	/* view */
	@RequestMapping(value = "/OTDStatusViewer.do")
	public String OtdStatusViewMain(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) 
	{
		//model.addAttribute("languages", loginService.getLanguages());
		return "/scm/otdStatusViewer";  	
	}
	
	// search btn
	@RequestMapping(value = "/selectOtdStatusViewSearch.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectOtdStatusView(@RequestBody Map<String, Object> params) 
	{
		LOGGER.debug("selectOtdStatusView_Input : {}", params.toString());
		
		List<EgovMap> selectOtdStatusViewList = poMngementService.selectOtdStatusView(params);
		//List<EgovMap> selectInterfaceLastState = poMngementService.selectInterfaceLastState(params);
		
		Map<String, Object> map = new HashMap<>();
		
		//main Data
		map.put("selectOtdStatusViewList", selectOtdStatusViewList);
		//map.put("selectInterfaceLastState", selectInterfaceLastState);

		return ResponseEntity.ok(map);
		
	}
	
	// otdDetailPopUp
	@RequestMapping(value = "/otdDetailPop.do")
	public String otdDetailPopUp(@RequestParam Map<String, Object> params, ModelMap model) {
		// model.addAttribute("url", params);
		// 호출될 화면
		return "/scm/otdDetailPop";
	}
	
	@RequestMapping(value = "/selectOtdSODetailPop.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectOtdSODetailPop(@RequestParam Map<String, Object> params,
			@RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) 
	{
		LOGGER.debug("selectOtdSODetailPop_Input : {}", params.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		if ("GI".equals(String.valueOf(params.get("detailGbn"))) )
		{
			List<EgovMap> selectOtdSOGIDetailPopList = poMngementService.selectOtdSOGIDetailPop(params);
			map.put("selectOtdSOGIDetailPopList", selectOtdSOGIDetailPopList);
		}
		else 
		{
			List<EgovMap> selectOtdSOPPDetailPopList = poMngementService.selectOtdSOPPDetailPop(params);
			map.put("selectOtdSOPPDetailPopList", selectOtdSOPPDetailPopList);
		}
		
		return ResponseEntity.ok(map);
		
	}	

}
