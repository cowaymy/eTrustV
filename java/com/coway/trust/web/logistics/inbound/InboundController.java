package com.coway.trust.web.logistics.inbound;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.inbound.InboundService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "logistics/inbound")

public class InboundController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "inboundService")
	private InboundService inboundService;

	@RequestMapping(value = "/InboundRequest.do")
	public String inboundReqeust(@RequestParam Map<String, Object> params, ModelMap model) {

		return "logistics/inbound/inBoundRequestList";

	}

	@RequestMapping(value = "/InboundReceive.do")
	public String inboundReceive(@RequestParam Map<String, Object> params, ModelMap model) {

		return "logistics/inbound/inboundReceiveList";

	}

	@RequestMapping(value = "/InBoundList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> inBoundList(@RequestBody Map<String, Object> params, Model model) {
		List<EgovMap> dataList = inboundService.inBoundList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(dataList);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/ReceiptList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> receiptList(@RequestBody Map<String, Object> params, Model model) {
		List<EgovMap> dataList = inboundService.receiptList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(dataList);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/InboundLocation", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> inboundLocation(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		List<EgovMap> data = inboundService.inboundLocation(params);
		return ResponseEntity.ok(data);
	}

	@RequestMapping(value = "/reqSMO.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> reqSTO(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {
		params.put("userId", sessionVo.getUserId());
		Map<String, Object> data = inboundService.reqSTO(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(data);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/searchSMO.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchSMO(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {
		// params.put("userId", sessionVo.getUserId());
		List<EgovMap> dataList = inboundService.searchSMO(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(dataList);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/receipt.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> receipt(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {
		params.put("userId", sessionVo.getUserId());
		inboundService.receipt(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

    //KR HAN : InBound's Serial Check In Popup
    @RequestMapping(value = "/inBoundIssueInPop.do")
    public String inBoundIssueInPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

    	model.addAttribute("url", params);
        return "logistics/inbound/inboundIssueInPop";
    }

    // KR HAN : receipt Serial Save
	@RequestMapping(value = "/receiptSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> receiptSerial(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {

		Map<String, Object> rmap = new HashMap<>();

		params.put("userId", sessionVo.getUserId());

		logger.debug("receiptSerial.do :::: params {} ", params);

		rmap =  inboundService.receiptSerial(params);

	    // 결과 만들기
	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setData(rmap);
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
}
