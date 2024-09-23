package com.coway.trust.config.ctos.client.xml.proxy.ws;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.Data;


@AllArgsConstructor
public class ResRequestVO {
    private String custIc;
    private String resultRaw;
    private String ficoScore;
    private String batchNo;
    private Date ctosDate;
    private boolean bankRupt;
    private String confirmEntity;


	public String getCustIc() {
		return custIc;
	}
	public void setCustIc(String custIc) {
		this.custIc = custIc;
	}
	public String getResultRaw() {
		return resultRaw;
	}
	public void setResultRaw(String resultRaw) {
		this.resultRaw = resultRaw;
	}
	public String getFicoScore() {
		return ficoScore;
	}
	public void setFicoScore(String ficoScore) {
		this.ficoScore = ficoScore;
	}
	public String getBatchNo() {
		return batchNo;
	}
	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}
	public Date getCtosDate() {
		return ctosDate;
	}
	public void setCtosDate(Date ctosDate) {
		this.ctosDate = ctosDate;
	}
	public boolean isBankRupt() {
		return bankRupt;
	}
	public void setBankRupt(boolean bankRupt) {
		this.bankRupt = bankRupt;
	}
	public String getConfirmEntity() {
		return confirmEntity;
	}
	public void setConfirmEntity(String confirmEntity) {
		this.confirmEntity = confirmEntity;
	}



}