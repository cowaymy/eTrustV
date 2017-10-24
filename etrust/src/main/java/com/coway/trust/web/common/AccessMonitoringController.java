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

import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class AccessMonitoringController {

	@Autowired
	private AccessMonitoringService accessMonitoringService;

	@RequestMapping(value = "/accessMonitoring.do")
	public String accessMonitoring(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/accessMonitoring";
	}

	@RequestMapping(value = "/selectAccessMonitoringList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAccessMonitoringList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(accessMonitoringService.selectAccessMonitoringList(params));
	}

	@RequestMapping(value = "/selectAccessMonitoringDtmList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAccessMonitoringDtmList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(accessMonitoringService.selectAccessMonitoringDtmList(params));
	}


	@RequestMapping(value = "/selectAccessMonitoringUserList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAccessMonitoringUserList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(accessMonitoringService.selectAccessMonitoringUserList(params));
	}
}
