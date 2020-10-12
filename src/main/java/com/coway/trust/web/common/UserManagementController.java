package com.coway.trust.web.common;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.UserManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common/userManagement")
public class UserManagementController {

	@Autowired
	private UserManagementService userManagementsService;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/userManagementMain.do")
	public String userManagement(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/userManagement";
	}

	@RequestMapping(value = "/userManagementNew.do")
	public String userManagementNew(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/userManagementNewPop";
	}

	@RequestMapping(value = "/userManagementEdit.do")
	public String userManagementEdit(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/userManagementEditPop";
	}

	@RequestMapping(value = "/userManagementEditBrnch.do")
	public String userManagementEditBrnch(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/userManagementEditBrnchPop";
	}

	@RequestMapping(value = "/memberCodePop.do")
	public String memberCodePop(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/memberCodePop";
	}

	@RequestMapping(value = "/selectUserList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUserList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userManagementsService.selectUserList(params));
	}

	@RequestMapping(value = "/selectUserDetailList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUserDetailList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userManagementsService.selectUserDetailList(params));
	}

	@RequestMapping(value = "/selectBranchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBranchList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userManagementsService.selectBranchList(params));
	}

	@RequestMapping(value = "/selectDeptList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDeptList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userManagementsService.selectDeptList(params));
	}

	@RequestMapping(value = "/selectUserStatusList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUserStatusList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userManagementsService.selectUserStatusList(params));
	}

	@RequestMapping(value = "/selectRoleList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRoleList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userManagementsService.selectRoleList(params));
	}

	@RequestMapping(value = "/selectUserTypeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUserTypeList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userManagementsService.selectUserTypeList(params));
	}

	@RequestMapping(value = "/selectMemberList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemberList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userManagementsService.selectMemberList(params));
	}

	@RequestMapping(value = "/saveUserManagementList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveUserManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		userManagementsService.saveUserManagementList(params, sessionVO);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/editUserManagementList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> editUserManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		userManagementsService.editUserManagementList(params, sessionVO);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectUserRoleList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUserRoleList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userManagementsService.selectUserRoleList(params));
	}

	@RequestMapping(value = "/saveUserRoleList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> saveUserRoleList(@RequestParam Map<String, Object> params, ModelMap model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		userManagementsService.saveUserRoleList(params, sessionVO);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getDeptList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getDeptList(@RequestParam Map<String, Object> params, ModelMap model) {
	    return ResponseEntity.ok(userManagementsService.getDeptList(params));
	}

	@RequestMapping(value = "/checkUserNric.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkUserNric(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
	    ReturnMessage message = userManagementsService.checkUserNric(params);
	    return ResponseEntity.ok(message);
	}
}