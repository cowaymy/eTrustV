package com.coway.trust.web.payment.eMandate.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import com.coway.trust.biz.payment.eMandate.service.EMandateEnrollmentService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.Precondition;

@Controller
@RequestMapping(value = "/payment/enroll")
public class EMandateEnrollmentController {

	@Resource(name="eMandateEnrollmentService")
	private EMandateEnrollmentService eMandateEnrollmentService;

	@Autowired
    private MessageSourceAccessor messageAccessor;


	private static final Logger logger = LoggerFactory.getLogger(EMandateEnrollmentController.class);

	@RequestMapping(value = "/ddEnroll.do", method = RequestMethod.GET)
    public String ddEnroll(@RequestParam Map<String, Object> params, ModelMap model) {

		logger.debug("==================== ddEnroll.do ====================");

		Precondition.checkNotNull(params.get("nric"),
                messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "nric" }));

		Precondition.checkNotNull(params.get("name"),
                messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "name" }));


		String nric = ((String) params.get("nric"));
		String name = ((String) params.get("name"));

		model.addAttribute("preNric", nric);
		model.addAttribute("preName", name);

		return "/payment/eMandate/directDebit/publicAccess/eMandateEnrollmentPop";
	}

	@RequestMapping(value = "/ddSubmit.do", method = RequestMethod.GET)
    public ResponseEntity<ReturnMessage> ddSubmit(@RequestParam Map<String, Object> params) throws Exception {

		logger.debug("==================== ddSubmit.do ====================");

		Map<String, Object> result;
		ReturnMessage message = new ReturnMessage();

		// To check ORDER_NO, NRIC & NAME is matched
		int valid = eMandateEnrollmentService.checkValidCustomer(params);

		if (valid > 0){
			// To call service for processing enrollment
			result = eMandateEnrollmentService.enrollCustomer(params);

			message.setCode(AppConstants.SUCCESS);
			message.setData(result);
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage("E000. Fail. Please contact administrator.");
		}

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/ddRespond.do")
    public String ddRespond(@RequestParam Map<String, Object> params, Model model,
    	      SessionVO sessionVO) {

		logger.debug("==================== ddRespond.do ====================");

		String nric = ((String) params.get("nric"));
		String name = ((String) params.get("name"));

		return "/payment/eMandate/directDebit/publicAccess/eMandateRespond";
	}
}
