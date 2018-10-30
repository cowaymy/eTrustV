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
		
		Map<String, Object> map	= new HashMap<>();
		
		List<EgovMap> selectSalesPlanHeader	= salesPlanManagementService.selectSalesPlanHeader(params);
		List<EgovMap> selectSalesPlanInfo	= salesPlanManagementService.selectSalesPlanInfo(params);
		
		map.put("selectSalesPlanHeader", selectSalesPlanHeader);
		
		if ( ! selectSalesPlanInfo.isEmpty() ) {
			LOGGER.debug("planMonth_map : {}", selectSalesPlanInfo.get(0).toString());
			String planMonth	= String.valueOf(selectSalesPlanInfo.get(0).get("planMonth"));
			LOGGER.debug("planMonth : {}", planMonth);
			
			((Map<String, Object>) params).put("planMonth", planMonth);
			LOGGER.debug("selectSalesPlanHeader : {}", params.toString());
			
			List<EgovMap> selectSplitInfo	= salesPlanManagementService.selectSplitInfo(params);
			List<EgovMap> selectChildField	= salesPlanManagementService.selectChildField(params);
			
			LOGGER.debug("selectSplitInfo : {}", selectSplitInfo.toString());
			LOGGER.debug("selectChildField : {}", selectChildField.toString());
			
			map.put("selectSalesPlanInfo", selectSalesPlanInfo);
			map.put("selectSplitInfo", selectSplitInfo);
			map.put("selectChildField", selectChildField);
		}
		
		return	ResponseEntity.ok(map);
	}
	
	//	search each team
	@RequestMapping(value = "/selectSalesPlanList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSalesPlanList(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectSalesPlanList : {}", params.toString());
		List<EgovMap> selectSalesPlanList	= salesPlanManagementService.selectSalesPlanList(params);
		Map<String, Object> map	= new HashMap<>();
		map.put("selectSalesPlanList", selectSalesPlanList);
		
		return	ResponseEntity.ok(map);
	}
	
	//	search all
	@RequestMapping(value = "/selectSalesPlanListAll.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSalesPlanListAll(@RequestBody Map<String, Object> params) {
		
		LOGGER.debug("selectSalesPlanListAll : {}", params.toString());
		List<EgovMap> selectSalesPlanListAll	= salesPlanManagementService.selectSalesPlanListAll(params);
		Map<String, Object> map	= new HashMap<>();
		map.put("selectSalesPlanList", selectSalesPlanListAll);
		
		return	ResponseEntity.ok(map);
	}
	
	//	create
	@RequestMapping(value = "/insertSalesPlanMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertSalesPlanMaster(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		
		LOGGER.debug("insertSalesPlanMaster : {}", params);
		
		int createCnt	= 0;
		String befPlan	= "";	String thisPlan	= "";
		ReturnMessage message	= new ReturnMessage();
		
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
}