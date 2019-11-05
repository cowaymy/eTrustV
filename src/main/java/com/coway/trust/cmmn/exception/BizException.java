package com.coway.trust.cmmn.exception;

import com.coway.trust.cmmn.model.BizMsgVO;

public class BizException extends RuntimeException {
	private final String errorCode;

	transient protected BizMsgVO bizMsgVO = null;

	public BizException (String errorCode, BizMsgVO bizMsgVO, Throwable cause) {
		super(errorCode, cause);
		this.errorCode = errorCode;
		this.bizMsgVO = bizMsgVO;
	}

	public BizMsgVO getBizMsgVO() {
		return bizMsgVO;
	}

	public String getErrorCode() {
		return errorCode;
	}
}
