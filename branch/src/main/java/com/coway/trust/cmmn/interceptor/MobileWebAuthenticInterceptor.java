package com.coway.trust.cmmn.interceptor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import com.coway.trust.cmmn.exception.AuthException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

public class MobileWebAuthenticInterceptor extends WebContentInterceptor {

	private static final Logger LOGGER = LoggerFactory.getLogger(MobileWebAuthenticInterceptor.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws ServletException {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		if (sessionVO != null && sessionVO.getUserId() > 0) {
			checkAuthorized();
		} else {
			throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
		}

		return true;
	}

	/**
	 * 권한 체크.
	 */
	private void checkAuthorized() {
		LOGGER.debug("권한체크");
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		if (sessionVO == null || sessionVO.getUserId() == 0) {
			LOGGER.debug("세션체크");
			throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
		}
	}

}
