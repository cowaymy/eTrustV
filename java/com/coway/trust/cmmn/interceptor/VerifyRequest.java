package com.coway.trust.cmmn.interceptor;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;

import com.coway.trust.AppConstants;

public class VerifyRequest {
	private VerifyRequest() {
	}

	static boolean isCallCenterRequest(HttpServletRequest request) {
		String ccToken = request.getParameter(AppConstants.CALLCENTER_TOKEN_KEY);
		String ccUser = request.getParameter(AppConstants.CALLCENTER_USER_KEY);

		if (StringUtils.isNotEmpty(ccToken) && StringUtils.isNotEmpty(ccUser)) {
			return true;
		} else {
			return false;
		}
	}

	static boolean isNotCallCenterRequest(HttpServletRequest request) {
		return !isCallCenterRequest(request);
	}
}
