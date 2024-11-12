package com.coway.trust.util;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringEscapeUtils;

public class XSSPreventionFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest httpRequest = (HttpServletRequest) req;
		HttpServletResponse httpResponse = (HttpServletResponse) res;

		XSSHttpServletRequestWrapper requestWrapper = new XSSHttpServletRequestWrapper(httpRequest);

		chain.doFilter(requestWrapper, httpResponse);
	}

	@Override
	public void destroy() {
	}

	private static class XSSHttpServletRequestWrapper extends HttpServletRequestWrapper {

		public XSSHttpServletRequestWrapper(HttpServletRequest request) {
			super(request);
		}

		@Override
		public String getParameter(String name) {
			String value = super.getParameter(name);
			return sanitize(value);
		}

		@Override
		public String[] getParameterValues(String name) {
			String[] values = super.getParameterValues(name);
			if (values == null)
				return null;
			for (int i = 0; i < values.length; i++) {
				values[i] = sanitize(values[i]);
			}
			return values;
		}

		@Override
		public String getHeader(String name) {
			String value = super.getHeader(name);
			return sanitize(value);
		}

		@Override
		public Enumeration<String> getHeaders(String name) {
			Enumeration<String> headers = super.getHeaders(name);
			if (headers == null)
				return null;
			return new Enumeration<String>() {
				@Override
				public boolean hasMoreElements() {
					return headers.hasMoreElements();
				}

				@Override
				public String nextElement() {
					return sanitize(headers.nextElement());
				}
			};
		}

		private String sanitize(String value) {
			if (value == null)
				return null;
			return StringEscapeUtils.escapeHtml4(value);
		}
	}
}