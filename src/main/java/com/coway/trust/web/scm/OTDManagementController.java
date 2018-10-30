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
import com.coway.trust.biz.scm.OTDStatusManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class OTDManagementController {
	private static final Logger LOGGER = LoggerFactory.getLogger(OTDManagementController.class);

	@Autowired
	private OTDStatusManagementService otdStatusManagementService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/otdStatusReport.do")
	public String login(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return "/scm/otdStatusReport";
	}

	@RequestMapping(value = "/selectOTDStatus.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectOTDStatus(@RequestParam Map<String, Object> params) {
		LOGGER.debug("selectOTDStatus : {}", params.toString());

		List<EgovMap> selectOTDStatus = otdStatusManagementService.selectOTDStatus(params);

		return ResponseEntity.ok(selectOTDStatus);
	}
}