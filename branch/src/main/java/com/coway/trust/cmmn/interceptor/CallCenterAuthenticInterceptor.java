package com.coway.trust.cmmn.interceptor;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.WebContentInterceptor;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.callcenter.TokenService;
import com.coway.trust.biz.common.AccessMonitoringService;
import com.coway.trust.biz.common.MenuService;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.cmmn.exception.CallcenterException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

public class CallCenterAuthenticInterceptor extends WebContentInterceptor {

	private static final Logger LOGGER = LoggerFactory.getLogger(CallCenterAuthenticInterceptor.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private TokenService tokenService;

	@Autowired
	private LoginService loginService;

	@Autowired
	private MenuService menuService;

	@Autowired
	private AccessMonitoringService accessMonitoringService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws ServletException {

		if (VerifyRequest.isCallCenterRequest(request)) {

			try {
				String ccToken = request.getParameter(AppConstants.CALLCENTER_TOKEN_KEY);
				String ccUser = request.getParameter(AppConstants.CALLCENTER_USER_KEY);

				Map<String, Object> params = new HashMap<>();
				params.put(AppConstants.CALLCENTER_TOKEN_KEY, ccToken);
				params.put(AppConstants.CALLCENTER_USER_KEY, ccUser);

				if (isValidToken(params)) {
					SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
					if (sessionVO.getUserId() == 0) {
						LoginVO loginVO = loginService.loginByCallcenter(params);

						if (loginVO == null || loginVO.getUserId() == 0) {
							throw new CallcenterException(HttpStatus.UNAUTHORIZED,
									HttpStatus.UNAUTHORIZED.getReasonPhrase());
						}

						HttpSession session = sessionHandler.getCurrentSession();
						session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create(loginVO));
					}
				} else {
					throw new CallcenterException(HttpStatus.UNAUTHORIZED,
							messageAccessor.getMessage(AppConstants.MSG_INVALID_TOKEN));
				}
			} catch (CallcenterException e) {
				throw e;
			} catch (Exception e) {
				LOGGER.error(e.getMessage());
				throw new CallcenterException(HttpStatus.INTERNAL_SERVER_ERROR,
						messageAccessor.getMessage(AppConstants.MSG_FAIL));
			}

		}

		return true;
	}

	/**
	 * TOKEN 체크.
	 */
	private boolean isValidToken(Map<String, Object> params) {
		LOGGER.debug("TOKEN 체크");
		return tokenService.isValidToken(params);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {

		if (VerifyRequest.isCallCenterRequest(request)) {
			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();

			if (sessionVO == null || sessionVO.getUserId() == 0) {
				throw new CallcenterException(HttpStatus.UNAUTHORIZED, HttpStatus.UNAUTHORIZED.getReasonPhrase());
			}

			if (modelAndView != null) {

				Map<String, Object> params = new HashMap<>();

				params.put("userId", sessionVO.getUserId());
				params.put("pgmPath", request.getRequestURI());

				if (request.getRequestURI().endsWith(".do")) {
					params.put("userName", sessionVO.getUserName());
					params.put("systemId", AppConstants.LOGIN_CALL_CENTER);
					params.put("pgmCode", "-");
					params.put("ipAddr", CommonUtils.getClientIp(request));

					accessMonitoringService.insertAccessMonitoring(params);
				}

				// url 로 직접 접근시 menuCode 처리.
				modelAndView.getModelMap().put(AppConstants.CURRENT_MENU_CODE, sessionVO.getMenuCode());

				modelAndView.getModelMap().put(AppConstants.PAGE_AUTH, menuService.getPageAuth(params));
				modelAndView.getModelMap().put(AppConstants.MENU_KEY, menuService.getMenuList(sessionVO));
				modelAndView.getModelMap().put(AppConstants.MENU_FAVORITES, menuService.getFavoritesList(sessionVO));
			}
		}
	}

}
