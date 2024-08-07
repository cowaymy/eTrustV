package com.coway.trust.biz.api.vo.chatbotInbound;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class PaymentVO implements Serializable{
	private String paymentMtd;
	private String lastPayDate;
	private String paymentStatus;
	private String deductionResult;

	@SuppressWarnings("unchecked")
	public static PaymentVO create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, PaymentVO.class);
	}

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
