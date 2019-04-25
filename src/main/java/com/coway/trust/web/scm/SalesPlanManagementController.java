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
import com.coway.trust.biz.scm.SalesPlanManagementService;
import com.coway.trust.biz.scm.SalesPlanMngementService;
import com.coway.trust.biz.scm.ScmCommonService;
import com.coway.trust.biz.scm.SupplyPlanManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class SalesPlanManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SalesPlanManagementController.class);

	@Autowired
	private SalesPlanManagementService salesPlanManagementService;
	
	@Autowired
	private SupplyPlanManagementService supplyPlanManagementService;
	
	@Autowired
	private ScmCommonService scmCommonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	//	view
	@RequestMapping(value = "/salesPlanManagerView.do")
	public String salesPlanManagerView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/salesPlanManagement";
	}
	
	//	view
	@RequestMapping(value = "/salesPlanSummaryView.do")
	public String salesPlanSummary(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/salesPlanSummary";
	}
	
	/*
	 * Sales Plan Manager
	 */
	//	combo box
	@RequestMapping(value = "/selectScmTotalPeriod.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectScmTotalPeriod(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmTotalPeriod : {}", params.toString());
		
		List<EgovMap> selectScmTotalPeriod	= scmCommonService.selectScmTotalPeriod(params);
		List<EgovMap> selectScmYear	= scmCommonService.selectScmYear(params);
		params.put("scmYear", Integer.parseInt(selectScmTotalPeriod.get(0).get("scmYear").toString()));
		List<EgovMap> selectScmWeek	= scmCommonService.selectScmWeek(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		map.put("selectScmTotalPeriod", selectScmTotalPeriod);
		map.put("selectScmYear", selectScmYear);
		map.put("selectScmWeek", selectScmWeek);
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectScmTotalPeriod1.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectScmTotalPeriod1(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectScmTotalPeriod : {}", params.toString());
		
		List<EgovMap> selectScmTotalPeriod= scmCommonService.selectScmTotalPeriod(params);
		List<EgovMap> selectScmYear	= scmCommonService.selectScmYear(params);
		params.put("scmYear", Integer.parseInt(selectScmTotalPeriod.get(0).get("scmYear").toString()));
		List<EgovMap> selectScmWeek	= scmCommonService.selectScmWeek(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		map.put("selectScmTotalPeriod", selectScmTotalPeriod);
		map.put("selectScmYear", selectScmYear);
		map.put("selectScmWeek", selectScmWeek);
		
		return	ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/selectScmYear.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmYear(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmYear : {}", params.toString());
		
		List<EgovMap> selectScmYear	= scmCommonService.selectScmYear(params);
		return ResponseEntity.ok(selectScmYear);
	}
	@RequestMapping(value = "/selectScmWeek.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmWeek(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmWeek : {}", params.toString());
		
		List<EgovMap> selectScmWeek	= scmCommonService.selectScmWeek(params);
		return ResponseEntity.ok(selectScmWeek);
	}
	@RequestMapping(value = "/selectScmTeam.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmTeam(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmTeam : {}", params.toString());
		
		List<EgovMap> selectScmTeam	= scmCommonService.selectScmTeam(params);
		return ResponseEntity.ok(selectScmTeam);
	}
	@RequestMapping(value = "/selectScmStockCategory.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmStockCategory(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmStockCategory : {}", params.toString());
		
		List<EgovMap> selectScmStockCategory	= scmCommonService.selectScmStockCategory(params);
		return ResponseEntity.ok(selectScmStockCategory);
	}
	@RequestMapping(value = "/selectScmStockType.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmStockType(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmStockType : {}", params.toString());
		
		List<EgovMap> selectScmStockType	= scmCommonService.selectScmStockType(params);
		return ResponseEntity.ok(selectScmStockType);
	}
	@RequestMapping(value = "/selectScmStockCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmStockCode(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmStockCode : {}", params.toString());
		
		List<EgovMap> selectScmStockCode	= scmCommonService.selectScmStockCode(params);
		return ResponseEntity.ok(selectScmStockCode);
	}
	
	@RequestMapping(value = "/selectScmStockCodeForMulti.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmStockCodeForMulti(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmStockCodeForMulti : {}", params.toString());
		
		List<EgovMap> selectScmStockCodeForMulti	= scmCommonService.selectScmStockCodeForMulti(params);
		return ResponseEntity.ok(selectScmStockCodeForMulti);
	}
	
	//	search header
	@RequestMapping(value = "/selectSalesPlanHeader.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSalesPlanHeader(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectSalesPlanHeader : {}", params.toString());
		
		String headFrom	= "";
		String headTo	= "";
		int planYear	= 0;	int befWeekYear	= 0;
		int planWeek	= 0;	int befWeekWeek	= 0;
		String team	= "";
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> param1	= new HashMap<>();
		
		List<EgovMap> selectScmTotalInfo	= scmCommonService.selectScmTotalInfo(params);
		headFrom	= selectScmTotalInfo.get(0).get("headFrom").toString();
		headTo		= selectScmTotalInfo.get(0).get("headTo").toString();
		param1.put("headFrom", headFrom);
		param1.put("headTo", headTo);
		
		planYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("planYear").toString());
		planWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeek").toString());
		befWeekYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekYear").toString());
		befWeekWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekWeek").toString());
		if ( null != params.get("scmTeamCbBox") ) {
			team	= params.get("scmTeamCbBox").toString();
		}
		
		param1.put("planYear", planYear);
		param1.put("planWeek", planWeek);
		param1.put("befWeekYear", befWeekYear);
		param1.put("befWeekWeek", befWeekWeek);
		param1.put("team", team);
		
		List<EgovMap> selectSalesPlanInfo	= salesPlanManagementService.selectSalesPlanInfo(param1);
		List<EgovMap> selectSalesPlanHeader	= salesPlanManagementService.selectSalesPlanHeader(param1);
		List<EgovMap> selectSalesPlanSummaryHeader	= salesPlanManagementService.selectSalesPlanSummaryHeader(param1);
		
		Map<String, Object> targetParams = new HashMap<String, Object>();
		targetParams.put("planYear", selectScmTotalInfo.get(0).get("planYear"));
		targetParams.put("planMonth", selectScmTotalInfo.get(0).get("planMonth"));
		targetParams.put("planWeekTh", selectScmTotalInfo.get(0).get("planWeekTh"));
		targetParams.put("planFstSpltWeek", selectScmTotalInfo.get(0).get("planFstSpltWeek"));
		targetParams.put("planYearLstWeek", selectScmTotalInfo.get(0).get("planYearLstWeek"));
		targetParams.put("leadTm", selectScmTotalInfo.get(0).get("leadTm"));
		targetParams.put("planGrWeek", selectScmTotalInfo.get(0).get("planGrWeek"));
		List<EgovMap> selectGetPoCntTargetCnt	= supplyPlanManagementService.selectGetPoCntTargetCnt(targetParams);
		
		map.put("selectScmTotalInfo", selectScmTotalInfo);
		map.put("selectSalesPlanInfo", selectSalesPlanInfo);
		map.put("selectSalesPlanHeader", selectSalesPlanHeader);
		map.put("selectGetPoCntTargetCnt", selectGetPoCntTargetCnt);
		map.put("selectSalesPlanSummaryHeader", selectSalesPlanSummaryHeader);
		
		return	ResponseEntity.ok(map);
	}
	
	//	search each team
	@RequestMapping(value = "/selectSalesPlanList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSalesPlanList(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectSalesPlanList : {}", params.toString());
		
		int planYear	= 0;	int befWeekYear	= 0;
		int planWeek	= 0;	int befWeekWeek	= 0;
		String team	= "";
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> param1	= new HashMap<>();
		
		List<EgovMap> selectScmTotalInfo	= scmCommonService.selectScmTotalInfo(params);
		planYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("planYear").toString());
		planWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeek").toString());
		befWeekYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekYear").toString());
		befWeekWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekWeek").toString());
		team	= params.get("scmTeamCbBox").toString();
		
		param1.put("planYear", planYear);
		param1.put("planWeek", planWeek);
		param1.put("befWeekYear", befWeekYear);
		param1.put("befWeekWeek", befWeekWeek);
		param1.put("team", team);
		
		List<EgovMap> selectSalesPlanInfo	= salesPlanManagementService.selectSalesPlanInfo(param1);
		List<EgovMap> selectSalesPlanList	= salesPlanManagementService.selectSalesPlanList(params);
		List<EgovMap> selectSalesPlanSummaryList	= salesPlanManagementService.selectSalesPlanSummaryList(param1);
		
		map.put("selectSalesPlanInfo", selectSalesPlanInfo);
		map.put("selectSalesPlanList", selectSalesPlanList);
		map.put("selectSalesPlanSummaryList", selectSalesPlanSummaryList);
		
		return	ResponseEntity.ok(map);
	}
	
	//	search all
	@RequestMapping(value = "/selectSalesPlanListAll.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSalesPlanListAll(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectSalesPlanListAll : {}", params.toString());
		
		int planYear	= 0;	int befWeekYear	= 0;
		int planWeek	= 0;	int befWeekWeek	= 0;
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> param1	= new HashMap<>();
		
		List<EgovMap> selectScmTotalInfo	= scmCommonService.selectScmTotalInfo(params);
		planYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("planYear").toString());
		planWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeek").toString());
		befWeekYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekYear").toString());
		befWeekWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekWeek").toString());
		
		param1.put("planYear", planYear);
		param1.put("planWeek", planWeek);
		param1.put("befWeekYear", befWeekYear);
		param1.put("befWeekWeek", befWeekWeek);
		param1.put("team", "");
		
		List<EgovMap> selectSalesPlanInfo	= salesPlanManagementService.selectSalesPlanInfo(param1);
		List<EgovMap> selectSalesPlanListAll	= salesPlanManagementService.selectSalesPlanListAll(params);
		List<EgovMap> selectSalesPlanSummaryList	= salesPlanManagementService.selectSalesPlanSummaryList(param1);
		
		map.put("selectSalesPlanInfo", selectSalesPlanInfo);
		map.put("selectSalesPlanList", selectSalesPlanListAll);
		map.put("selectSalesPlanSummaryList", selectSalesPlanSummaryList);
		
		return	ResponseEntity.ok(map);
	}
	
	//	create
	@RequestMapping(value = "/insertSalesPlanMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertSalesPlanMaster(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("insertSalesPlanMaster : {}", params);
		
		int totCnt	= 0;
		ReturnMessage message	= new ReturnMessage();
		
		//	paramsinsertSalesPlanMaster
		params.put("planYear", params.get("scmYearCbBox").toString());
		params.put("planWeek", params.get("scmWeekCbBox").toString());
		params.put("team", params.get("scmTeamCbBox").toString());
		List<EgovMap> selectSalesPlanInfo	= salesPlanManagementService.selectSalesPlanInfo(params);
		LOGGER.debug("selectSalesPlanInfo : {}", selectSalesPlanInfo);
		if ( "Y".equals(params.get("reCalcYn").toString()) ) {
			LOGGER.debug("Sales Plan reCalculation");
			salesPlanManagementService.deleteSalesPlanMaster(params, sessionVO);
			totCnt	= salesPlanManagementService.insertSalesPlanMaster(params, sessionVO);
			message.setCode(AppConstants.SUCCESS);
			message.setData(totCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			if ( "0".equals(selectSalesPlanInfo.get(0).get("planStusId").toString()) ) {
				LOGGER.debug("Sales Plan is creating");
				totCnt	= salesPlanManagementService.insertSalesPlanMaster(params, sessionVO);
				message.setCode(AppConstants.SUCCESS);
				message.setData(totCnt);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			} else {
				LOGGER.debug("Sales Plan is already created");
				message.setCode(AppConstants.FAIL);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
			}
		}
		
		return	ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateSalesPlanDetail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateSalesPlanDetail(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		
		int updCnt	= 0;
		List<Object> updList	= params.get(AppConstants.AUIGRID_UPDATE);
		LOGGER.info("updateSalesPlanDetail : {}", updList.toString());
		
		if ( 0 < updList.size() ) {
			updCnt	= salesPlanManagementService.updateSalesPlanDetail(updList, sessionVO);
		} else {
			LOGGER.info("updateSalesPlanDetail : no changed");
		}
		
		LOGGER.info("updCnt : ", updCnt);
		
		ReturnMessage message	= new ReturnMessage();
		
		if ( 0 < updCnt ) {
			message.setCode(AppConstants.SUCCESS);
			message.setData(updCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		
		return	ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateSalesPlanMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateSalesPlanMaster(@RequestBody Map<String, Object> params, SessionVO sessionVO) {
		
		int updCnt	= 0;
		LOGGER.info("updateSalesPlanMaster : {}", params.toString());
		
		updCnt	= salesPlanManagementService.updateSalesPlanMaster(params, sessionVO);
		
		ReturnMessage message	= new ReturnMessage();
		
		if ( 0 < updCnt ) {
			message.setCode(AppConstants.SUCCESS);
			message.setData(updCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		
		return	ResponseEntity.ok(message);
	}
	
	/*
	 * Sales Plan Summary View
	 */
	//	search all
	@RequestMapping(value = "/selectSalesPlanSummaryList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSalesPlanSummaryList(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectSalesPlanSummaryList : {}", params.toString());
		
		int planYear	= 0;	int befWeekYear	= 0;
		int planWeek	= 0;	int befWeekWeek	= 0;
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> param1	= new HashMap<>();
		
		List<EgovMap> selectScmTotalInfo	= scmCommonService.selectScmTotalInfo(params);
		planYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("planYear").toString());
		planWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeek").toString());
		befWeekYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekYear").toString());
		befWeekWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("befWeekWeek").toString());
		
		param1.put("planYear", planYear);
		param1.put("planWeek", planWeek);
		param1.put("befWeekYear", befWeekYear);
		param1.put("befWeekWeek", befWeekWeek);
		
		List<EgovMap> selectSalesPlanInfo	= salesPlanManagementService.selectSalesPlanInfo(param1);
		List<EgovMap> selectSalesPlanSummaryList	= salesPlanManagementService.selectSalesPlanSummaryList(params);
		
		map.put("selectSalesPlanInfo", selectSalesPlanInfo);
		map.put("selectSalesPlanSummaryList", selectSalesPlanSummaryList);
		
		return	ResponseEntity.ok(map);
	}
}