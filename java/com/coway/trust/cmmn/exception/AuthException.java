package com.coway.trust.cmmn.exception;

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;

/**
 * AuthenticInterceptor 에서 사용.
 * 
 * @author lim
 *
 */
public class AuthException extends RuntimeException {

	private final String message;

	private final String detailMessage;

	private final HttpStatus httpStatus;

	private final Exception exception;

	public AuthException(HttpStatus httpStatus) {
		this(null, httpStatus, null, null);
	}

	public AuthException(HttpStatus httpStatus, String message) {
		this(null, httpStatus, message, null);
	}

	public AuthException(Exception e) {
		this(e, null, null, null);
	}

	public AuthException(Exception e, HttpStatus httpStatus) {
		this(e, httpStatus, null, null);
	}

	public AuthException(Exception e, HttpStatus httpStatus, String message) {
		this(e, httpStatus, message, null);
	}

	public AuthException(Exception e, HttpStatus httpStatus, String message, String detailMessage) {
		super();
		this.exception = e;
		this.httpStatus = httpStatus;
		if (StringUtils.isEmpty(message) && e != null) {
			this.message = e.getMessage();
		} else {
			this.message = message;
		}
		this.detailMessage = detailMessage;
	}

	public final Exception getException() {
		return this.exception;
	}

	@Override
	public final String getMessage() {
		return this.message;
	}

	public final String getDetailMessage() {
		return this.detailMessage;
	}

	public final HttpStatus getHttpStatus() {
		return this.httpStatus;
	}
}
