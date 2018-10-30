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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.PoManagementService;
import com.coway.trust.biz.scm.PoMngementService;
import com.coway.trust.biz.scm.ScmInterfaceManagementService;
import com.coway.trust.biz.scm.SupplyPlanManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class PoManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PoManagementController.class);
	
	@Autowired
	private PoMngementService poMngementService;
	
	@Autowired
	private PoManagementService poManagementService;
	
	@Autowired
	private SupplyPlanManagementService supplyPlanManagementService;
	
	@Autowired
	private ScmInterfaceManagementService scmInterfaceManagementService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;

	/**********************************************/
	/**************** PO Issue ********************/
	@RequestMapping(value = "/poIssue.do")
	public String poIssue(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/poIssue";
	}
	
	@RequestMapping(value = "/selectPoTargetList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectPoTargetList(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectPoTargetList : {}", params.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		List<EgovMap> selectPoCreatedList	= poManagementService.selectPoCreatedList(params);
		List<EgovMap> selectPoTargetList	= poManagementService.selectPoTargetList(params);
		List<EgovMap> selectTotalSplitInfo	= supplyPlanManagementService.selectTotalSplitInfo(params);
		
		map.put("selectPoCreatedList", selectPoCreatedList);
		map.put("selectPoTargetList", selectPoTargetList);
		map.put("selectTotalSplitInfo", selectTotalSplitInfo);
		
		return	ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/savePo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> savePo(@RequestBody Map<String, List<Map<String, Object>>> params,	SessionVO sessionVO) {
		
		LOGGER.debug("insertPo : {}", params.toString());
		
		int totCnt	= 0;
		int poId	= 0;
		
		List<Map<String, Object>> addList	= params.get(AppConstants.AUIGRID_ADD);	//	Get grid addList
		List<EgovMap> selectPoInfo	= poManagementService.selectPoInfo(addList.get(0));
		
		if ( 0 < selectPoInfo.size() ) {
			//	Exist Po Master(SCM0052M)
			//	poId
			poId	= Integer.parseInt(selectPoInfo.get(0).get("poId").toString());
			for ( Map<String, Object> list : addList ) {
				list.put("poId", poId);
			}
			totCnt	= poManagementService.insertPoDetail(addList, sessionVO);
			LOGGER.debug("Insert Po Detail Exist totCnt : ", totCnt);
		} else {
			//	None Po Master(SCM0052M)
			totCnt	= poManagementService.insertPoMaster(addList.get(0), sessionVO);
			LOGGER.debug("Insert Po Master totCnt : ", totCnt);
			
			selectPoInfo	= poManagementService.selectPoInfo(addList.get(0));
			poId	= Integer.parseInt(selectPoInfo.get(0).get("poId").toString());
			for ( Map<String, Object> list : addList ) {
				list.put("poId", poId);
			}
			
			if ( 1 == totCnt ) {
				//	Insert Po Detail(SCM0053D)
				totCnt	= poManagementService.insertPoDetail(addList, sessionVO);
				LOGGER.debug("Insert Po Detail not Exist totCnt : ", totCnt);
			}
		}
		
		ReturnMessage message = new ReturnMessage();
		
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		/*
		message.setCode(AppConstants.FAIL);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));*/
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/deletePo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deletePo(@RequestBody Map<String, List<Map<String, Object>>> params,	SessionVO sessionVO) {
		
		int totCnt	= 0;
		List<Map<String, Object>> delList	= params.get(AppConstants.AUIGRID_CHECK);
		
		totCnt	= poManagementService.updatePoDetailDel(delList, sessionVO);
		
		ReturnMessage message = new ReturnMessage();
		
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		/*
		message.setCode(AppConstants.FAIL);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));*/
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectPoSummary.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectPoSummary(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectPoSummary : {}", params.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		List<EgovMap> selectPoSummary	= poManagementService.selectPoSummary(params);
		List<EgovMap> selectPoApprList	= poManagementService.selectPoApprList(params);
		
		map.put("selectPoSummary", selectPoSummary);
		map.put("selectPoApprList", selectPoApprList);
		
		return	ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/approvePo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> approvePo(@RequestBody Map<String, List<Map<String, Object>>> params,	SessionVO sessionVO) {
		
		int totCnt	= 0;
		List<Map<String, Object>> chkList	= params.get(AppConstants.AUIGRID_CHECK);
		ReturnMessage message = new ReturnMessage();
		
		totCnt	= poManagementService.updatePoApprove(chkList, sessionVO);
		
		if ( 0 < totCnt ) {
			//	po approve success
			LOGGER.debug("totCnt after po approve : " + totCnt);
			totCnt	= scmInterfaceManagementService.scmIf155(chkList, sessionVO);
			LOGGER.debug("totCnt after po interface : " + totCnt);
		} else {
			message.setCode(AppConstants.FAIL);
			message.setData(totCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		/*
		message.setCode(AppConstants.FAIL);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));*/
		
		return ResponseEntity.ok(message);
	}
	
	
	/**********************************************/
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
		List<Map<String, Object>> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		//List<Map<String, Object>> updList = params.get(AppConstants.AUIGRID_UPDATE); // Get grid addList

		int tmpCnt = 0;
		int totCnt = 0;

		LOGGER.info("InsUpdPoIssueItem_수정 >> Add_Size: {}, params: {}", addList.size(),  params.toString());

		if (addList.size() > 0 )
		{
			// Step1. Update SCMPrePOItem   Step2. Insert SCMPODetail
			tmpCnt = poMngementService.updatePOIssuItem(addList, sessionVO.getUserId());
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

		Map<String, Object> map = new HashMap<>();

		//main Data
		map.put("selectOtdStatusViewList", selectOtdStatusViewList);

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