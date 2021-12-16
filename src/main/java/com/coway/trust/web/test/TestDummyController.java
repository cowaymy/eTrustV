package com.coway.trust.web.test;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.ReturnMessage;


/**
 * @author Yong Jia Hua
 * Purpose: This controller is used to debug email issues in Production. For example, to investigate why customers could not receive
 * receipt (ETR) via email.
 */
@Controller
@RequestMapping(value = "/internalTestDummy")
public class TestDummyController {

	private static final Logger logger = LoggerFactory.getLogger(TestDummyController.class);

	@Autowired
	private AdaptorService adaptorService;

	@Value("${mail.config.from}")
	private String emailFrom;

	@RequestMapping(value = "/test.do")
	public String testDummy(ModelMap model) {
		model.addAttribute("emailFrom", emailFrom);
		return "test/internalTestDummy";
	}

	@RequestMapping(value = "/sendEmail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> sendEmail(@RequestBody Map<String, Object> params){

		ReturnMessage retMsg = new ReturnMessage();

		EmailVO email = new EmailVO();
		email.setTo(Collections.singletonList((String) params.get("emailTo")));
		email.setSubject((String) params.get("emailSubject"));
	    email.setHtml(true);
		email.setText((String) params.get("emailContent"));

		boolean result = false;

		try {
			result = adaptorService.sendEmail(email, false);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		retMsg.setMessage("emailResult : " + result);
		return ResponseEntity.ok(retMsg);
	}

	@RequestMapping(value = "/sendEmailWithVmTemplate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> sendEmailWithVmTemplate(@RequestBody Map<String, Object> params) {

		ReturnMessage retMsg = new ReturnMessage();

		EmailVO email = new EmailVO();
		email.setTo(Collections.singletonList((String) params.get("emailTo")));
		email.setSubject((String) params.get("emailSubject"));
	    email.setHtml(true);
	    email.setHasInlineImage(true);

	    //set dummy values for mail template
	    Map<String, Object> mailContentParams = new HashMap<>();
	    mailContentParams.put("custNm", "Sample Customer Name");
	    mailContentParams.put("receiptDt", "2021-08-24");
	    mailContentParams.put("instAddress", "1, Sample Business Park, Jln Kuching, 51200 Kuala Lumpur, Malaysia");
	    mailContentParams.put("mobTicketNo", "11111");
	    mailContentParams.put("salesOrdNo", "1234567");
	    mailContentParams.put("stkDesc", "CHP-08AR (VILLAEM)");
	    mailContentParams.put("pymtMode", "Cash");
	    mailContentParams.put("collectorName", "Collector Name");
	    mailContentParams.put("collectorCode", "CD100000");
	    mailContentParams.put("payAmt", "1500");

		boolean result = false;

		try {
			result = adaptorService.sendEmail(email, false, EmailTemplateType.E_TEMPORARY_RECEIPT, mailContentParams);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}

		retMsg.setMessage("emailWithVmTemplateResult : " + result);
		return ResponseEntity.ok(retMsg);
	}

}
