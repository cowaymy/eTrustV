package com.coway.trust.config.filter;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Enumeration;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringEscapeUtils;

public class XSSHttpServletRequestWrapper extends HttpServletRequestWrapper {
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
		return new HeaderEnumeration(headers);
	}

	@Override
    public ServletInputStream getInputStream() throws IOException {
        if (cachedBytes == null) {
            cacheInputStream();
        }
        return new CachedServletInputStream(cachedBytes.toByteArray());
    }

    @Override
    public BufferedReader getReader() throws IOException {
        return new BufferedReader(new InputStreamReader(getInputStream()));
    }

    private void cacheInputStream() throws IOException {
        cachedBytes = new ByteArrayOutputStream();
        IOUtils.copy(super.getInputStream(), cachedBytes);
    }

	private String sanitize(String value) {
		if (value == null)
			return null;
		return StringEscapeUtils.escapeHtml4(value);
	}
}