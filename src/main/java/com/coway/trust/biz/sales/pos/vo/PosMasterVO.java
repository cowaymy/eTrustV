package com.coway.trust.biz.sales.pos.vo;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * The persistent class for the SAL0057D database table.
 * 
 */

@JsonIgnoreProperties(ignoreUnknown = true)
public class PosMasterVO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int posId;
	
	private String posNo;
	
	private int stusId;
	
	private int posModuleTypeId;
	
	private int posTypeId;
	
	
	//Change Status
	private int changeStatus;
	

	public int getPosId() {
		return posId;
	}

	public void setPosId(int posId) {
		this.posId = posId;
	}

	public String getPosNo() {
		return posNo;
	}

	public void setPosNo(String posNo) {
		this.posNo = posNo;
	}

	public int getStusId() {
		return stusId;
	}

	public void setStusId(int stusId) {
		this.stusId = stusId;
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

	public int getChangeStatus() {
		return changeStatus;
	}

	public void setChangeStatus(int changeStatus) {
		this.changeStatus = changeStatus;
	}
	
}
