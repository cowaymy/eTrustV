package com.coway.trust.biz.payment.payment.service;

public class PayDHistoryVO {
	private int HistoryId;
	private int TypeId;
	private int payId;
	private int payItemId;
	private String valueFr;
	private String valueTo;
	private int refIdFr;
	private int refIdTo;
	private String createAt;
	private int createBy;
	
	public int getHistoryId() {
		return HistoryId;
	}
	public void setHistoryId(int historyId) {
		HistoryId = historyId;
	}
	public int getTypeId() {
		return TypeId;
	}
	public void setTypeId(int typeId) {
		TypeId = typeId;
	}
	public int getPayId() {
		return payId;
	}
	public void setPayId(int payId) {
		this.payId = payId;
	}
	public int getPayItemId() {
		return payItemId;
	}
	public void setPayItemId(int payItemId) {
		this.payItemId = payItemId;
	}
	public String getValueFr() {
		return valueFr;
	}
	public void setValueFr(String valueFr) {
		this.valueFr = valueFr;
	}
	public String getValueTo() {
		return valueTo;
	}
	public void setValueTo(String valueTo) {
		this.valueTo = valueTo;
	}
	public int getRefIdFr() {
		return refIdFr;
	}
	public void setRefIdFr(int refIdFr) {
		this.refIdFr = refIdFr;
	}
	public int getRefIdTo() {
		return refIdTo;
	}
	public void setRefIdTo(int refIdTo) {
		this.refIdTo = refIdTo;
	}
	public String getCreateAt() {
		return createAt;
	}
	public void setCreateAt(String createAt) {
		this.createAt = createAt;
	}
	public int getCreateBy() {
		return createBy;
	}
	public void setCreateBy(int createBy) {
		this.createBy = createBy;
	}
	@Override
	public String toString() {
		return "PayDHistoryVO [HistoryId=" + HistoryId + ", TypeId=" + TypeId + ", payId=" + payId + ", payItemId="
				+ payItemId + ", valueFr=" + valueFr + ", valueTo=" + valueTo + ", refIdFr=" + refIdFr + ", refIdTo="
				+ refIdTo + ", createAt=" + createAt + ", createBy=" + createBy + "]";
	}
	
	
	
}
