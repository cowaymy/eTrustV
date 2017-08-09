package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0090D database table.
 * 
 */
public class SrvConfigurationVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long srvConfigId;

	private BigDecimal srvBsGen;

	private BigDecimal srvBsWeek;

	private BigDecimal srvCodyId;

	private Date srvCrtDt;

	private BigDecimal srvCrtUserId;

	private Date srvPrevDt;

	private String srvRem;

	private BigDecimal srvSoId;

	private BigDecimal srvStusId;

	private Date srvUpdDt;

	private BigDecimal srvUpdUserId;

	public SrvConfigurationVO() {
	}

	public long getSrvConfigId() {
		return this.srvConfigId;
	}

	public void setSrvConfigId(long srvConfigId) {
		this.srvConfigId = srvConfigId;
	}

	public BigDecimal getSrvBsGen() {
		return this.srvBsGen;
	}

	public void setSrvBsGen(BigDecimal srvBsGen) {
		this.srvBsGen = srvBsGen;
	}

	public BigDecimal getSrvBsWeek() {
		return this.srvBsWeek;
	}

	public void setSrvBsWeek(BigDecimal srvBsWeek) {
		this.srvBsWeek = srvBsWeek;
	}

	public BigDecimal getSrvCodyId() {
		return this.srvCodyId;
	}

	public void setSrvCodyId(BigDecimal srvCodyId) {
		this.srvCodyId = srvCodyId;
	}

	public Date getSrvCrtDt() {
		return this.srvCrtDt;
	}

	public void setSrvCrtDt(Date srvCrtDt) {
		this.srvCrtDt = srvCrtDt;
	}

	public BigDecimal getSrvCrtUserId() {
		return this.srvCrtUserId;
	}

	public void setSrvCrtUserId(BigDecimal srvCrtUserId) {
		this.srvCrtUserId = srvCrtUserId;
	}

	public Date getSrvPrevDt() {
		return this.srvPrevDt;
	}

	public void setSrvPrevDt(Date srvPrevDt) {
		this.srvPrevDt = srvPrevDt;
	}

	public String getSrvRem() {
		return this.srvRem;
	}

	public void setSrvRem(String srvRem) {
		this.srvRem = srvRem;
	}

	public BigDecimal getSrvSoId() {
		return this.srvSoId;
	}

	public void setSrvSoId(BigDecimal srvSoId) {
		this.srvSoId = srvSoId;
	}

	public BigDecimal getSrvStusId() {
		return this.srvStusId;
	}

	public void setSrvStusId(BigDecimal srvStusId) {
		this.srvStusId = srvStusId;
	}

	public Date getSrvUpdDt() {
		return this.srvUpdDt;
	}

	public void setSrvUpdDt(Date srvUpdDt) {
		this.srvUpdDt = srvUpdDt;
	}

	public BigDecimal getSrvUpdUserId() {
		return this.srvUpdUserId;
	}

	public void setSrvUpdUserId(BigDecimal srvUpdUserId) {
		this.srvUpdUserId = srvUpdUserId;
	}

}