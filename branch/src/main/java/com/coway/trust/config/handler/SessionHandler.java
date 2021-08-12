package com.coway.trust.config.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.model.SessionVO;

@Component("sessionHandler")
public class SessionHandler {

	/**
	 * 현재 Request를 리턴
	 * 
	 * @return HttpServletRequest
	 */
	public HttpServletRequest getCurrentRequest() {
		return ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
	}

	/**
	 * 현재 session 리턴
	 * 
	 * @return HttpSession
	 */
	public HttpSession getCurrentSession() {
		return getCurrentRequest().getSession();
	}

	/**
	 * 현재 SessionVo 리턴
	 * 
	 * @return
	 */
	public SessionVO getCurrentSessionInfo() {
		SessionVO session = (SessionVO) getCurrentSession().getAttribute(AppConstants.SESSION_INFO);
		if (session == null) {
			session = new SessionVO();
		}
		return session;
	}

	public WebApplicationContext getWebApplicationContext() {
		return WebApplicationContextUtils.getRequiredWebApplicationContext(getCurrentSession().getServletContext());
	}

	/**
	 * 세션 초기화.
	 */
	public void clearSessionInfo() {
		//
		if (getCurrentSession().getAttribute(AppConstants.SESSION_INFO) != null) {
			getCurrentSession().removeAttribute(AppConstants.SESSION_INFO);
		}
	}
}
