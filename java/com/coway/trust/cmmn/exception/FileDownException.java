package com.coway.trust.cmmn.exception;

import org.apache.commons.lang3.StringUtils;

public class FileDownException extends RuntimeException {

	private final String code;

	private final String message;

	private final String detailMessage;

	private final Exception exception;

	public FileDownException(String code, String message) {
		this(null, code, message, null);
	}

	public FileDownException(Exception e) {
		this(e, null, null, null);
	}

	public FileDownException(Exception e, String code) {
		this(e, code, null, null);
	}

	public FileDownException(Exception e, String code, String message) {
		this(e, code, message, null);
	}

	public FileDownException(Exception e, String code, String message, String detailMessage) {
		super();
		this.exception = e;
		this.code = code;

		if (StringUtils.isEmpty(message) && e != null) {
			this.message = e.getMessage();
		} else {
			this.message = message;
		}
		this.detailMessage = detailMessage;
	}

	public final Exception getException() {
		return exception;
	}

	public final String getCode() {
		return code;
	}

	@Override
	public final String getMessage() {
		return message;
	}

	public final String getDetailMessage() {
		return detailMessage;
	}
}
