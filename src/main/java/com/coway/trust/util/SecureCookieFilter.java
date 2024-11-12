package com.coway.trust.util;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

public class SecureCookieFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		HttpServletResponse httpResponse = (HttpServletResponse) res;

		// Wrap the response to intercept cookie setting
		SecureCookieResponseWrapper wrappedResponse = new SecureCookieResponseWrapper(httpResponse);

		// Proceed with the request and capture the response
		chain.doFilter(req, wrappedResponse);

		// After processing, apply secure attributes to all cookies
		wrappedResponse.applySecureAttributes();
	}

	@Override
	public void destroy() {
	}

	private static class SecureCookieResponseWrapper extends HttpServletResponseWrapper {
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
}