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
	private SalesPlanManagementService salesPlanManagementService;

	@Autowired
	private ScmCommonService scmCommonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/supplyPlanManager.do")
	public String login(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return "/scm/supplyPlanManagement";
	}

	// Supply Plan Summary View
	@RequestMapping(value = "/supplyPlanSummary.do")
	public String login2(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return "/scm/supplyPlanSummary";
	}

	@RequestMapping(value = "/selectScmCdc.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmCdc(@RequestParam Map<String, Object> params) {
		LOGGER.debug("selectScmCdc : {}", params.toString());

		List<EgovMap> selectScmCdc = scmCommonService.selectScmCdc(params);

		return ResponseEntity.ok(selectScmCdc);
	}

	@RequestMapping(value = "/selectSupplyPlanHeader.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSupplyPlanHeader(@RequestBody Map<String, Object> params) {

		LOGGER.debug("selectSupplyPlanHeader : {}", params.toString());

		Map<String, Object> map = new HashMap<>();

		List<EgovMap> selectSupplyPlanHeader = supplyPlanManagementService.selectSupplyPlanHeader(params);
		List<EgovMap> selectSupplyPlanInfo = supplyPlanManagementService.selectSupplyPlanInfo(params);
		List<EgovMap> selectTotalSplitInfo = supplyPlanManagementService.selectTotalSplitInfo(params);

		map.put("selectSupplyPlanHeader", selectSupplyPlanHeader);

		if (!selectSupplyPlanInfo.isEmpty()) {
			LOGGER.debug("planMonth : {}", selectSupplyPlanInfo.get(0).toString());
			// String planMonth =
			// String.valueOf(selectSupplyPlanInfo.get(0).get("planMonth"));
			String planMonth = String.valueOf(selectTotalSplitInfo.get(0).get("planMonth"));
			LOGGER.debug("planMonth : {}", planMonth);

			((Map<String, Object>) params).put("planMonth", planMonth);
			LOGGER.debug("selectSupplyPlanHeader : {}", params.toString());

			// List<EgovMap> selectSplitInfo =
			// salesPlanManagementService.selectSplitInfo(params);
			List<EgovMap> selectChildField = salesPlanManagementService.selectChildField(params);

			// LOGGER.debug("selectSplitInfo : {}", selectSplitInfo.toString());
			LOGGER.debug("selectChildField : {}", selectChildField.toString());

			map.put("selectSupplyPlanInfo", selectSupplyPlanInfo);
			map.put("selectTotalSplitInfo", selectTotalSplitInfo);
			// map.put("selectSplitInfo", selectSplitInfo);
			map.put("selectChildField", selectChildField);
		}

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectSupplyPlanList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSupplyPlanList(@RequestBody Map<String, Object> params) {

		LOGGER.debug("selectSupplyPlanList : {}", params.toString());

		List<EgovMap> selectSupplyPlanList = supplyPlanManagementService.selectSupplyPlanList(params);

		Map<String, Object> map = new HashMap<>();

		map.put("selectSupplyPlanList", selectSupplyPlanList);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/insertSupplyPlanMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertSupplyPlanMaster(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {

		LOGGER.debug("insertSupplyPlanMaster : {}", params);

		int totCnt = 0;
		int dtlCnt = 0;

		List<EgovMap> selectSupplyPlanInfo = supplyPlanManagementService.selectSupplyPlanInfo(params);

		ReturnMessage message = new ReturnMessage();

		if (!selectSupplyPlanInfo.isEmpty()) {
			LOGGER.debug("selectSupplyPlanInfo : {}", selectSupplyPlanInfo);
			String salesPlanStusId = String.valueOf(selectSupplyPlanInfo.get(0).get("salesPlanStusId"));
			String supplyPlanStusId = String.valueOf(selectSupplyPlanInfo.get(0).get("supplyPlanStusId"));

			if ("0".equals(supplyPlanStusId)) {
				totCnt = supplyPlanManagementService.insertSupplyPlanMaster(params, sessionVO);
				if (0 < totCnt) {
					message.setCode(AppConstants.SUCCESS);
					message.setData(totCnt);
					message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
				} else {
					message.setCode(AppConstants.FAIL);
					message.setData(totCnt);
					message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
				}
			} else {
				message.setCode(AppConstants.FAIL);
				message.setData(totCnt);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
			}
		} else {
			totCnt = supplyPlanManagementService.insertSupplyPlanMaster(params, sessionVO);
			if (0 < totCnt) {
				message.setCode(AppConstants.SUCCESS);
				message.setData(totCnt);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			} else {
				message.setCode(AppConstants.FAIL);
				message.setData(totCnt);
				message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
			}
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateSupplyPlanMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateSupplyPlanMaster(@RequestBody Map<String, Object> params,
			SessionVO sessionVO) {

		int saveCnt = 0;
		LOGGER.info("updateSupplyPlanMaster : {}", params.toString());

		saveCnt = supplyPlanManagementService.updateSupplyPlanMaster(params, sessionVO);

		ReturnMessage message = new ReturnMessage();

		if (0 < saveCnt) {
			message.setCode(AppConstants.SUCCESS);
			message.setData(saveCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateSupplyPlanDetail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateSupplyPlanDetail(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		int saveCnt = 0;
		List<Object> updList = params.get(AppConstants.AUIGRID_UPDATE);
		LOGGER.info("updateSupplyPlanDetail : {}", params.toString());

		if (0 < updList.size()) {
			saveCnt = supplyPlanManagementService.updateSupplyPlanDetail(updList, sessionVO);
			saveCnt++;
		} else {
			LOGGER.info("updateSupplyPlanDetail : no changed");
		}

		LOGGER.info("saveCnt : ", saveCnt);

		ReturnMessage message = new ReturnMessage();

		if (0 < saveCnt) {
			message.setCode(AppConstants.SUCCESS);
			message.setData(saveCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}

		return ResponseEntity.ok(message);
	}

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