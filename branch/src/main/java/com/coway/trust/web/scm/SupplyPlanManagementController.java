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
import com.coway.trust.biz.scm.SupplyPlanManagementService;
import com.coway.trust.biz.scm.SalesPlanManagementService;
import com.coway.trust.biz.scm.SalesPlanMngementService;
import com.coway.trust.biz.scm.ScmCommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class SupplyPlanManagementController {
	private static final Logger LOGGER = LoggerFactory.getLogger(SupplyPlanManagementController.class);

	@Autowired
	private SupplyPlanManagementService supplyPlanManagementService;

	@Autowired
	private ScmCommonService scmCommonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/supplyPlanManager.do")
	public String supplyPlanManagement(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return "/scm/supplyPlanManagement";
	}
	@RequestMapping(value = "/supplyPlanPsi1Pop.do")
	public String supplyPlanPsi1Pop(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		
		LOGGER.debug("supplyPlanPsi1Pop : {}", params.toString());
		
		//	POPUP으로 넘길 파라미터
		model.addAttribute("params", params);
		
		return "/scm/supplyPlanPsi1Pop";
	}
	@RequestMapping(value = "/supplyPlanSummary.do")
	public String supplyPlanSummary(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return "/scm/supplyPlanSummary";
	}
	@RequestMapping(value = "/selectScmCdc.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmCdc(@RequestParam Map<String, Object> params) {
		LOGGER.debug("selectScmCdc : {}", params.toString());

		List<EgovMap> selectScmCdc = scmCommonService.selectScmCdc(params);

		return ResponseEntity.ok(selectScmCdc);
	}
	
	/*
	 * Supply Plan By CDC
	 */
	@RequestMapping(value = "/selectSupplyPlanHeader.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSupplyPlanHeader(@RequestBody Map<String, Object> params) {

		LOGGER.debug("selectSupplyPlanHeader : {}", params.toString());
		
		String headFrom	= "";
		String headTo	= "";
		//int planYear	= 0;
		//int planWeek	= 0;
		//String cdc	= "";
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> param1	= new HashMap<>();
		
		List<EgovMap> selectScmTotalInfo	= scmCommonService.selectScmTotalInfo(params);
		headFrom	= selectScmTotalInfo.get(0).get("headFrom").toString();
		headTo		= selectScmTotalInfo.get(0).get("headTo").toString();
		param1.put("headFrom", headFrom);
		param1.put("headTo", headTo);
		/*
		planYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("planYear").toString());
		planWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeek").toString());
		cdc	= params.get("scmCdcCbBox").toString();
		param1.put("planYear", planYear);
		param1.put("planWeek", planWeek);
		param1.put("cdc", cdc);
		*/
		List<EgovMap> selectSupplyPlanHeader	= supplyPlanManagementService.selectSupplyPlanHeader(param1);
		//List<EgovMap> selectSupplyPlanInfo		= supplyPlanManagementService.selectSupplyPlanInfo(params);
		
		Map<String, Object> targetParams = new HashMap<String, Object>();
		//LOGGER.debug("planFstWeek : " + planFstWeek + ", planFstSpltWeekk : " + planFstSpltWeek + ", planWeekTh : " + planWeekTh);
		targetParams.put("planYear", selectScmTotalInfo.get(0).get("planYear"));
		targetParams.put("planMonth", selectScmTotalInfo.get(0).get("planMonth"));
		targetParams.put("planWeekTh", selectScmTotalInfo.get(0).get("planWeekTh"));
		targetParams.put("planFstSpltWeek", selectScmTotalInfo.get(0).get("planFstSpltWeek"));
		targetParams.put("planYearLstWeek", selectScmTotalInfo.get(0).get("planYearLstWeek"));
		targetParams.put("leadTm", selectScmTotalInfo.get(0).get("leadTm"));
		targetParams.put("planGrWeek", selectScmTotalInfo.get(0).get("planGrWeek"));
		List<EgovMap> selectGetPoCntTargetCnt	= supplyPlanManagementService.selectGetPoCntTargetCnt(targetParams);
		
		map.put("selectScmTotalInfo", selectScmTotalInfo);
		map.put("selectGetPoCntTargetCnt", selectGetPoCntTargetCnt);
		//map.put("selectSupplyPlanInfo", selectSupplyPlanInfo);
		map.put("selectSupplyPlanHeader", selectSupplyPlanHeader);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectSupplyPlanList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSupplyPlanList(@RequestBody Map<String, Object> params) {

		LOGGER.debug("selectSupplyPlanList : {}", params.toString());
		
		int planYear	= 0;
		int planWeek	= 0;
		String cdc	= "";
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> param1	= new HashMap<>();
		
		List<EgovMap> selectScmTotalInfo	= scmCommonService.selectScmTotalInfo(params);
		planYear	= Integer.parseInt(selectScmTotalInfo.get(0).get("planYear").toString());
		planWeek	= Integer.parseInt(selectScmTotalInfo.get(0).get("planWeek").toString());
		cdc	= params.get("scmCdcCbBox").toString();
		
		param1.put("planYear", planYear);
		param1.put("planWeek", planWeek);
		param1.put("cdc", cdc);
		
		List<EgovMap> selectSupplyPlanInfo	= supplyPlanManagementService.selectSupplyPlanInfo(param1);
		List<EgovMap> selectSupplyPlanList	= supplyPlanManagementService.selectSupplyPlanList(params);

		map.put("selectSupplyPlanInfo", selectSupplyPlanInfo);
		map.put("selectSupplyPlanList", selectSupplyPlanList);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/insertSupplyPlanMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertSupplyPlanMaster(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("insertSupplyPlanMaster : {}", params);

		int totCnt = 0;
		ReturnMessage message = new ReturnMessage();
		
		//	params
		params.put("planYear", params.get("scmYearCbBox").toString());
		params.put("planWeek", params.get("scmWeekCbBox").toString());
		params.put("cdc", params.get("scmCdcCbBox").toString());
		List<EgovMap> selectSupplyPlanInfo	= supplyPlanManagementService.selectSupplyPlanInfo(params);
		LOGGER.debug("selectSupplyPlanInfo : {}", selectSupplyPlanInfo);
		if ( "Y".equals(params.get("reCalcYn").toString()) ) {
			LOGGER.debug("Supply Plan reCalculation");
			supplyPlanManagementService.deleteSupplyPlanMaster(params, sessionVO);
			totCnt	= supplyPlanManagementService.insertSupplyPlanMaster(params, sessionVO);
			message.setCode(AppConstants.SUCCESS);
			message.setData(totCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			if ( "0".equals(selectSupplyPlanInfo.get(1).get("planStusId").toString()) ) {
				LOGGER.debug("Supply Plan is creating");
				totCnt	= supplyPlanManagementService.insertSupplyPlanMaster(params, sessionVO);
				message.setCode(AppConstants.SUCCESS);
				message.setData(totCnt);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			} else {
				LOGGER.debug("Supply Plan is already created");
				message.setCode(AppConstants.FAIL);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
			}
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateSupplyPlanDetail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateSupplyPlanDetail(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		
		int updCnt = 0;
		List<Object> updList = params.get(AppConstants.AUIGRID_UPDATE);
		LOGGER.info("updateSupplyPlanDetail : {}", params.toString());

		if (0 < updList.size()) {
			updCnt = supplyPlanManagementService.updateSupplyPlanDetail(updList, sessionVO);
		} else {
			LOGGER.info("updateSupplyPlanDetail : no changed");
		}

		LOGGER.info("updCnt : ", updCnt);

		ReturnMessage message = new ReturnMessage();

		if ( 0 < updCnt ) {
			message.setCode(AppConstants.SUCCESS);
			message.setData(updCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateSupplyPlanMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateSupplyPlanMaster(@RequestBody Map<String, Object> params,
			SessionVO sessionVO) {

		int updCnt = 0;
		LOGGER.info("updateSupplyPlanMaster : {}", params.toString());

		updCnt = supplyPlanManagementService.updateSupplyPlanMaster(params, sessionVO);

		ReturnMessage message = new ReturnMessage();

		if (0 < updCnt) {
			message.setCode(AppConstants.SUCCESS);
			message.setData(updCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/selectSupplyPlanPsi1.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSupplyPlanPsi1(@RequestBody Map<String, Object> params) {

		LOGGER.debug("selectSupplyPlanPsi1 org : {}", params.toString());
		
		String stockCode	= "";
		String monFrom1	= "";	String monFrom2	= "";	String monFrom3	= "";
		String monTo1	= "";	String monTo2	= "";	String monTo3	= "";
		
		Map<String, Object> map	= new HashMap<>();
		Map<String, Object> param1	= new HashMap<>();
		
		List<EgovMap> selectScmTotalInfo	= scmCommonService.selectScmTotalInfo(params);
		monFrom1	= selectScmTotalInfo.get(0).get("monFrom1").toString();
		monFrom2	= selectScmTotalInfo.get(0).get("monFrom2").toString();
		monFrom3	= selectScmTotalInfo.get(0).get("monFrom3").toString();
		monTo1	= selectScmTotalInfo.get(0).get("monTo1").toString();
		monTo2	= selectScmTotalInfo.get(0).get("monTo2").toString();
		monTo3	= selectScmTotalInfo.get(0).get("monTo3").toString();
		stockCode	= params.get("stockCode").toString();
		
		param1.put("monFrom1", monFrom1);
		param1.put("monFrom2", monFrom2);
		param1.put("monFrom3", monFrom3);
		param1.put("monTo1", monTo1);
		param1.put("monTo2", monTo2);
		param1.put("monTo3", monTo3);
		param1.put("stockCode", stockCode);
		LOGGER.debug("selectSupplyPlanPsi1 after : {}", param1.toString());
		List<EgovMap> selectSupplyPlanPsi1	= supplyPlanManagementService.selectSupplyPlanPsi1(param1);

		map.put("selectSupplyPlanPsi1", selectSupplyPlanPsi1);

		return ResponseEntity.ok(map);
	}
	
	/*
	 * Supply Plan Summary View
	 */
	@RequestMapping(value = "/selectSupplyPlanSummaryList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSupplyPlanSummaryList(@RequestBody Map<String, Object> params) {

		LOGGER.debug("selectSupplyPlanSummaryList : {}", params.toString());

		List<EgovMap> selectSupplyPlanSummaryList = supplyPlanManagementService.selectSupplyPlanSummaryList(params);

		Map<String, Object> map = new HashMap<>();

		map.put("selectSupplyPlanSummaryList", selectSupplyPlanSummaryList);

		return ResponseEntity.ok(map);
	}
	/*
	 * @RequestMapping(value = "/selectCalendarHeaderByCdc.do", method =
	 * RequestMethod.POST) public ResponseEntity<Map<String, Object>>
	 * selectCalendarHeaderByCdcList(@RequestBody Map<String, Object> params) {
	 * LOGGER.debug("selectCalendarHeaderList : {}", params.toString());
	 * 
	 * Map<String, Object> map = new HashMap<>();
	 * 
	 * List<EgovMap> selectCalendarHeaderList =
	 * salesPlanMngementService.selectCalendarHeader(params); List<EgovMap>
	 * planByCdcInfo = salesPlanMngementService.selectPlanIdByCdc(params);
	 * 
	 * map.put("header", selectCalendarHeaderList);
	 * 
	 * if (!planByCdcInfo.isEmpty()) { String selectPlanMonthByCdc =
	 * String.valueOf(planByCdcInfo.get(0).get("planMonth")); LOGGER.debug(
	 * "selectPlanMonthByCdc : {}", selectPlanMonthByCdc);
	 * 
	 * ((Map<String, Object>) params).put("selectPlanMonth",
	 * selectPlanMonthByCdc);
	 * 
	 * LOGGER.debug("selectCalendarHeaderList_Params : {}", params.toString());
	 * 
	 * List<EgovMap> seperaionInfo =
	 * salesPlanMngementService.selectSeperation(params); // SCM0018M
	 * List<EgovMap> childFieldList_M0 =
	 * salesPlanMngementService.selectChildField(params);
	 * 
	 * map.put("planByCdcInfo",planByCdcInfo);
	 * map.put("seperaionInfo",seperaionInfo);
	 * map.put("getChildField",childFieldList_M0); }
	 * 
	 * return ResponseEntity.ok(map); } /* @RequestMapping(value =
	 * "/selectScmYear.do", method = RequestMethod.GET) public
	 * ResponseEntity<List<EgovMap>> selectScmYear(@RequestParam Map<String,
	 * Object> params) { LOGGER.debug("selectScmYear : {}", params.toString());
	 * 
	 * List<EgovMap> selectScmYear =
	 * supplyPlanManagementService.selectScmYear(params);
	 * 
	 * return ResponseEntity.ok(selectScmYear); }
	 * 
	 * @RequestMapping(value = "/selectScmWeekByYear.do", method =
	 * RequestMethod.GET) public ResponseEntity<List<EgovMap>>
	 * selectScmWeekByYear(@RequestParam Map<String, Object> params) {
	 * LOGGER.debug("selectScmWeekByYear : {}", params.toString());
	 * 
	 * List<EgovMap> selectScmWeekByYear =
	 * supplyPlanManagementService.selectScmWeekByYear(params);
	 * 
	 * return ResponseEntity.ok(selectScmWeekByYear); }
	 * 
	 * @RequestMapping(value = "/selectScmStockType.do", method =
	 * RequestMethod.GET) public ResponseEntity<List<EgovMap>>
	 * selectScmStockType(@RequestParam Map<String, Object> params) {
	 * LOGGER.debug("selectScmStockType : {}", params.toString());
	 * 
	 * List<EgovMap> selectScmStockType =
	 * supplyPlanManagementService.selectScmStockType(params);
	 * 
	 * return ResponseEntity.ok(selectScmStockType); }
	 * 
	 * @RequestMapping(value = "/selectScmStockCode.do", method =
	 * RequestMethod.GET) public ResponseEntity<List<EgovMap>>
	 * selectScmStockCode(@RequestParam Map<String, Object> params) {
	 * LOGGER.debug("selectScmStockCode : {}", params.toString());
	 * 
	 * List<EgovMap> selectScmStockCode =
	 * supplyPlanManagementService.selectScmStockCode(params);
	 * 
	 * return ResponseEntity.ok(selectScmStockCode); }
	 */
}