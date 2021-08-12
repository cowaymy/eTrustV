package com.coway.trust.cmmn.model;

public class BizMsgVO {
	private String procTransactionId;
	private String procName;
	private String procKey;
	private String procMsg;
	private String errorMsg;

	public BizMsgVO() {

	}

	public String getProcTransactionId() {
		return procTransactionId;
	}

	public void setProcTransactionId(String procTransactionId) {
		this.procTransactionId = procTransactionId;
	}

	public String getProcName() {
		return procName;
	}

	public void setProcName(String procName) {
		this.procName = procName;
	}

	public String getProcKey() {
		return procKey;
	}

	public void setProcKey(String procKey) {
		this.procKey = procKey;
	}

	public String getProcMsg() {
		return procMsg;
	}

	public void setProcMsg(String procMsg) {
		this.procMsg = procMsg;
	}

	public String getErrorMsg() {
		return errorMsg;
	}

	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}
}
