package com.coway.trust.web.services.servicePlanning;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.servicePlanning.CTSubGroupListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/services/serviceGroup")
public class CTSubGroupListController {
	private static final Logger logger = LoggerFactory.getLogger(CTSubGroupListController.class);

	@Resource(name = "CTSubGroupListService")
	private CTSubGroupListService CTSubGroupListService;

	/**
	 * Services - Service Planning - Service Group
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/CTSubGroupList.do")
	public String ctSubGroupMain(@RequestParam Map<String, Object> params, ModelMap model) {

		// 호출될 화면
		return "services/servicePlanning/CTSubGroupList";
	}

	/**
	 * Services - Service Planning - Service Group Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCTSubGroup.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCTSubGroup( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> ctSubGroupList = CTSubGroupListService.selectCTSubGroupList(params);
		logger.debug("ctSubGroupList {}", ctSubGroupList);
		return ResponseEntity.ok(ctSubGroupList);
	}

	/**
	 * Services - Service Planning - Service Group Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCTSubAreaGroup.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCTSubAreaGroup( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> ctSubAreaGroupList = CTSubGroupListService.selectCTAreaSubGroupList(params);
		logger.debug("ctSubAreaGroupList {}", ctSubAreaGroupList);
		return ResponseEntity.ok(ctSubAreaGroupList);
	}


	/**
	 * Services - Service Planning - Service Group - CT SUB GROUP SAVE
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCTSubGroup.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCTSubGroup(@RequestBody Map<String, ArrayList<Map<String, Object>>> params, SessionVO sessionVO) {
		List<Map<String, Object>> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		ReturnMessage message = CTSubGroupListService.saveCTSubGroup(udtList, sessionVO);

		return ResponseEntity.ok(message);
	}

	/**
	 * Services - Service Planning - Service Group - CT SUB GROUP SAVE
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveCTSubAreaGroup.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCTSubAreaGroup(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		ReturnMessage message = new ReturnMessage();

		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList

		logger.debug("udtList {}", udtList);
		CTSubGroupListService.insertCTSubAreaGroup(udtList);
		return ResponseEntity.ok(message);
	}

	/**
	 * Services - Service Planning - open CT Sub Group - Area ID Maintenance
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/openAreaMainPop.do")
	public String initAreaMaintenance(@RequestParam Map<String, Object> params, ModelMap model) {

		// 호출될 화면
		return "services/servicePlanning/CTSubGroupAreaIDMainPop";
	}

	/**
	 * Services - Service Planning - Service Group Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCTSubGroupDscList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCTSubGroupDscList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> selectCTSubGroupDscList = CTSubGroupListService.selectCTSubGroupDscList(params);
		logger.debug("selectCTSubGroupDscList {}", selectCTSubGroupDscList);
		return ResponseEntity.ok(selectCTSubGroupDscList);
	}

	/**
	 * Services - Service Planning - Service Group Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCTM", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCTM( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> selectCTSubGroupDscList = CTSubGroupListService.selectCTM(params);
		logger.debug("selectCTSubGroupDscList {}", selectCTSubGroupDscList);
		return ResponseEntity.ok(selectCTSubGroupDscList);
	}

	@RequestMapping(value = "/selectCTMByDSC", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCTMByDSC( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> selectCTSubGroupDscList = CTSubGroupListService.selectCTMByDSC(params);
		logger.debug("selectCTSubGroupDscList {}", selectCTSubGroupDscList);
		return ResponseEntity.ok(selectCTSubGroupDscList);
	}

	@RequestMapping(value = "/selectCTSubGrb", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCTSubGrb( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> selectCTSubGrb = CTSubGroupListService.selectCTSubGrb(params);
		logger.debug("selectCTSubGroupDscList {}", selectCTSubGrb);
		return ResponseEntity.ok(selectCTSubGrb);
	}

	@RequestMapping(value = "/openUpdateRequestPop.do")
	public String initUpdateRequest(@RequestParam Map<String, Object> params, ModelMap model) {

		// 호출될 화면
		return "services/servicePlanning/updateRequestPop";
	}




		@RequestMapping(value = "/ctSubGroupPop.do")
		public String ctSubGroupPop(@RequestParam Map<String, Object> params, ModelMap model) {
			logger.debug("params {}", params);
			model.addAttribute("params", params);

			// 호출될 화면
			return "services/servicePlanning/CTSubGroupPop";
		}



		@RequestMapping(value = "/selectCtSubGrp")
		 ResponseEntity<List<EgovMap>> selectCtSubGrp(@RequestParam Map<String, Object> params, HttpServletRequest request) {
			logger.debug("params1111 {}", params);
			List<EgovMap> CtSubGrps = CTSubGroupListService.selectCTSubGroupMajor(params);
			return ResponseEntity.ok(CtSubGrps);

		}
		@RequestMapping(value = "/CTSubGroupSave.do", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage>ctSubGroupSave(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
			ReturnMessage message = new ReturnMessage();


			List<Object> subGroupList = (List<Object>) params.get("subGroupList");
			logger.debug("subGroupList {}", subGroupList);
			int updateCount = CTSubGroupListService.ctSubGroupSave(params, sessionVO);

			message.setMessage("success");


			return	ResponseEntity.ok(message);


		}

		/**
		 * Group Service Day 팝업창 호출
		 * @Author KR-SH
		 * @Date 2019. 11. 21.
		 * @param params
		 * @param model
		 * @return
		 */
		@RequestMapping(value = "/cTSubGroupServiceDay.do")
		public String cTSubGroupServiceDay(@RequestParam Map<String, Object> params, ModelMap model) {
			model.addAttribute("params", params);

			// 호출될 화면
			return "services/servicePlanning/cTSubGroupServiceDayPop";
		}

	/**
	 * Group Service Day 팝업창 캘린더 조회
	 * @Author KR-SH
	 * @Date 2019. 11. 21.
	 * @param params
	 * @return
	 */
    @RequestMapping(value = "/selectYearCalendar.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, List<EgovMap>>> selectYearCalendar( @RequestParam Map<String, Object> params) {
		Map<String, List<EgovMap>> monthCal = CTSubGroupListService.selectYearCalendar(params);

		return ResponseEntity.ok(monthCal);
	}

	/**
	 * select Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 21.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectSubGroupServiceDayList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectGroupServiceDayList( @RequestParam Map<String, Object> params) {
		List<EgovMap> ctSubGroupList = CTSubGroupListService.selectSubGroupServiceDayList(params);

		return ResponseEntity.ok(ctSubGroupList);
	}

	/**
	 * Save Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 22.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/saveSubGroupServiceDayList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSubGroupServiceDayList(@RequestBody Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = CTSubGroupListService.saveSubGroupServiceDayList(params, sessionVO);

		return ResponseEntity.ok(message);
	}

	/**
	 * Save All Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 25.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	@RequestMapping(value = "/saveAllSubGroupServiceDayList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAllSubGroupServiceDayList(@RequestBody Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = CTSubGroupListService.saveAllSubGroupServiceDayList(params, sessionVO);

		return ResponseEntity.ok(message);
	}
}
