package com.coway.trust.biz.sales.pos.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PosMemberVO implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private int memId;
	
	private String memCode;
	
	private int posId;
	
	private int posTypeId;
	
	private int rcvStusId;

	public int getMemId() {
		return memId;
	}

	public void setMemId(int memId) {
		this.memId = memId;
	}

	public String getMemCode() {
		return memCode;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}

	public int getPosId() {
		return posId;
	}

	public void setPosId(int posId) {
		this.posId = posId;
	}

	public int getPosTypeId() {
		return posTypeId;
	}

	public void setPosTypeId(int posTypeId) {
		this.posTypeId = posTypeId;
	}

	public int getRcvStusId() {
		return rcvStusId;
	}

	public void setRcvStusId(int rcvStusId) {
		this.rcvStusId = rcvStusId;
	}
	
	
	
	
}
