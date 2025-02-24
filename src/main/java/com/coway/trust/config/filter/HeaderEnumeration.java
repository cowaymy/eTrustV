package com.coway.trust.config.filter;

import java.util.Enumeration;
import org.apache.commons.lang3.StringEscapeUtils;

public class HeaderEnumeration implements Enumeration<String> {
    private final Enumeration<String> headers;

    public HeaderEnumeration(Enumeration<String> headers) {
        this.headers = headers;
    }

    @Override
    public boolean hasMoreElements() {
        return headers.hasMoreElements();
    }

    @Override
    public String nextElement() {
        return sanitize(headers.nextElement());
    }

    private String sanitize(String value) {
		if (value == null)
			return null;
		return StringEscapeUtils.escapeHtml4(value);
	}
}