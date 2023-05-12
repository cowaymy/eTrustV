package com.coway.trust.api.mobile.payment.mobileLumpSumPayment;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "MobileLumpSumPaymentOrderDetailsForm", description = "MobileLumpSumPaymentOrderDetailsForm")
public class MobileLumpSumPaymentOrderDetailsForm {
	private int srvMemId;
	private int ordId;
	private String ordNo;
	private int ordPaymentTypeId;
	private String ordPaymentTypeName;
	private String payType;
	private Double otstndAmt;
	private Double inputOtstndAmt;
	private int custId;
	private String nric;
	private int ordTypeId;
	private String ordTypeName;

	public int getOrdId() {
		return ordId;
	}
	public void setOrdId(int ordId) {
		this.ordId = ordId;
	}
	public String getOrdNo() {
		return ordNo;
	}
	public void setOrdNo(String ordNo) {
		this.ordNo = ordNo;
	}
	public int getOrdPaymentTypeId() {
		return ordPaymentTypeId;
	}
	public void setOrdPaymentTypeId(int ordPaymentTypeId) {
		this.ordPaymentTypeId = ordPaymentTypeId;
	}
	public String getOrdPaymentTypeName() {
		return ordPaymentTypeName;
	}
	public void setOrdPaymentTypeName(String ordPaymentTypeName) {
		this.ordPaymentTypeName = ordPaymentTypeName;
	}
	public Double getOtstndAmt() {
		return otstndAmt;
	}
	public void setOtstndAmt(Double otstndAmt) {
		this.otstndAmt = otstndAmt;
	}
	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}
	public String getNric() {
		return nric;
	}
	public void setNric(String nric) {
		this.nric = nric;
	}
	public int getOrdTypeId() {
		return ordTypeId;
	}
	public void setOrdTypeId(int ordTypeId) {
		this.ordTypeId = ordTypeId;
	}
	public String getOrdTypeName() {
		return ordTypeName;
	}
	public void setOrdTypeName(String ordTypeName) {
		this.ordTypeName = ordTypeName;
	}
	public Double getInputOtstndAmt() {
		return inputOtstndAmt;
	}
	public void setInputOtstndAmt(Double inputOtstndAmt) {
		this.inputOtstndAmt = inputOtstndAmt;
	}
	public String getPayType() {
		return payType;
	}
	public void setPayType(String payType) {
		this.payType = payType;
	}
	public int getSrvMemId() {
		return srvMemId;
	}
	public void setSrvMemId(int srvMemId) {
		this.srvMemId = srvMemId;
	}
}
