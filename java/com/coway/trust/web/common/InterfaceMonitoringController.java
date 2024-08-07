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

import com.coway.trust.biz.common.InterfaceMonitoringService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class InterfaceMonitoringController {

	@Autowired
	private InterfaceMonitoringService interfaceMonitoringService;

	@RequestMapping(value = "/interfaceMonitoring.do")
	public String interfaceMonitoring(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/interfaceMonitoring";
	}

	@RequestMapping(value = "/interfaceMonitoringDtm.do")
	public String interfaceMonitoringDtm(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/interfaceMonitoringDtmPop";
	}

	@RequestMapping(value = "/interfaceMonitoringKey.do")
	public String interfaceMonitoringKey(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		return "common/interfaceMonitoringKeyPop";
	}

	@RequestMapping(value = "/selectInterfaceMonitoringList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectInterfaceMonitoringList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(interfaceMonitoringService.selectInterfaceMonitoringList(params));
	}

	@RequestMapping(value = "/selectInterfaceMonitoringDtmList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectInterfaceMonitoringDtmList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(interfaceMonitoringService.selectInterfaceMonitoringDtmList(params));
	}

	@RequestMapping(value = "/selectInterfaceMonitoringKeyList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectInterfaceMonitoringKeyList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(interfaceMonitoringService.selectInterfaceMonitoringKeyList(params));
	}

	@RequestMapping(value = "/selectCommonCodeStatusList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCommonCodeStatusList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(interfaceMonitoringService.selectCommonCodeStatusList(params));
	}

	@RequestMapping(value = "/selectInterfaceTypeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectInterfaceTypeList(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(interfaceMonitoringService.selectInterfaceTypeList(params));
	}

}
