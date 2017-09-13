package com.coway.trust.cmmn.interceptor;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.MenuService;
import com.coway.trust.cmmn.exception.AuthException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

public class AuthenticInterceptor extends WebContentInterceptor {

	private static final Logger LOGGER = LoggerFactory.getLogger(AuthenticInterceptor.class);

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
			LOGGER.debug("AuthenticInterceptor > AuthException [ URI : {}{}]", request.getContextPath(),
					request.getRequestURI());
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
			throw new AuthException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
		}

		if (modelAndView != null) {
			Map<String, Object> params = new HashMap<>();
			modelAndView.getModelMap().put(AppConstants.PAGE_AUTH, menuService.getPageAuth(params));
			modelAndView.getModelMap().put(AppConstants.MENU_KEY, menuService.getMenuList(sessionVO));
			modelAndView.getModelMap().put(AppConstants.MENU_FAVORITES, menuService.getFavoritesList(sessionVO));
		}
	}

}
