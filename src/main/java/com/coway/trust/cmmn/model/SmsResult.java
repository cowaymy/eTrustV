package com.coway.trust.cmmn.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class SmsResult {
	private int reqCount;
	private int successCount;
	private int failCount;
	private int errorCount;
	private String msgId;
	private List<Map<String, String>> failReason = new ArrayList<>();
	private int smsId;
	private int status;

	public int getReqCount() {
		return reqCount;
	}

	public void setReqCount(int reqCount) {
		this.reqCount = reqCount;
	}

	public int getSuccessCount() {
		return successCount;
	}

	public void setSuccessCount(int successCount) {
		this.successCount = successCount;
	}

	public int getFailCount() {
		return failCount;
	}

	public void setFailCount(int failCount) {
		this.failCount = failCount;
	}

	public int getErrorCount() {
		return errorCount;
	}

	public void setErrorCount(int errorCount) {
		this.errorCount = errorCount;
	}

	public List<Map<String, String>> getFailReason() {
		return failReason;
	}

	public void setFailReason(List<Map<String, String>> failReason) {
		this.failReason = failReason;
	}

	public void addFailReason(Map<String, String> failReason) {
		this.failReason.add(failReason);
	}

	public String getMsgId() {
		return msgId;
	}

	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}

	public void setSmsId(int smsId) {
	    this.smsId = smsId;
	}

	public int getSmsId() {
	    return smsId;
	}

	public void setSmsStatus(int status) {
	    this.status = status;
	}

	public int getSmsStatus() {
	    return status;
	}

}
