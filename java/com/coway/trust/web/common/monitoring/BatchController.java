package com.coway.trust.web.common.monitoring;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.monitoring.BatchService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common/monitoring")
public class BatchController {
	private static final Logger LOGGER = LoggerFactory.getLogger(BatchController.class);

	@Autowired
	private BatchService batchService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/batch.do")
	public String monitoring(@RequestParam Map<String, Object> params, SessionVO sessionVO, ModelMap model) {
		return "common/monitoring/batch";
	}

	@RequestMapping(value = "/batchDetailPop.do")
	public String detailPop(@RequestParam Map<String, Object> params, SessionVO sessionVO, ModelMap model) {

		String stepExecutionId = (String) params.get("stepExecutionId");

		Precondition.checkNotNull(stepExecutionId,
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "stepExecutionId" }));
		LOGGER.debug("stepExecutionId : {}", stepExecutionId);
		model.addAttribute("stepExecutionId", stepExecutionId);
		return "common/monitoring/batchDetailPop";
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

	@RequestMapping(value = "/getBatchDetailList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getBatchDetailList(@RequestParam Map<String, Object> params, ModelMap model) {
		Precondition.checkNotNull(params.get("stepExecutionId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "stepExecutionId" }));
		LOGGER.debug("stepExecutionId : {}", params.get("stepExecutionId"));
		return ResponseEntity.ok(batchService.getBatchDetailMonitoring(params));
	}
}
