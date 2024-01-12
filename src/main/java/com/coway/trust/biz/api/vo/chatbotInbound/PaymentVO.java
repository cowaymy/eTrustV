package com.coway.trust.biz.api.vo.chatbotInbound;

import java.io.Serializable;

public class PaymentVO implements Serializable{
	private String paymentMtd;
	private String lastPayDate;
	private String paymentStatus;
	private String deductionResult;

	public String getPaymentMtd() {
		return paymentMtd;
	}
	public void setPaymentMtd(String paymentMtd) {
		this.paymentMtd = paymentMtd;
	}

	public String getLastPayDate() {
		return lastPayDate;
	}
	public void setLastPayDate(String lastPayDate) {
		this.lastPayDate = lastPayDate;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}
	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public String getDeductionResult() {
		return deductionResult;
	}
	public void setDeductionResult(String deductionResult) {
		this.deductionResult = deductionResult;
	}
}
