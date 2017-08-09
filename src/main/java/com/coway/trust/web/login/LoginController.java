package com.coway.trust.web.login;

import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.Precondition;

@Controller
@RequestMapping(value = "/login")
public class LoginController {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoginController.class);

	@Autowired
	private LoginService loginService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/login.do")
	public String login(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		model.addAttribute("languages", loginService.getLanguages());
		LOGGER.debug("DEPLOY_TEST");
		return "error/error";
	}

	@RequestMapping(value = "/getLoginInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> getLoginInfo(@RequestBody Map<String, Object> params, ModelMap model) {

		Precondition.checkNotNull(params.get("userId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "ID" }));
		Precondition.checkNotNull(params.get("password"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "PASSWORD" }));

		LOGGER.debug("userID : {}", params.get("userId"));

		LoginVO loginVO = loginService.getLoginInfo(params);

		ReturnMessage message = new ReturnMessage();

		if (loginVO == null || loginVO.getUserId() == 0) {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_NOT_EXIST, new Object[] { "ID" }));
		} else {
			HttpSession session = sessionHandler.getCurrentSession();
			session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create(loginVO));
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/logout.do")
	public String logout(HttpServletRequest req, HttpServletResponse res, ModelMap modelMap,
			@RequestParam Map<String, Object> params) {
		loginService.logout(params);
		sessionHandler.clearSessionInfo();
		return AppConstants.REDIRECT_LOGIN;
	}

}
