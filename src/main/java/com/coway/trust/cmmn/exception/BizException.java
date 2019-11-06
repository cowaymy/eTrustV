package com.coway.trust.cmmn.exception;

import com.coway.trust.cmmn.model.BizMsgVO;

public class BizException extends RuntimeException {
	private final String errorCode;

	private final String procTransactionId;
	private final String procName;
	private final String procKey;
	private final String procMsg;
	private final String errorMsg;

	public BizException (String errorCode, String procTransactionId, String procName, String procKey, String procMsg, String errorMsg, Throwable cause) {
		super(errorCode, cause);
		this.errorCode = errorCode;
		this.procTransactionId = procTransactionId;
		this.procName = procName;
		this.procKey = procKey;
		this.procMsg = procMsg;
		this.errorMsg = errorMsg;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public String getProcTransactionId() {
		return procTransactionId;
	}

	public String getProcName() {
		return procName;
	}

	public String getProcKey() {
		return procKey;
	}

	public String getProcMsg() {
		return procMsg;
	}

	public String getErrorMsg() {
		return errorMsg;
	}
}
