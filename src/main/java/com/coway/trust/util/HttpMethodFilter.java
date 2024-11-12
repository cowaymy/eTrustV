package com.coway.trust.util;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HttpMethodFilter implements Filter {

	private static final String[] DISALLOWED_METHODS = { "TRACE", "OPTIONS" };

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) req;
		HttpServletResponse httpResponse = (HttpServletResponse) res;

		httpResponse.setHeader("Access-Control-Allow-Method", "HEAD, POST, DELETE, GET, PUT");

		String method = httpRequest.getMethod();

		// Check if the method is in the list of disallowed methods
		for (String disallowedMethod : DISALLOWED_METHODS) {
			if (method.equalsIgnoreCase(disallowedMethod)) {
				// Respond with 405 Method Not Allowed
				httpResponse.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Method Not Allowed");
				return;
			}
		}

		// Continue the request-response chain for allowed methods
		chain.doFilter(req, res);
	}

	@Override
	public void destroy() {
	}

}