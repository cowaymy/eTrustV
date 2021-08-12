package com.coway.trust.cmmn.exception;

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;

/**
 * CallcenterAuthenticInterceptor 에서 사용.
 * 
 * @author lim
 *
 */
public class CallcenterException extends RuntimeException {

	private final String message;

	private final String detailMessage;

	private final HttpStatus httpStatus;

	private final Exception exception;

	public CallcenterException(HttpStatus httpStatus) {
		this(null, httpStatus, null, null);
	}

	public CallcenterException(HttpStatus httpStatus, String message) {
		this(null, httpStatus, message, null);
	}

	public CallcenterException(Exception e) {
		this(e, null, null, null);
	}

	public CallcenterException(Exception e, HttpStatus httpStatus) {
		this(e, httpStatus, null, null);
	}

	public CallcenterException(Exception e, HttpStatus httpStatus, String message) {
		this(e, httpStatus, message, null);
	}

	public CallcenterException(Exception e, HttpStatus httpStatus, String message, String detailMessage) {
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
