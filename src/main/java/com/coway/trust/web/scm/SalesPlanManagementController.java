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
	private SalesPlanMngementService salesPlanMngementService;
	
	@Autowired
	private ScmCommonService scmCommonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	//	view
	@RequestMapping(value = "/salesPlanManagerView.do")
	public String salesPlanManagerView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/salesPlanManagement";
	}
	
	/*
	 * Sales Plan Manager
	 */
	//	combo box
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
	
	//	search header
	@RequestMapping(value = "/selectSalesPlanHeader.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSalesPlanHeader(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectSalesPlanHeader : {}", params.toString());
		
		String headFrom	= "";
		String headTo	= "";
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> param1	= new HashMap<>();
		
		List<EgovMap> selectScmTotalInfo	= scmCommonService.selectScmTotalInfo(params);
		headFrom	= selectScmTotalInfo.get(0).get("headFrom").toString();
		headTo		= selectScmTotalInfo.get(0).get("headTo").toString();
		param1.put("headFrom", headFrom);
		param1.put("headTo", headTo);
		
		List<EgovMap> selectSalesPlanHeader	= salesPlanManagementService.selectSalesPlanHeader(param1);
		
		map.put("selectScmTotalInfo", selectScmTotalInfo);
		map.put("selectSalesPlanHeader", selectSalesPlanHeader);
		
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
		
		map.put("selectSalesPlanInfo", selectSalesPlanInfo);
		map.put("selectSalesPlanList", selectSalesPlanList);
		
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
		
		List<EgovMap> selectSalesPlanInfo	= salesPlanManagementService.selectSalesPlanInfo(param1);
		List<EgovMap> selectSalesPlanListAll	= salesPlanManagementService.selectSalesPlanListAll(params);
		
		map.put("selectSalesPlanInfo", selectSalesPlanInfo);
		map.put("selectSalesPlanList", selectSalesPlanListAll);
		
		return	ResponseEntity.ok(map);
	}
	
	//	create
	@RequestMapping(value = "/insertSalesPlanMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertSalesPlanMaster(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("insertSalesPlanMaster : {}", params);
		
		int totCnt	= 0;
		//String befPlan	= "";	String thisPlan	= "";
		ReturnMessage message	= new ReturnMessage();
		/*
		List<EgovMap> selectCreateCheck = salesPlanManagementService.selectCreateCheck(params);
		LOGGER.debug("selectCreateCheck : {}", selectCreateCheck);
		befPlan		= selectCreateCheck.get(0).get("befPlan").toString();
		thisPlan	= selectCreateCheck.get(0).get("thisPlan").toString();
		
		if ( "0".equals(befPlan) ) {
			message.setCode("98");		//	BEFORE WEEK MUST HAVE TO CREATED
			message.setData(createCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		} else if ( "1".equals(thisPlan) ) {
			message.setCode("97");		//	THIS WEEK ALREADY CREATED
			message.setData(createCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		} else {
			createCnt	= salesPlanManagementService.insertSalesPlanMaster(params, sessionVO);
			message.setCode(AppConstants.SUCCESS);
			message.setData(createCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}*/
		totCnt	= salesPlanManagementService.insertSalesPlanMaster(params, sessionVO);
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
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
	
	@RequestMapping(value = "/selectPeriodByYear.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPeriodByYearList(@RequestParam Map<String, Object> params) {

		LOGGER.debug("selectPeriodByYearList : {}", params.toString());

		List<EgovMap> selectPeriodByYearList = salesPlanMngementService.selectPeriodByYear(params);
		return ResponseEntity.ok(selectPeriodByYearList);
	}
	
	@RequestMapping(value = "/selectStockCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStockCode(@RequestParam Map<String, Object> params )
	 {
		LOGGER.debug("selectStockCode : {}", params.toString());

		List<EgovMap> selectStockCodeList = salesPlanMngementService.selectStockCode(params);
		return ResponseEntity.ok(selectStockCodeList);
	}
}