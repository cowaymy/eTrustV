package com.coway.trust.web.payment.autodebit.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment/enroll")
public class EMandateEnrollmentController {

	@RequestMapping(value = "/new")
    public String agreementDL(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		return "payment/autodebit/eMandateEnrollmentPop.jsp";
	}
}
