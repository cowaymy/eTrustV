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
import com.coway.trust.biz.scm.SalesPlanMngementService;
import com.coway.trust.biz.scm.ScmMasterMngMentService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmMasterMngmentController {
	
	private static final Logger LOGGER	= LoggerFactory.getLogger(ScmMasterMngmentController.class);
	
	@Autowired
	private ScmMasterMngMentService scmMasterMngMentService;
	
	@Autowired
	private SalesPlanMngementService salesPlanMngementService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	//	view
	@RequestMapping(value = "/scmMasterManagement.do")
	public String masterMngmentView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		//model.addAttribute("languages", loginService.getLanguages());
		return	"/scm/scmMasterManagement";
	}
	
	@RequestMapping(value = "/scmMasterMngmentAddPop.do")
	public String scmMasterMngmentAddPop(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/scmMasterMngmentAddPop";
	}
	
	//	search btn
	@RequestMapping(value = "/selectMasterMngmentSerch.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectMasterMngmentSerch(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectMasterMngmentSerch_Input : {}", params.toString());
		
		List<EgovMap> scmMasterMngMentServiceList	= scmMasterMngMentService.selectMasterMngmentSearch(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		//	main Data
		map.put("scmMasterMngMentServiceList", scmMasterMngMentServiceList);
		
		return	ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/selectInvenCbBoxByStockType.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectInvenCbBoxByStockType(@RequestParam Map<String, Object> params, @RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) {
		LOGGER.debug("selectInvenCbBoxByStockType_Input : {}", params.toString());
		
		List<EgovMap> scmMstMngmtInvenCbBoxByStockTypeList	= scmMasterMngMentService.selectInvenCbBoxByStockType(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		//	main Data
		map.put("scmMstInvenByStockTypeList", scmMstMngmtInvenCbBoxByStockTypeList);
		
		return	ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/selectInvenCbBoxByCategory.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectInvenCbBoxByCategory(@RequestParam Map<String, Object> params, @RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) {
		LOGGER.debug("selectInvenCbBoxByCategory_Input : {}", params.toString());
		
		List<EgovMap> scmMstMngmtInvenCbBoxByCategoryList	= scmMasterMngMentService.selectInvenCbBoxByCategory(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		//	main Data
		map.put("scmMstInvenByCategoryList", scmMstMngmtInvenCbBoxByCategoryList);
		
		return	ResponseEntity.ok(map);
	}
	
	//	PLAN_DETAIL_ID_SEQ
	@RequestMapping(value = "/selectPlanDetailIdSeq.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectPlanDetailIdSeq(@RequestParam Map<String, Object> params, @RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) {
		LOGGER.debug("selectPlanDetailIdSeq_Input : {}", params.toString());
		
		List<EgovMap> selectPlanDetailIdSeq	= salesPlanMngementService.selectPlanDetailIdSeq(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		//	main Data
		map.put("selectPlanDetailIdSeq", selectPlanDetailIdSeq);
		
		return	ResponseEntity.ok(map);
	}
	
	//	save
	@RequestMapping(value = "/saveScmMasterMngment.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveUserExceptAuthMapping(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO) {
		List<Object> udtList	= params.get(AppConstants.AUIGRID_UPDATE);	//	Get gride UpdateList
		List<Object> addList	= params.get(AppConstants.AUIGRID_ADD);		//	Get grid addList
		List<Object> delList	= params.get(AppConstants.AUIGRID_REMOVE);	//	Get grid DeleteList
		
		int tmpCnt	= 0;
		int totCnt	= 0;
		
		if ( 0 < udtList.size() ) {
			tmpCnt	= scmMasterMngMentService.updateMasterMngment(udtList, sessionVO.getUserId());
			totCnt	= totCnt + tmpCnt;
		}
		
		//	콘솔로 찍어보기
		LOGGER.info("scmMasterMngMentService_수정 : {}", udtList.toString());
		LOGGER.info("scmMasterMngMentService_추가 : {}", addList.toString());
		LOGGER.info("scmMasterMngMentService_삭제 : {}", delList.toString());
		LOGGER.info("scmMasterMngMentService_카운트 : {}", totCnt);
		
		//	결과 만들기 예.
		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return	ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/insertMstMngMasterHeader.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertMstMngMasterHeader(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("insertMstMngMasterHeader_params : {}", params);
		
		int tmpCnt	= 0;
		int totCnt	= 0;
		
		tmpCnt	= scmMasterMngMentService.insertMstMngMasterHeader(params, sessionVO);
		totCnt	= totCnt + tmpCnt;
		
		//	결과 만들기 예.
		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return	ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/insertMstMngMasterCDC.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertMstMngMasterCDC(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		LOGGER.debug("insertMstMngMasterCDC_params : {}", params);
		
		int tmpCnt	= 0;
		int totCnt	= 0;
		
		tmpCnt	= scmMasterMngMentService.insertMstMngMasterCDC(params, sessionVO);
		totCnt	= totCnt + tmpCnt;
		
		//	결과 만들기 예.
		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return	ResponseEntity.ok(message);
	}
	
	/*****************************************
	 *   CDC WareHouse MAPPING
	 *****************************************/
	//	view
	@RequestMapping(value = "/cdcWhMappingManager.do")
	public String cdcWareHouseMappingView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		//model.addAttribute("languages", loginService.getLanguages());
		return	"/scm/cdcWhMappingManager";
	}
	
	@RequestMapping(value = "/selectWHouseMappingSerch.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectWhLocationMapping(@RequestParam Map<String, Object> params, @RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) {
		LOGGER.debug("selectWhLocationMapping_Input : {}", params.toString());
		
		List<EgovMap> selectCdcWareMappingList		= scmMasterMngMentService.selectCdcWareMapping(params);
		List<EgovMap> selectWhLocationMappingList	= scmMasterMngMentService.selectWhLocationMapping(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		//	main Data
		map.put("selectCdcWareMappingListList", selectCdcWareMappingList);
		map.put("selectWhLocationMappingList", selectWhLocationMappingList);
		
		return	ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/saveCdcWhMappingList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommMstGrid(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		List<Object> delList	= params.get(AppConstants.AUIGRID_REMOVE);	//	Get gride delList
		List<Object> addList	= params.get(AppConstants.AUIGRID_ADD);		//	Get grid addList
		List<Object> updList	= params.get(AppConstants.AUIGRID_UPDATE);	//	Get grid updList
		
		//	반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		int tmpCnt	= 0;
		int totCnt	= 0;
		
		if ( 0 < updList.size() ) {
			tmpCnt	= scmMasterMngMentService.insetCdcWhMapping(updList, sessionVO.getUserId());
			totCnt	= totCnt + tmpCnt;
		}
		
		if ( 0 < delList.size() ) {
			tmpCnt	= scmMasterMngMentService.deleteCdcWhMapping(delList, sessionVO.getUserId());
			totCnt	= totCnt + tmpCnt;
		}
		
		//	콘솔로 찍어보기
		LOGGER.info("CdcWareHouse_수정 : {}", delList.toString());
		LOGGER.info("CdcWareHouse_추가 : {}", addList.toString());
		LOGGER.info("CdcWareHouse_카운트 : {}", totCnt);
		
		//	결과 만들기 예.
		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return	ResponseEntity.ok(message);
	}
	
	/*****************************************
	 *   Business Plan Manager
	 *****************************************/
	//	view
	@RequestMapping(value = "/businessPlanManager.do")
	public String bizPlanManagerView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		//model.addAttribute("languages", loginService.getLanguages());
		return	"/scm/businessPlanManager";
	}
	
	//	comboBox List setting
	@RequestMapping(value = "/selectVersionCbList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectVersionCbList(@RequestParam Map<String, Object> params) {
		LOGGER.debug("selectVersionCbList_Input : {}", params.toString());
		
		List<EgovMap> selectVersionCbListList	= scmMasterMngMentService.selectVersionCbList(params);
		return	ResponseEntity.ok(selectVersionCbListList);
	}
	
	//	search Btn
	@RequestMapping(value = "/selectBizPlanMngerSearch.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectBizPlanManager(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectBizPlanManager_Input : {}", params.toString());
		
		List<EgovMap> selectBizPlanManagerList	= scmMasterMngMentService.selectBizPlanManager(params);
		List<EgovMap> selectBizPlanStockList	= scmMasterMngMentService.selectBizPlanStock(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		//	main Data
		map.put("selectBizPlanMngerList", selectBizPlanManagerList);
		map.put("selectBizPlanStockList", selectBizPlanStockList);
		
		return	ResponseEntity.ok(map);
	}
	
	//	save plan stock
	@RequestMapping(value = "/saveBizPlanStockGrid.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveBizPlanStockGrid(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		List<Object> delList	= params.get(AppConstants.AUIGRID_REMOVE);	//	Get gride delList
		List<Object> addList	= params.get(AppConstants.AUIGRID_ADD);		//	Get grid addList
		List<Object> updList	= params.get(AppConstants.AUIGRID_UPDATE);	//	Get grid updList
		
		//	반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		int tmpCnt	= 0;
		int totCnt	= 0;
		
		if ( 0 < updList.size() ) {
			tmpCnt	= scmMasterMngMentService.updatePlanStock(updList, sessionVO.getUserId());
			totCnt	= totCnt + tmpCnt;
		}
		/*
		if (delList.size() > 0) {
		tmpCnt = scmMasterMngMentService.deleteCdcWhMapping(delList, sessionVO.getUserId());
		totCnt = totCnt + tmpCnt;
		}*/
		
		//	콘솔로 찍어보기
		LOGGER.info("CdcWareHouse_수정 : {}", delList.toString());
		LOGGER.info("CdcWareHouse_추가 : {}", addList.toString());
		LOGGER.info("CdcWareHouse_카운트 : {}", totCnt);
		
		//	결과 만들기 예.
		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return	ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/insertBizPlanMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertBizPlanMaster(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("insertBizPlanMaster_params : {}", params);
		
		//	반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		int tmpCnt	= 0;
		int totCnt	= 0;
		
		tmpCnt	= scmMasterMngMentService.insertBizPlanMaster(params, sessionVO);
		totCnt	= totCnt + tmpCnt;
		
		//	콘솔로 찍어보기
		//LOGGER.info("insertBizPlanMaster_수정 : {}", addList.toString());
		
		//	결과 만들기 예.
		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return	ResponseEntity.ok(message);
	}
	
	/*****************************************
	 *   Plan Service DashBoard
	 *****************************************/
	//	view
	@RequestMapping(value = "/PSIDashboard.do")
	public String planServiceDashBoardView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		//model.addAttribute("languages", loginService.getLanguages());
		return	"/scm/planSalesDashboard";
	}
	
	//	search btn
	@RequestMapping(value = "/selectChartDataList.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectChartDataList(@RequestParam Map<String, Object> params, @RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) {
		LOGGER.debug("selectChartDataList_Input : {}", params.toString());
		
		List<EgovMap> selectChartDataList	= scmMasterMngMentService.selectChartDataList(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		//	main Data
		map.put("selectChartDataList", selectChartDataList);
		
		return	ResponseEntity.ok(map);
	}
	
	//	Quarter Rate
	@RequestMapping(value = "/selectQuarterRate.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectQuarterRate(@RequestParam Map<String, Object> params, @RequestParam(value = "stockCodeCbBox", required = false) Integer[] stkCodes ) {
		LOGGER.debug("selectQuarterRate_Input : {}", params.toString());
		
		List<EgovMap> selectQuarterRateList	= scmMasterMngMentService.selectQuarterRate(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		//	main Data
		map.put("selectQuarterRateList", selectQuarterRateList);
		
		return ResponseEntity.ok(map);
	}
	
	//	Quarter Rate
	@RequestMapping(value = "/selectPSDashSearchBtnList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectPSDashSearchBtnList(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectPSDashSearchBtnList_Input : {}", params.toString());
		
		List<EgovMap> selectChartDataList	= scmMasterMngMentService.selectChartDataList(params);
		List<EgovMap> selectQuarterRateList	= scmMasterMngMentService.selectQuarterRate(params);
		List<EgovMap> selectPSDashList		= scmMasterMngMentService.selectPSDashList(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		map.put("selectChartDataList", selectChartDataList);		//	ChartList
		map.put("selectQuarterRateList", selectQuarterRateList);	//	Rate
		map.put("selectPSDashList", selectPSDashList);				//	Quarter or Monthly
		
		return	ResponseEntity.ok(map);
	}
}