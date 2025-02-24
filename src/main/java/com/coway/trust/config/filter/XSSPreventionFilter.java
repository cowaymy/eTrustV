package com.coway.trust.config.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
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

		Map<String, String[]> parameterMap = new HashMap<>(requestWrapper.getParameterMap()); //requestWrapper.getParameterMap();

		/*parameterMap.forEach((key, values) -> {
	        for (int i = 0; i < values.length; i++) {
	            values[i] = sanitize(values[i]);
	        }
	    });*/

		chain.doFilter(requestWrapper, httpResponse);
	}

	private String sanitize(String value) {
	    if (value == null)
	        return null;
	    return StringEscapeUtils.escapeHtml4(value);
	}

	@Override
	public void destroy() {
	}
}