package com.coway.trust.biz.api.vo.chatbotInbound;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class OutStdVO  implements Serializable{
	private String orderNo;
	private String accountStatus;
	private String totalAmtDue;
	private Double lastPaymentAmt;
	private String lastPayDate;

	@SuppressWarnings("unchecked")
	public static OutStdVO create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, OutStdVO.class);
	}

	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getAccountStatus() {
		return accountStatus;
	}
	public void setAccountStatus(String accountStatus) {
		this.accountStatus = accountStatus;
	}

	public String getTotalAmtDue() {
		return totalAmtDue;
	}
	public void setTotalAmtDue(String totalAmtDue) {
		if(CommonUtils.isEmpty(totalAmtDue)){
			totalAmtDue = "0.00";
		}

		this.totalAmtDue = totalAmtDue;
	}

	public Double getLastPaymentAmt() {
		return lastPaymentAmt;
	}
	public void setLastPaymentAmt(Double lastPaymentAmt) {
		this.lastPaymentAmt = lastPaymentAmt;
	}

	public String getLastPayDate() {
		return lastPayDate;
	}
	public void setLastPayDate(String lastPayDate){

		this.lastPayDate = lastPayDate;
	}
}
