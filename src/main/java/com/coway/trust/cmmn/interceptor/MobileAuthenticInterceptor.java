package com.coway.trust.cmmn.interceptor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import com.coway.trust.biz.common.MenuService;
import com.coway.trust.cmmn.exception.AuthException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

public class MobileAuthenticInterceptor extends WebContentInterceptor {

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MenuService menuService;

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
		// TODO : 권한 체크 로직 구현 필요.
		// 권한이 없다면, 아래의 exception을 throw 하면, GlobalExceptionHandler 의 authException 에서 처리함.
		// throw new AuthException(HttpStatus.FORBIDDEN, HttpStatus.FORBIDDEN.getReasonPhrase());
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

		if (sessionVO == null || sessionVO.getUserId() == 0) {
			// TODO : 임시 처리됨. 아래 내용 적용 필요.
			// throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
		}
	}

}
