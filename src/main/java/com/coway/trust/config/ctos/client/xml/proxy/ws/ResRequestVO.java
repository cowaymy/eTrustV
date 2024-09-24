package com.coway.trust.config.ctos.client.xml.proxy.ws;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
@AllArgsConstructor
public class ResRequestVO {

	private String custIc;
	private String batchNo;
	private int ficoScore;
	private String resultRaw;
	private Date ctosDate;
	private String bankRupt;
	private String confirmEntity;


	public String getCustIc() {
		return custIc;
	}
	public void setCustIc(String custIc) {
		this.custIc = custIc;
	}
	public String getBatchNo() {
		return batchNo;
	}
	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}
	public int getFicoScore() {
		return ficoScore;
	}
	public void setFicoScore(int ficoScore) {
		this.ficoScore = ficoScore;
	}
	public String getResultRaw() {
		return resultRaw;
	}
	public void setResultRaw(String resultRaw) {
		this.resultRaw = resultRaw;
	}
	public Date getCtosDate() {
		return ctosDate;
	}
	public void setCtosDate(Date ctosDate) {
		this.ctosDate = ctosDate;
	}
	public String getBankRupt() {
		return bankRupt;
	}
	public void setBankRupt(String bankRupt) {
		this.bankRupt = bankRupt;
	}
	public String getConfirmEntity() {
		return confirmEntity;
	}
	public void setConfirmEntity(String confirmEntity) {
		this.confirmEntity = confirmEntity;
	}

}
