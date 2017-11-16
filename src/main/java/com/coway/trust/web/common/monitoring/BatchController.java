package com.coway.trust.web.common.monitoring;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.monitoring.BatchService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common/monitoring")
public class BatchController {

	@Autowired
	private BatchService batchService;

	@RequestMapping(value = "/batch.do")
	public String monitoring(@RequestParam Map<String, Object> params, SessionVO sessionVO, ModelMap model) {
		return "common/monitoring/batch";
	}

	@RequestMapping(value = "/getJobNames.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getJobNames(@RequestParam Map<String, Object> params, ModelMap model) {
		return ResponseEntity.ok(batchService.getJobNames(params));
	}

	@RequestMapping(value = "/getBatchList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getBatchMonitoring(@RequestParam Map<String, Object> params,
			@RequestParam(value = "status", required = false) String[] status,
			@RequestParam(value = "exitCode", required = false) String[] exitCode, ModelMap model) {
		params.put("status", String.join(",", status));
		params.put("exitCode", String.join(",", exitCode));
		return ResponseEntity.ok(batchService.getBatchMonitoring(params));
	}
}
