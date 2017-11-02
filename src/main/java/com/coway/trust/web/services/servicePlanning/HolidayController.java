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
import com.coway.trust.biz.services.servicePlanning.impl.HolidayMapper;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.TerritoryManagementController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/holiday")
public class HolidayController {
	private static final Logger logger = LoggerFactory.getLogger(HolidayController.class);
	
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
	@RequestMapping(value = "/initHolidayList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		// 호출될 화면
		return "services/servicePlanning/holidayList";
	}
	

	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveHoliday.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>selectComfirmTerritory(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		boolean addSuccess = false;
		boolean updateSuccess = false;
		boolean delSuccess = false;
		EgovMap rtm = new EgovMap();
		
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList
		
		
		if(addList != null){
			addSuccess = holidayService.insertHoliday(addList,sessionVO);
		}
		if(addList != null){
			updateSuccess = holidayService.updateHoliday(udtList,sessionVO);
		}
		/*if(addList != null){
			addSuccess = holidayService.insertHoliday(addList);
		}*/
		
		if(addSuccess){
			message.setMessage("Save Success Holiday");
		}else{
			message.setMessage("Save Fail Holiday");
		}
		if(updateSuccess){
			message.setMessage("Update Success Holiday");
		}else{
			message.setMessage("Update Fail Holiday");
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
	@RequestMapping(value = "/searchHolidayList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHolidayList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		List<EgovMap> holidayList = holidayService.selectHolidayList(params);
		logger.debug("holidayList {}", holidayList);
		return ResponseEntity.ok(holidayList);
	}
	
	/**
	 * organization territoryList page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/holidayReplacementCT.do")
	public String holidayReplacementCtEntry(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);
		// 호출될 화면
		return "services/servicePlanning/replacementCTEntryPop";
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCTList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectCTList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		
		List<EgovMap> CTList = holidayService.selectCTList(params);
		List<EgovMap> CTAssignList = holidayService.selectAssignCTList(params);
		logger.debug("CTList {}", CTList);
		logger.debug("CTAssignList {}", CTAssignList);
		Map<String, Object> map= new HashMap<String, Object>();
		map.put("CTList", CTList);
		map.put("CTAssignList", CTAssignList);
		return ResponseEntity.ok(map);
	}
	
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchCTAssignList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchCTAssignList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		List<EgovMap> assignList = holidayService.selectCTAssignList(params);
		logger.debug("assignList {}", assignList);
		return ResponseEntity.ok(assignList);
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/CTAssignSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>CTAssignSave(@RequestBody Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		EgovMap rtm = new EgovMap();
		logger.debug("params {}", params);
		Map<String , Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD); 
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);
		logger.debug("formMap {}", formMap);
		logger.debug("updList {}", updList);
		
		boolean success = holidayService.insertCTAssign(updList,formMap);
		boolean delSuccess = holidayService.deleteCTAssign(remList,formMap);
		
		/*boolean success = territoryManagementService.updateMagicAddressCode(params);
		if(success){
			message.setMessage("Confirm Success");
		}else{
			message.setMessage("Confirm Fail");
		}*/
		return ResponseEntity.ok(message);
	}
	
	
	/**
	 * organization territoryList page  
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updatHolidayReplacementCT.do")
	public String updateHolidayReplacementCtEntry(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);
		// 호출될 화면
		return "services/servicePlanning/replacementCTEntryEditPop";
	}
	
	/**
	 * Search rule book management list
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 *//*
	@RequestMapping(value = "/selectAssignCTList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAssignCTList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {

		List<EgovMap> assignCTList = holidayService.selectAssignCTList(params);
		assignCTList.add
		logger.debug("assignCTList {}", assignCTList);
		return ResponseEntity.ok(assignCTList);
	}*/
	
	
}
