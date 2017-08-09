package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0087D database table.
 * 
 */
public class SrvConfigFilterVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long srvFilterId;

	private BigDecimal srvConfigId;

	private Date srvFilterCrtDt;

	private BigDecimal srvFilterCrtUserId;

	private Date srvFilterExprDt;

	private BigDecimal srvFilterPriod;

	private Date srvFilterPrvChgDt;

	private String srvFilterRem;

	private BigDecimal srvFilterStkId;

	private BigDecimal srvFilterStusId;

	private Date srvFilterUpdDt;

	private BigDecimal srvFilterUpdUserId;

	public SrvConfigFilterVO() {
	}

	public long getSrvFilterId() {
		return this.srvFilterId;
	}

	public void setSrvFilterId(long srvFilterId) {
		this.srvFilterId = srvFilterId;
	}

	public BigDecimal getSrvConfigId() {
		return this.srvConfigId;
	}

	public void setSrvConfigId(BigDecimal srvConfigId) {
		this.srvConfigId = srvConfigId;
	}

	public Date getSrvFilterCrtDt() {
		return this.srvFilterCrtDt;
	}

	public void setSrvFilterCrtDt(Date srvFilterCrtDt) {
		this.srvFilterCrtDt = srvFilterCrtDt;
	}

	public BigDecimal getSrvFilterCrtUserId() {
		return this.srvFilterCrtUserId;
	}

	public void setSrvFilterCrtUserId(BigDecimal srvFilterCrtUserId) {
		this.srvFilterCrtUserId = srvFilterCrtUserId;
	}

	public Date getSrvFilterExprDt() {
		return this.srvFilterExprDt;
	}

	public void setSrvFilterExprDt(Date srvFilterExprDt) {
		this.srvFilterExprDt = srvFilterExprDt;
	}

	public BigDecimal getSrvFilterPriod() {
		return this.srvFilterPriod;
	}

	public void setSrvFilterPriod(BigDecimal srvFilterPriod) {
		this.srvFilterPriod = srvFilterPriod;
	}

	public Date getSrvFilterPrvChgDt() {
		return this.srvFilterPrvChgDt;
	}

	public void setSrvFilterPrvChgDt(Date srvFilterPrvChgDt) {
		this.srvFilterPrvChgDt = srvFilterPrvChgDt;
	}

	public String getSrvFilterRem() {
		return this.srvFilterRem;
	}

	public void setSrvFilterRem(String srvFilterRem) {
		this.srvFilterRem = srvFilterRem;
	}

	public BigDecimal getSrvFilterStkId() {
		return this.srvFilterStkId;
	}

	public void setSrvFilterStkId(BigDecimal srvFilterStkId) {
		this.srvFilterStkId = srvFilterStkId;
	}

	public BigDecimal getSrvFilterStusId() {
		return this.srvFilterStusId;
	}

	public void setSrvFilterStusId(BigDecimal srvFilterStusId) {
		this.srvFilterStusId = srvFilterStusId;
	}

	public Date getSrvFilterUpdDt() {
		return this.srvFilterUpdDt;
	}

	public void setSrvFilterUpdDt(Date srvFilterUpdDt) {
		this.srvFilterUpdDt = srvFilterUpdDt;
	}

	public BigDecimal getSrvFilterUpdUserId() {
		return this.srvFilterUpdUserId;
	}

	public void setSrvFilterUpdUserId(BigDecimal srvFilterUpdUserId) {
		this.srvFilterUpdUserId = srvFilterUpdUserId;
	}

}