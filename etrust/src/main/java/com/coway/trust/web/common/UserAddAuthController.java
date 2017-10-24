package com.coway.trust.web.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.UserAddAuthService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class UserAddAuthController {

	private static final Logger LOGGER = LoggerFactory.getLogger(UserAddAuthController.class);

	@Autowired
	private UserAddAuthService userAddAuthService;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/userAddAuth.do")
	public String myMenu(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		LOGGER.debug("Call MyMenu Init");
		return "common/userAddAuth";
	}

	@RequestMapping(value = "/selectUserAddAuthList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUserAddAuthList(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug("Select User Menu Mapping");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		return ResponseEntity.ok(userAddAuthService.selectUserAddAuthList(params, sessionVO));
	}

	@RequestMapping(value = "/saveUserAddAuthList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> savetUserAddAuthList(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model) {
		LOGGER.debug("Save User Menu Mapping");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		userAddAuthService.saveUserAddAuthList(params, sessionVO);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectCommonCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCommonCodeList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(userAddAuthService.selectCommonCodeList(params));
	}
}
