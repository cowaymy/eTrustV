package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0003D database table.
 * 
 */
public class SalesOrderContractVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long cntrctId;

	private Date cntrctCrtDt;

	private BigDecimal cntrctCrtUserId;

	private BigDecimal cntrctObligtPriod;

	private String cntrctRem;

	private BigDecimal cntrctRentalPriod;

	private BigDecimal cntrctSalesOrdId;

	private BigDecimal cntrctStusId;

	private Date cntrctUpdDt;

	private BigDecimal cntrctUpdUserId;

	public SalesOrderContractVO() {
	}

	public long getCntrctId() {
		return this.cntrctId;
	}

	public void setCntrctId(long cntrctId) {
		this.cntrctId = cntrctId;
	}

	public Date getCntrctCrtDt() {
		return this.cntrctCrtDt;
	}

	public void setCntrctCrtDt(Date cntrctCrtDt) {
		this.cntrctCrtDt = cntrctCrtDt;
	}

	public BigDecimal getCntrctCrtUserId() {
		return this.cntrctCrtUserId;
	}

	public void setCntrctCrtUserId(BigDecimal cntrctCrtUserId) {
		this.cntrctCrtUserId = cntrctCrtUserId;
	}

	public BigDecimal getCntrctObligtPriod() {
		return this.cntrctObligtPriod;
	}

	public void setCntrctObligtPriod(BigDecimal cntrctObligtPriod) {
		this.cntrctObligtPriod = cntrctObligtPriod;
	}

	public String getCntrctRem() {
		return this.cntrctRem;
	}

	public void setCntrctRem(String cntrctRem) {
		this.cntrctRem = cntrctRem;
	}

	public BigDecimal getCntrctRentalPriod() {
		return this.cntrctRentalPriod;
	}

	public void setCntrctRentalPriod(BigDecimal cntrctRentalPriod) {
		this.cntrctRentalPriod = cntrctRentalPriod;
	}

	public BigDecimal getCntrctSalesOrdId() {
		return this.cntrctSalesOrdId;
	}

	public void setCntrctSalesOrdId(BigDecimal cntrctSalesOrdId) {
		this.cntrctSalesOrdId = cntrctSalesOrdId;
	}

	public BigDecimal getCntrctStusId() {
		return this.cntrctStusId;
	}

	public void setCntrctStusId(BigDecimal cntrctStusId) {
		this.cntrctStusId = cntrctStusId;
	}

	public Date getCntrctUpdDt() {
		return this.cntrctUpdDt;
	}

	public void setCntrctUpdDt(Date cntrctUpdDt) {
		this.cntrctUpdDt = cntrctUpdDt;
	}

	public BigDecimal getCntrctUpdUserId() {
		return this.cntrctUpdUserId;
	}

	public void setCntrctUpdUserId(BigDecimal cntrctUpdUserId) {
		this.cntrctUpdUserId = cntrctUpdUserId;
	}

}