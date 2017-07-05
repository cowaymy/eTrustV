package com.coway.trust.cmmn.interceptor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import com.coway.trust.cmmn.exception.AuthException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

public class AuthenticInterceptor extends WebContentInterceptor {

	@Autowired
	private SessionHandler sessionHandler;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws ServletException {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		if (sessionVO != null && sessionVO.getId() != null) {
			checkAuthorized();
			return true;
		} else {
//			throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
			throw new AuthException(HttpStatus.FORBIDDEN, HttpStatus.FORBIDDEN.getReasonPhrase());
		}
	}

	/**
	 * 권한 체크.
	 */
	private void checkAuthorized() {
		// TODO : 권한 체크 로직 구현 필요.
		// 권한이 없다면, 아래의 exception을 throw 하면, GlobalExceptionHandler 의 authException 에서 처리함.
		// throw new AuthException(HttpStatus.FORBIDDEN, HttpStatus.FORBIDDEN.getReasonPhrase());
	}

}
