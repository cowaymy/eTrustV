package com.coway.trust.cmmn.exception;

public class PreconditionException extends RuntimeException {
	private static final long serialVersionUID = -6295850039169503104L;

	private final String code;

	private final String message;

	private final String detailMessage;

	private final Exception exception;

	public PreconditionException(String code, String message) {
		this(null, code, message, null);
	}

	public PreconditionException(Exception e) {
		this(e, null, null, null);
	}

	public PreconditionException(Exception e, String code) {
		this(e, code, null, null);
	}

	public PreconditionException(Exception e, String code, String message) {
		this(e, code, message, null);
	}

	public PreconditionException(Exception e, String code, String message, String detailMessage) {
		super();
		this.exception = e;
		this.code = code;
		this.message = message;
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
