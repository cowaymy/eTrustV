package com.coway.trust.config.filter;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

public class SecureCookieResponseWrapper extends HttpServletResponseWrapper {
	public SecureCookieResponseWrapper(HttpServletResponse response) {
		super(response);
	}

	@Override
	public void addCookie(Cookie cookie) {
		// Apply secure attributes to cookies
		cookie.setSecure(true);
		super.addCookie(cookie);
	}

	public void applySecureAttributes() {
		// Method to apply secure attributes after the request processing
		// Not used in this wrapper but can be extended if needed
	}
}