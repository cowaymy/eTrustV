package com.coway.trust.web.homecare.services.plan;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.homecare.services.plan.HcDTSubGroupListService;
import com.coway.trust.web.homecare.HomecareConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcDTSubGroupListController.java
 * @Description : Homecare DT SubGroup Management Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 26.   KR-SH        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/homecare/services/plan")
public class HcDTSubGroupListController {

	@Resource(name = "hcDTSubGroupListService")
	private HcDTSubGroupListService hcDTSubGroupListService;

	/**
	 * Homecare - Services - Plan - Service Group 화면 호출
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcDTSubGroupList.do")
	public String hcDTSubGroupList(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
		// 호출될 화면
		return "homecare/services/plan/hcDTSubGroupList";
	}

	/**
	 * Search DT SubGroup List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectDtSubGroupList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDtSubGroupList( @RequestParam Map<String, Object> params) {
		List<EgovMap> dtSubGroupList = hcDTSubGroupListService.selectDtSubGroupList(params);

		return ResponseEntity.ok(dtSubGroupList);
	}

	/**
	 * Search DT SubGroup Area List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectDTSubAreaGroupList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDTSubAreaGroupList(@RequestParam Map<String, Object> params) {
		List<EgovMap> dtSubAreaGroupList = hcDTSubGroupListService.selectDTSubAreaGroupList(params);

		return ResponseEntity.ok(dtSubAreaGroupList);
	}

	/**
	 * Search DT SubGroup DSC List
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDTSubGroupDscList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDTSubGroupDscList( @RequestParam Map<String, Object> params) {
		List<EgovMap> groupDscList = hcDTSubGroupListService.selectDTSubGroupDscList(params);

		return ResponseEntity.ok(groupDscList);
	}

	@RequestMapping(value = "/selectLTSubGroupDscList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLTSubGroupDscList( @RequestParam Map<String, Object> params) {
		List<EgovMap> groupDscList = hcDTSubGroupListService.selectLTSubGroupDscList(params);

		return ResponseEntity.ok(groupDscList);
	}


	/**
	 * Select DTM By DSC
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectDTMByDSC", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDTMByDSC( @RequestParam Map<String, Object> params) {
		List<EgovMap> dTSubGroupDscList = hcDTSubGroupListService.selectDTMByDSC(params);

		return ResponseEntity.ok(dTSubGroupDscList);
	}

	/**
	 * Select DT Sub Group
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectDTSubGrp", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDTSubGrp( @RequestParam Map<String, Object> params) {
		List<EgovMap> dTSubGrp = hcDTSubGroupListService.selectDTSubGrp(params);

		return ResponseEntity.ok(dTSubGrp);
	}

	/**
	 * DT Group Assigment 화면 호출
	 * @Author KR-SH
	 * @Date 2019. 11. 26.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/hcDTSubGroupPop.do")
	public String hcDTSubGroupPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("branchTypeId", HomecareConstants.HDC_BRANCH_TYPE);
		model.addAttribute("params", params);
		// 호출될 화면
		return "homecare/services/plan/hcDTSubGroupPop";
	}

	/**
	 * DT Sub Group Assign List
	 * @Author KR-SH
	 * @Date 2019. 11. 28.
	 * @param params
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/selectAssignDTSubGroupList")
	 ResponseEntity<List<EgovMap>> selectAssignDTSubGroupList(@RequestParam Map<String, Object> params) {
		List<EgovMap> CtSubGrps = hcDTSubGroupListService.selectAssignDTSubGroup(params);

		return ResponseEntity.ok(CtSubGrps);
	}

}
