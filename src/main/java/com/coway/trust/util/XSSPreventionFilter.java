package com.coway.trust.util;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Enumeration;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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

		Map<String, String[]> parameterMap = requestWrapper.getParameterMap();

		parameterMap.forEach((key, values) -> {
	        for (int i = 0; i < values.length; i++) {
	            values[i] = sanitize(values[i]);
	        }
	    });

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

	private static class XSSHttpServletRequestWrapper extends HttpServletRequestWrapper {
		private ByteArrayOutputStream cachedBytes;

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

		@Override
	    public ServletInputStream getInputStream() throws IOException {
	        if (cachedBytes == null) {
	            cacheInputStream();
	        }
	        return new CachedServletInputStream();
	    }

	    @Override
	    public BufferedReader getReader() throws IOException {
	        return new BufferedReader(new InputStreamReader(getInputStream()));
	    }

	    private void cacheInputStream() throws IOException {
	        cachedBytes = new ByteArrayOutputStream();
	        IOUtils.copy(super.getInputStream(), cachedBytes);
	    }

	    public class CachedServletInputStream extends ServletInputStream {
	        private ByteArrayInputStream input;

	        public CachedServletInputStream() {
	            input = new ByteArrayInputStream(cachedBytes.toByteArray());
	        }

	        @Override
	        public int read() throws IOException {
	            return input.read();
	        }
	    }

		private String sanitize(String value) {
			if (value == null)
				return null;
			return StringEscapeUtils.escapeHtml4(value);
		}
	}
}