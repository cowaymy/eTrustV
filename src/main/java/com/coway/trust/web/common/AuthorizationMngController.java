package com.coway.trust.web.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/authorization")
public class AuthorizationMngController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AuthorizationMngController.class);

	@RequestMapping(value = "/authManagement.do")
	public String authList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LOGGER.debug("authList");
		return "common/authorizaManagement";
	}
}
