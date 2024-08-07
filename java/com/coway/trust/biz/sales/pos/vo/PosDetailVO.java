package com.coway.trust.biz.sales.pos.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PosDetailVO implements Serializable{

	
	private static final long serialVersionUID = 1L;
	
	private int posItmId;
	
	private int posModuleTypeId;
	
	private int posTypeId;
	
	private int rcvStusId;
	
	private int posId;
	
	public int getPosId() {
		return posId;
	}

	public void setPosId(int posId) {
		this.posId = posId;
	}

	public int getPosItmId() {
		return posItmId;
	}

	public void setPosItmId(int posItmId) {
		this.posItmId = posItmId;
	}

	public int getPosModuleTypeId() {
		return posModuleTypeId;
	}

	public void setPosModuleTypeId(int posModuleTypeId) {
		this.posModuleTypeId = posModuleTypeId;
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
