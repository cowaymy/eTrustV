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

import com.coway.trust.biz.common.LoginMonitoringService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class LoginMonitoringController {

	@Autowired
	private LoginMonitoringService loginMonitoringService;

	@RequestMapping(value = "/loginMonitoring.do")
	public String loginMonitoring(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/loginMonitoring";
	}

	@RequestMapping(value = "/selectLoginMonitoringList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLoginMonitoringList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(loginMonitoringService.selectLoginMonitoringList(params));
	}

	@RequestMapping(value = "/selectCommonCodeSystemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCommonCodeSystemList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(loginMonitoringService.selectCommonCodeSystemList(params));
	}

}
