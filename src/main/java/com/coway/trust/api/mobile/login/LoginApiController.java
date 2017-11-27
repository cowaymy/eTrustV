package com.coway.trust.api.mobile.login;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.cmmn.exception.AuthException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.Precondition;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "Login api", description = "Login api")
@RestController(value = "LoginApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/login")
public class LoginApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoginApiController.class);

	@Resource(name = "loginService")
	private LoginService loginService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@ApiOperation(value = "Login", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public ResponseEntity<LoginDto> login(@RequestBody LoginForm loginForm) throws Exception {
		LOGGER.debug("login");

		Map<String, Object> params = loginForm.createMap(loginForm);

		Precondition.checkState(CommonUtils.isNotEmpty(params.get(LoginConstants.P_USER_ID)),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "ID" }));
		Precondition.checkState(CommonUtils.isNotEmpty(params.get(LoginConstants.P_USER_PW)),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "PASSWORD" }));

		if (loginForm.isCheckDeviceNumber()) {
			Precondition.checkState(CommonUtils.isNotEmpty(params.get(LoginConstants.P_USER_MOBILE_NO)),
					messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "DEVICE NUMBER" }));
		}

		LoginVO loginVO = loginService.loginByMobile(params);

		if (loginVO == null || loginVO.getUserId() == 0) {
			throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
		} else {
			HttpSession session = sessionHandler.getCurrentSession();
			session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create(loginVO));
		}

		return ResponseEntity.ok(LoginDto.create(loginVO));
	}

	@ApiOperation(value = "Logout", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/logout", method = RequestMethod.POST)
	public void logout() throws Exception {
		LOGGER.debug("logout");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		if (sessionVO.getUserId() > 0) {
			Map<String, Object> params = new HashMap<>();
			params.put(LoginConstants.P_USER_ID, sessionVO.getUserName());
			loginService.logoutByMobile(params);
			sessionHandler.clearSessionInfo();
		}
	}
}
