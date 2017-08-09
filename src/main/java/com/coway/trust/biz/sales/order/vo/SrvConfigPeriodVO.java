package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0088D database table.
 * 
 */
public class SrvConfigPeriodVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long srvPrdId;

	private BigDecimal srvConfigId;

	private BigDecimal srvMbrshId;

	private BigDecimal srvPrdCntrctId;

	private Date srvPrdCrtDt;

	private BigDecimal srvPrdCrtUserId;

	private BigDecimal srvPrdDur;

	private Date srvPrdExprDt;

	private String srvPrdRem;

	private Date srvPrdStartDt;

	private BigDecimal srvPrdStusId;

	private Date srvPrdUpdDt;

	private BigDecimal srvPrdUpdUserId;

	public SrvConfigPeriodVO() {
	}

	public long getSrvPrdId() {
		return this.srvPrdId;
	}

	public void setSrvPrdId(long srvPrdId) {
		this.srvPrdId = srvPrdId;
	}

	public BigDecimal getSrvConfigId() {
		return this.srvConfigId;
	}

	public void setSrvConfigId(BigDecimal srvConfigId) {
		this.srvConfigId = srvConfigId;
	}

	public BigDecimal getSrvMbrshId() {
		return this.srvMbrshId;
	}

	public void setSrvMbrshId(BigDecimal srvMbrshId) {
		this.srvMbrshId = srvMbrshId;
	}

	public BigDecimal getSrvPrdCntrctId() {
		return this.srvPrdCntrctId;
	}

	public void setSrvPrdCntrctId(BigDecimal srvPrdCntrctId) {
		this.srvPrdCntrctId = srvPrdCntrctId;
	}

	public Date getSrvPrdCrtDt() {
		return this.srvPrdCrtDt;
	}

	public void setSrvPrdCrtDt(Date srvPrdCrtDt) {
		this.srvPrdCrtDt = srvPrdCrtDt;
	}

	public BigDecimal getSrvPrdCrtUserId() {
		return this.srvPrdCrtUserId;
	}

	public void setSrvPrdCrtUserId(BigDecimal srvPrdCrtUserId) {
		this.srvPrdCrtUserId = srvPrdCrtUserId;
	}

	public BigDecimal getSrvPrdDur() {
		return this.srvPrdDur;
	}

	public void setSrvPrdDur(BigDecimal srvPrdDur) {
		this.srvPrdDur = srvPrdDur;
	}

	public Date getSrvPrdExprDt() {
		return this.srvPrdExprDt;
	}

	public void setSrvPrdExprDt(Date srvPrdExprDt) {
		this.srvPrdExprDt = srvPrdExprDt;
	}

	public String getSrvPrdRem() {
		return this.srvPrdRem;
	}

	public void setSrvPrdRem(String srvPrdRem) {
		this.srvPrdRem = srvPrdRem;
	}

	public Date getSrvPrdStartDt() {
		return this.srvPrdStartDt;
	}

	public void setSrvPrdStartDt(Date srvPrdStartDt) {
		this.srvPrdStartDt = srvPrdStartDt;
	}

	public BigDecimal getSrvPrdStusId() {
		return this.srvPrdStusId;
	}

	public void setSrvPrdStusId(BigDecimal srvPrdStusId) {
		this.srvPrdStusId = srvPrdStusId;
	}

	public Date getSrvPrdUpdDt() {
		return this.srvPrdUpdDt;
	}

	public void setSrvPrdUpdDt(Date srvPrdUpdDt) {
		this.srvPrdUpdDt = srvPrdUpdDt;
	}

	public BigDecimal getSrvPrdUpdUserId() {
		return this.srvPrdUpdUserId;
	}

	public void setSrvPrdUpdUserId(BigDecimal srvPrdUpdUserId) {
		this.srvPrdUpdUserId = srvPrdUpdUserId;
	}

}