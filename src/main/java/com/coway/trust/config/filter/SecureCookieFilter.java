package com.coway.trust.config.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

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
}