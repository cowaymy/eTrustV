package com.coway.trust.util;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

public class SecurityHeadersFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		HttpServletResponse httpResponse = (HttpServletResponse) res;

		// Set Content-Security-Policy header
		httpResponse.setHeader("Content-Security-Policy",
				"default-src * data: mediastream: blob: filesystem: about: ws: wss: 'unsafe-eval' 'wasm-unsafe-eval' 'unsafe-inline';"
						+ "script-src * data: blob: 'unsafe-inline' 'unsafe-eval';"
						+ "script-src-elem * data: blob: 'unsafe-inline' 'unsafe-eval';"
						+ "connect-src * data: blob: 'unsafe-inline';"
						+ "img-src * data: blob: 'unsafe-inline';"
						+ "media-src * data: blob: 'unsafe-inline';" + "frame-src * data: blob: ;"
						+ "style-src * data: blob: 'unsafe-inline';" + "font-src * data: blob: 'unsafe-inline';"
						+ "frame-ancestors * data: blob:;");

		// Set X-Frame-Options header
		httpResponse.setHeader("X-Frame-Options", "SAMEORIGIN");

		// Continue with the next filter or the resource
		chain.doFilter(req, res);
	}

	@Override
	public void destroy() {
	}
}