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
import com.coway.trust.biz.scm.OtdStatusManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.Precondition;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class OtdStatusManagementController {
	private static final Logger LOGGER = LoggerFactory.getLogger(OtdStatusManagementController.class);

	@Autowired
	private OtdStatusManagementService otdStatusManagementService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/otdStatusReportView.do")
	public String otdStatusReportView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return "/scm/otdStatusReport";
	}
	@RequestMapping(value = "/otdStatusReportPopView.do")
	public String otdStatusReportPopView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		
		LOGGER.debug("otdStatusReportPopView : {}", params.toString());
		
		//	POPUP으로 넘길 파라미터
		model.addAttribute("params", params);
		
		return "/scm/otdStatusReportPop";
	}
	
	@RequestMapping(value = "/selectOtdStatus.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectOtdStatus(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectOTDStatus : {}", params.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		List<EgovMap> selectOtdStatus = otdStatusManagementService.selectOtdStatus(params);
		
		map.put("selectOtdStatus", selectOtdStatus);

		return ResponseEntity.ok(map);
	}
}