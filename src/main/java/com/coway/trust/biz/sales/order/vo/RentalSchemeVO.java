package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;


/**
 * The persistent class for the SAL0071D database table.
 * 
 */
public class RentalSchemeVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long renSchId;

	private BigDecimal isSync;

	private String renSchDt;

	private BigDecimal renSchTerms;

	private BigDecimal salesOrdId;

	private String stusCodeId;

	public RentalSchemeVO() {
	}

	public long getRenSchId() {
		return this.renSchId;
	}

	public void setRenSchId(long renSchId) {
		this.renSchId = renSchId;
	}

	public BigDecimal getIsSync() {
		return this.isSync;
	}

	public void setIsSync(BigDecimal isSync) {
		this.isSync = isSync;
	}

	public String getRenSchDt() {
		return this.renSchDt;
	}

	public void setRenSchDt(String renSchDt) {
		this.renSchDt = renSchDt;
	}

	public BigDecimal getRenSchTerms() {
		return this.renSchTerms;
	}

	public void setRenSchTerms(BigDecimal renSchTerms) {
		this.renSchTerms = renSchTerms;
	}

	public BigDecimal getSalesOrdId() {
		return this.salesOrdId;
	}

	public void setSalesOrdId(BigDecimal salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public String getStusCodeId() {
		return this.stusCodeId;
	}

	public void setStusCodeId(String stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

}