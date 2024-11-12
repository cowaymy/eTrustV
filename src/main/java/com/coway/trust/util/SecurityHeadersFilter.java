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
				"default-src * data: mediastream: blob: filesystem: about: ws: wss: 'unsafe-eval' 'wasm-unsafe-eval' 'unsafe-inline'; \r\n"
						+ "script-src * data: blob: 'unsafe-inline' 'unsafe-eval'; \r\n"
						+ "script-src-elem * data: blob: 'unsafe-inline' 'unsafe-eval';\r\n"
						+ "connect-src * data: blob: 'unsafe-inline'; \r\n"
						+ "img-src * data: blob: 'unsafe-inline'; \r\n"
						+ "media-src * data: blob: 'unsafe-inline'; \r\n" + "frame-src * data: blob: ; \r\n"
						+ "style-src * data: blob: 'unsafe-inline';\r\n" + "font-src * data: blob: 'unsafe-inline';\r\n"
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
