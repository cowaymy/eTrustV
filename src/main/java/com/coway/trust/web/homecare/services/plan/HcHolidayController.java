package com.coway.trust.web.homecare.services.plan;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.services.plan.HcHolidayService;
import com.coway.trust.biz.services.servicePlanning.HolidayService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.homecare.HomecareConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcHolidayController.java
 * @Description : Homecare Holiday Management Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 14.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/services/plan")
public class HcHolidayController {

	@Resource(name = "hcHolidayService")
	private HcHolidayService hcHolidayService;

	@Resource(name = "holidayService")
	private HolidayService holidayService;


	/**
	 * Homecare HolidayList 화면 호출
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/hcHolidayList.do")
	public String hcHolidayList(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
		// 호출될 화면
        return "homecare/services/plan/hcHolidayList";
	}

	/**
	 * Select Homecare Holiday List
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/selectHcHolidayList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHcHolidayList(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		params.put("stateList", (String[])request.getParameterValues("cmbState"));
		params.put("branchList", (String[])request.getParameterValues("branchId"));

		List<EgovMap> holidayList = hcHolidayService.selectHcHolidayList(params);
		return ResponseEntity.ok(holidayList);
	}

	/**
	 * Select DT Branch(HDC) Assign Holiday List
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDTAssignList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDTAssignList(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		params.put("stateTypeList", (String[])request.getParameterValues("assignState"));
		params.put("stateList", (String[])request.getParameterValues("cmbState"));
		params.put("branchList", (String[])request.getParameterValues("branchId"));

		List<EgovMap> assignList = hcHolidayService.selectDTAssignList(params);
		return ResponseEntity.ok(assignList);
	}

	/**
	 * Save Homecare Holiday List
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 */
	@RequestMapping(value = "/saveHcHoliday.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>saveHcHoliday(@RequestBody Map<String, List<Map<String, Object>>> params, SessionVO sessionVO) {
		ReturnMessage message = null;
		try {
			message = hcHolidayService.saveHcHoliday(params, sessionVO);
		} catch (Exception e) {
			throw new ApplicationException(AppConstants.FAIL, "Save Holiday Failed.");
		}

		return ResponseEntity.ok(message);
	}

    /**
     * Call Popup - Holiday Replacement DT
     * @Author KR-SH
     * @Date 2020. 1. 6.
     * @param params
     * @param model
     * @return
     */
	@RequestMapping(value = "/replacementDTEntryPop.do")
	public String replacementDTEntryPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);
		// 호출될 화면
		return "homecare/services/plan/replacementDTEntryPop";
	}

	@RequestMapping(value = "/replacementLTEntryPop.do")
	public String replacementLTEntryPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);
		// 호출될 화면
		return "homecare/services/plan/replacementLTEntryPop";
	}

	/**
	 * Select DT/ AssignDT List
	 * @Author KR-SH
	 * @Date 2020. 1. 6.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectDTList.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectDTList( @RequestParam Map<String, Object> params) {
		params.put("paramMemType", HomecareConstants.MEM_TYPE.DT);

		List<EgovMap> DTList = holidayService.selectCTList(params);
		List<EgovMap> DTAssignList = holidayService.selectAssignCTList(params);

		Map<String, Object> map= new HashMap<String, Object>();
		map.put("CTList", DTList);
		map.put("CTAssignList", DTAssignList);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectLTList.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectLTList( @RequestParam Map<String, Object> params) {
		params.put("paramMemType", HomecareConstants.MEM_TYPE.LT);

		List<EgovMap> LTList = holidayService.selectCTList(params);
		List<EgovMap> LTAssignList = holidayService.selectAssignCTList(params);

		Map<String, Object> map= new HashMap<String, Object>();
		map.put("CTList", LTList);
		map.put("CTAssignList", LTAssignList);

		return ResponseEntity.ok(map);
	}

	/**
	 * Save DT Assign
	 * @Author KR-SH
	 * @Date 2020. 1. 6.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/DTAssignSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>DTAssignSave(@RequestBody Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = null;
		params.put("memType", HomecareConstants.MEM_TYPE.DT);
		try {
			message = hcHolidayService.DTAssignSave(params, sessionVO);
		} catch (Exception e) {
			throw new ApplicationException(AppConstants.FAIL, "Save Replacement DT Entry");
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/LTAssignSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>LTAssignSave(@RequestBody Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = null;
		params.put("memType", HomecareConstants.MEM_TYPE.LT);
		try {
			message = hcHolidayService.LTAssignSave(params, sessionVO);
		} catch (Exception e) {
			throw new ApplicationException(AppConstants.FAIL, "Save Replacement LT Entry");
		}

		return ResponseEntity.ok(message);
	}

}
