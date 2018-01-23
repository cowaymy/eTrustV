package com.coway.trust.web.services.servicePlanning;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.servicePlanning.HolidayService;
import com.coway.trust.biz.services.servicePlanning.MileageCalculationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/services/mileageCileage")
public class MileageCalculationController {
	private static final Logger logger = LoggerFactory.getLogger(MileageCalculationController.class);
	
	@Resource(name = "mileageCalculationService")
	private MileageCalculationService mileageCalculationService;
	
	@Resource(name = "holidayService")
	private HolidayService holidayService;
	/**
	 * organization territoryList page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cileageCalculationSchema.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/servicePlanning/mileageCalculationSchemaMgmt";
	}
	
	/**
	 * organization territoryList page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cileageCalculationDCPMaster.do")
	public String initDCPMaster(@RequestParam Map<String, Object> params, ModelMap model) {
		//List<EgovMap> selectArea = mileageCalculationService.selectArea();
		//List<EgovMap> branchList = holidayService.selectBranch();
		//model.addAttribute("selectArea", selectArea);
		//model.addAttribute("branchList", branchList);
		// 호출될 화면
		return "services/servicePlanning/MileageClaimDCPMasterSearch";
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveDCPMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>insertDCPMaster(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		boolean addSuccess = false;
		boolean updateSuccess = false;
		boolean delSuccess = false;
		EgovMap rtm = new EgovMap();
		logger.debug("params {}", params);
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		logger.debug("udtList {}", udtList);
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList
		
		logger.debug("addList {}", addList);
		if(addList != null){
			 mileageCalculationService.insertDCPMaster(addList,sessionVO);
		}
		if(udtList != null){
			 mileageCalculationService.updateDCPMaster(udtList,sessionVO);
		}
		if(delList != null){
//			 mileageCalculationService.deleteDCPMaster(delList,sessionVO);
		}
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cntDCPMaster.do", method = RequestMethod.GET)
	public ResponseEntity<Integer> cntDCPMaster( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		String[] memTypeList = request.getParameterValues("memType");
		String[] mcpFromList = request.getParameterValues("mcpFrom");
		String[] mcpToList = request.getParameterValues("mcpTo");
		String[] branchCodeList = request.getParameterValues("brnch");
		params.put("memTypeList", memTypeList);
		params.put("mcpFromList", mcpFromList);
		params.put("mcpToList", mcpToList);
		params.put("branchCodeList", branchCodeList);
		
		int cnt = mileageCalculationService.selectDCPMasterCount(params);
		
		//logger.debug("totalRowCount : " + totalRowCount);
		return ResponseEntity.ok(cnt);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDCPMaster.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectDCPMaster( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		String[] memTypeList = request.getParameterValues("memType");
		String[] mcpFromList = request.getParameterValues("mcpFrom");
		String[] mcpToList = request.getParameterValues("mcpTo");
		String[] branchCodeList = request.getParameterValues("brnch");
		params.put("memTypeList", memTypeList);
		params.put("mcpFromList", mcpFromList);
		params.put("mcpToList", mcpToList);
		params.put("branchCodeList", branchCodeList);
		
		List<EgovMap> resultList = mileageCalculationService.selectDCPMaster(params);
		int totalRowCount = mileageCalculationService.selectDCPMasterCount(params);
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("resultList", resultList);
		result.put("totalRowCount", totalRowCount);
		
		//logger.debug("resultList {}", resultList);
		logger.debug("totalRowCount : " + totalRowCount);
		return ResponseEntity.ok(result);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDCPMasterPaging.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectDCPMasterPaging( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		String[] memTypeList = request.getParameterValues("memType");
		String[] mcpFromList = request.getParameterValues("mcpFrom");
		String[] mcpToList = request.getParameterValues("mcpTo");
		String[] branchCodeList = request.getParameterValues("brnch");
		params.put("memTypeList", memTypeList);
		params.put("mcpFromList", mcpFromList);
		params.put("mcpToList", mcpToList);
		params.put("branchCodeList", branchCodeList);
		
		List<EgovMap> resultList = mileageCalculationService.selectDCPMaster(params);
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		result.put("resultList", resultList);
		
		//logger.debug("resultList {}", resultList);
		return ResponseEntity.ok(result);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveSchemaMgmt.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>insertSchemaMgmt(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		boolean addSuccess = false;
		boolean updateSuccess = false;
		boolean delSuccess = false;
		EgovMap rtm = new EgovMap();
		logger.debug("params {}", params);
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList
		
		logger.debug("addList {}", addList);
		if(addList != null){
			 mileageCalculationService.insertSchemaMgmt(addList,sessionVO);
		}
		
		if(addList != null){
			 mileageCalculationService.updateSchemaMgmt(udtList,sessionVO);
		}
		if(delList != null){
			 mileageCalculationService.deleteSchemaMgmt(delList,sessionVO);
		}
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSchemaMgmt.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSchemaMgmt( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		String[] memTypeList = request.getParameterValues("memType");
		params.put("memTypeList", memTypeList);
		List<EgovMap> selectSchemaMgmt = mileageCalculationService.selectSchemaMgmt(params);
		logger.debug("selectSchemaMgmt {}", selectSchemaMgmt);
		return ResponseEntity.ok(selectSchemaMgmt);
	}
	
	/**
	 * organization territoryList page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cileageCalculationSchemaResult.do")
	public String mainSchemaResultList(@RequestParam Map<String, Object> params, ModelMap model) {
		//List<EgovMap> branchList = holidayService.selectBranch();
		//model.addAttribute("branchList", branchList);
		// 호출될 화면
		return "services/servicePlanning/mileageCalculationSchemaResult";
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectSchemaResultMgmt.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSchemaResultMgmt( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		String[] branchList = request.getParameterValues("branch");
		String[] memTypeList = request.getParameterValues("memType");
		String[] memCodeList = request.getParameterValues("memCode");
		if(!params.get("branch").toString().equals("")){
			params.put("branchList", branchList);
		}
		params.put("memTypeList", memTypeList);
		params.put("memCodeList", memCodeList);
		List<EgovMap> selectSchemaMgmt = mileageCalculationService.selectSchemaResultMgmt(params);
		logger.debug("selectSchemaMgmt {}", selectSchemaMgmt);
		return ResponseEntity.ok(selectSchemaMgmt);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectArea", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectArea( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> selectArea = mileageCalculationService.selectArea(params);
		logger.debug("selectArea {}", selectArea);
		return ResponseEntity.ok(selectArea);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectBranch", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranch( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> branchList = mileageCalculationService.selectBranch(params);
		//model.addAttribute("branchList", branchList);
		logger.debug("branchList {}", branchList);
		return ResponseEntity.ok(branchList);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectMemberCode", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemberCode( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> memberCode = mileageCalculationService.selectMemberCode(params);
		//model.addAttribute("branchList", branchList);
		logger.debug("memberCode {}", memberCode);
		return ResponseEntity.ok(memberCode);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCity.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCity( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> cityList = mileageCalculationService.selectCity(params);
		//model.addAttribute("branchList", branchList);
		logger.debug("cityList {}", cityList);
		return ResponseEntity.ok(cityList);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDCPFrom.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDCPFrom( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> selectDCPFrom = mileageCalculationService.selectDCPFrom(params);
		logger.debug("selectDCPFrom {}", selectDCPFrom);
		return ResponseEntity.ok(selectDCPFrom);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectDCPTo.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDCPTo( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> selectDCPTo = mileageCalculationService.selectDCPTo(params);
		logger.debug("selectDCPTo {}", selectDCPTo);
		return ResponseEntity.ok(selectDCPTo);
	}
}
