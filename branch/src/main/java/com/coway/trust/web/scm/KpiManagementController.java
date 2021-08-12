package com.coway.trust.web.scm;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.scm.KpiManagementService;
import com.coway.trust.biz.scm.ScmCommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class KpiManagementController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(KpiManagementController.class);
	
	@Autowired
	private ScmCommonService scmCommonService;
	@Autowired
	private KpiManagementService kpiManagementService;
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	/*
	 * View
	 */
	//	
	
	/*
	 * Inventory Report
	 */
	//	Search Total

}