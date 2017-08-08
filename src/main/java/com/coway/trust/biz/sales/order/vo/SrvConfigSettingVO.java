package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0089D database table.
 * 
 */
public class SrvConfigSettingVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long srvSettId;

	private BigDecimal srvConfigId;

	private Date srvSettCrtDt;

	private BigDecimal srvSettCrtUserId;

	private String srvSettRem;

	private BigDecimal srvSettStusId;

	private BigDecimal srvSettTypeId;

	public SrvConfigSettingVO() {
	}

	public long getSrvSettId() {
		return this.srvSettId;
	}

	public void setSrvSettId(long srvSettId) {
		this.srvSettId = srvSettId;
	}

	public BigDecimal getSrvConfigId() {
		return this.srvConfigId;
	}

	public void setSrvConfigId(BigDecimal srvConfigId) {
		this.srvConfigId = srvConfigId;
	}

	public Date getSrvSettCrtDt() {
		return this.srvSettCrtDt;
	}

	public void setSrvSettCrtDt(Date srvSettCrtDt) {
		this.srvSettCrtDt = srvSettCrtDt;
	}

	public BigDecimal getSrvSettCrtUserId() {
		return this.srvSettCrtUserId;
	}

	public void setSrvSettCrtUserId(BigDecimal srvSettCrtUserId) {
		this.srvSettCrtUserId = srvSettCrtUserId;
	}

	public String getSrvSettRem() {
		return this.srvSettRem;
	}

	public void setSrvSettRem(String srvSettRem) {
		this.srvSettRem = srvSettRem;
	}

	public BigDecimal getSrvSettStusId() {
		return this.srvSettStusId;
	}

	public void setSrvSettStusId(BigDecimal srvSettStusId) {
		this.srvSettStusId = srvSettStusId;
	}

	public BigDecimal getSrvSettTypeId() {
		return this.srvSettTypeId;
	}

	public void setSrvSettTypeId(BigDecimal srvSettTypeId) {
		this.srvSettTypeId = srvSettTypeId;
	}

}