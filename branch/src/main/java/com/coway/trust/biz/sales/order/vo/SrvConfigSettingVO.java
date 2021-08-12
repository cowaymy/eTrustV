package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0089D database table.
 * 
 */
public class SrvConfigSettingVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int srvSettId;

	private int srvConfigId;

	private Date srvSettCrtDt;

	private int srvSettCrtUserId;

	private String srvSettRem;

	private int srvSettStusId;

	private int srvSettTypeId;

	public SrvConfigSettingVO() {
	}

	public int getSrvSettId() {
		return srvSettId;
	}

	public void setSrvSettId(int srvSettId) {
		this.srvSettId = srvSettId;
	}

	public int getSrvConfigId() {
		return srvConfigId;
	}

	public void setSrvConfigId(int srvConfigId) {
		this.srvConfigId = srvConfigId;
	}

	public Date getSrvSettCrtDt() {
		return srvSettCrtDt;
	}

	public void setSrvSettCrtDt(Date srvSettCrtDt) {
		this.srvSettCrtDt = srvSettCrtDt;
	}

	public int getSrvSettCrtUserId() {
		return srvSettCrtUserId;
	}

	public void setSrvSettCrtUserId(int srvSettCrtUserId) {
		this.srvSettCrtUserId = srvSettCrtUserId;
	}

	public String getSrvSettRem() {
		return srvSettRem;
	}

	public void setSrvSettRem(String srvSettRem) {
		this.srvSettRem = srvSettRem;
	}

	public int getSrvSettStusId() {
		return srvSettStusId;
	}

	public void setSrvSettStusId(int srvSettStusId) {
		this.srvSettStusId = srvSettStusId;
	}

	public int getSrvSettTypeId() {
		return srvSettTypeId;
	}

	public void setSrvSettTypeId(int srvSettTypeId) {
		this.srvSettTypeId = srvSettTypeId;
	}

}