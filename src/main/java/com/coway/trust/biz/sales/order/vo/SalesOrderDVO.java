package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0002D database table.
 * 
 */
public class SalesOrderDVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private BigDecimal editTypeId;

	private BigDecimal itmCallEntryId;

	private BigDecimal itmDscnt;

	private BigDecimal itmId;

	private BigDecimal itmNo;

	private BigDecimal itmPrc;

	private BigDecimal itmPrcId;

	private BigDecimal itmPv;

	private BigDecimal itmQty;

	private BigDecimal itmStkId;

	private BigDecimal itmTax;

	private BigDecimal salesOrdId;

	private BigDecimal stusCodeId;

	private Date updDt;

	private BigDecimal updUserId;

	public SalesOrderDVO() {
	}

	public BigDecimal getEditTypeId() {
		return this.editTypeId;
	}

	public void setEditTypeId(BigDecimal editTypeId) {
		this.editTypeId = editTypeId;
	}

	public BigDecimal getItmCallEntryId() {
		return this.itmCallEntryId;
	}

	public void setItmCallEntryId(BigDecimal itmCallEntryId) {
		this.itmCallEntryId = itmCallEntryId;
	}

	public BigDecimal getItmDscnt() {
		return this.itmDscnt;
	}

	public void setItmDscnt(BigDecimal itmDscnt) {
		this.itmDscnt = itmDscnt;
	}

	public BigDecimal getItmId() {
		return this.itmId;
	}

	public void setItmId(BigDecimal itmId) {
		this.itmId = itmId;
	}

	public BigDecimal getItmNo() {
		return this.itmNo;
	}

	public void setItmNo(BigDecimal itmNo) {
		this.itmNo = itmNo;
	}

	public BigDecimal getItmPrc() {
		return this.itmPrc;
	}

	public void setItmPrc(BigDecimal itmPrc) {
		this.itmPrc = itmPrc;
	}

	public BigDecimal getItmPrcId() {
		return this.itmPrcId;
	}

	public void setItmPrcId(BigDecimal itmPrcId) {
		this.itmPrcId = itmPrcId;
	}

	public BigDecimal getItmPv() {
		return this.itmPv;
	}

	public void setItmPv(BigDecimal itmPv) {
		this.itmPv = itmPv;
	}

	public BigDecimal getItmQty() {
		return this.itmQty;
	}

	public void setItmQty(BigDecimal itmQty) {
		this.itmQty = itmQty;
	}

	public BigDecimal getItmStkId() {
		return this.itmStkId;
	}

	public void setItmStkId(BigDecimal itmStkId) {
		this.itmStkId = itmStkId;
	}

	public BigDecimal getItmTax() {
		return this.itmTax;
	}

	public void setItmTax(BigDecimal itmTax) {
		this.itmTax = itmTax;
	}

	public BigDecimal getSalesOrdId() {
		return this.salesOrdId;
	}

	public void setSalesOrdId(BigDecimal salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public BigDecimal getStusCodeId() {
		return this.stusCodeId;
	}

	public void setStusCodeId(BigDecimal stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public Date getUpdDt() {
		return this.updDt;
	}

	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}

	public BigDecimal getUpdUserId() {
		return this.updUserId;
	}

	public void setUpdUserId(BigDecimal updUserId) {
		this.updUserId = updUserId;
	}

}