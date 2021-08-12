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
import com.coway.trust.biz.common.InterfaceManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class InterfaceManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(InterfaceManagementController.class);

	@Autowired
	private InterfaceManagementService interfaceManagementService;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/interfaceManagement.do")
	public String myMenu(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		LOGGER.debug("Call MyMenu Init");
		return "common/interfaceManagement";
	}

	@RequestMapping(value = "/selectInterfaceManagementList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectInterfaceManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug("Select User Menu Mapping");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		return ResponseEntity.ok(interfaceManagementService.selectInterfaceManagementList(params, sessionVO));
	}

	@RequestMapping(value = "/saveInterfaceManagementList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> savetInterfaceManagementList(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model) {
		LOGGER.debug("Save User Menu Mapping");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		interfaceManagementService.saveInterfaceManagementList(params, sessionVO);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		return ResponseEntity.ok(message);
	}
}
