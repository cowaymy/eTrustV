package com.coway.trust.web.common;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.RoleManagementService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class RoleManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(RoleManagementController.class);

	@Autowired
	private RoleManagementService roleManagementService;

	@RequestMapping(value = "/roleManagement.do")
	public String roleManagement(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		LOGGER.debug("roleManagement");
		return "/common/roleManagement";
	}

	@RequestMapping(value = "/getRootRoleList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getStateCodeList(@RequestParam Map<String, Object> params) {
		List<EgovMap> rootRoles = roleManagementService.getRootRoles();
		return ResponseEntity.ok(rootRoles);
	}

	@RequestMapping(value = "/getRolesByParentRole.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSubAreaList(@RequestParam Map<String, Object> params) {
		int parentRoleId = Integer.parseInt((String) params.get("parentRole"));
		List<EgovMap> rootRoles = roleManagementService.getRolesByParentRole(parentRoleId);
		return ResponseEntity.ok(rootRoles);
	}

	@RequestMapping(value = "/getRoleManagementList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getPostCodeList(@RequestParam Map<String, Object> params,
			@RequestParam(value = "status", required = false) String[] status,
			@RequestParam(value = "level", required = false) String[] level) {
		params.put("status", status);
		params.put("level", level);
		List<EgovMap> roleManagementList = roleManagementService.getRoleManagementList(params);
		return ResponseEntity.ok(roleManagementList);
	}

	@RequestMapping(value = "/getUsersByRoleId.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getUsersByRoleId(@RequestParam Map<String, Object> params) {
		List<EgovMap> roleManagementList = roleManagementService.getUsersByRoleId(params);
		return ResponseEntity.ok(roleManagementList);
	}

	@RequestMapping(value = "/saveRole.do", method = RequestMethod.POST)
	public ResponseEntity saveRole(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		roleManagementService.saveRole(params, sessionVO.getUserId());
		return ResponseEntity.ok(HttpStatus.OK);
	}

	@RequestMapping(value = "/updateActivateRole.do", method = RequestMethod.POST)
	public ResponseEntity updateActivateRole(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) {
		roleManagementService.updateActivateRole(Integer.valueOf((String) params.get("roleId")), sessionVO.getUserId());
		return ResponseEntity.ok(HttpStatus.OK);
	}

	@RequestMapping(value = "/updateDeactivateRole.do", method = RequestMethod.POST)
	public ResponseEntity updateDeactivateRole(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) {
		roleManagementService.updateDeactivateRole(Integer.valueOf((String) params.get("roleId")),
				sessionVO.getUserId());
		return ResponseEntity.ok(HttpStatus.OK);
	}

	@RequestMapping(value = "/updateRole.do", method = RequestMethod.POST)
	public ResponseEntity updateRole(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) {
		roleManagementService.updateRole(params, sessionVO.getUserId());
		return ResponseEntity.ok(HttpStatus.OK);
	}

}
