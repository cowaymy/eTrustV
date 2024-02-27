package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0002D database table.
 *
 */
public class SalesOrderDVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int editTypeId;

	private int itmCallEntryId;

	private int itmDscnt;

	private int itmId;

	private int itmNo;

	private BigDecimal itmPrc;

	private int itmPrcId;

	private BigDecimal itmPv;

	private int itmQty;

	private int itmStkId;

	private int itmTax;

	private int salesOrdId;

	private int stusCodeId;

	private Date updDt;

	private int updUserId;

	private int itmCompId;

	private int isExstCust;

	public SalesOrderDVO() {
	}

	public int getEditTypeId() {
		return editTypeId;
	}

	public void setEditTypeId(int editTypeId) {
		this.editTypeId = editTypeId;
	}

	public int getItmCallEntryId() {
		return itmCallEntryId;
	}

	public void setItmCallEntryId(int itmCallEntryId) {
		this.itmCallEntryId = itmCallEntryId;
	}

	public int getItmDscnt() {
		return itmDscnt;
	}

	public void setItmDscnt(int itmDscnt) {
		this.itmDscnt = itmDscnt;
	}

	public int getItmId() {
		return itmId;
	}

	public void setItmId(int itmId) {
		this.itmId = itmId;
	}

	public int getItmNo() {
		return itmNo;
	}

	public void setItmNo(int itmNo) {
		this.itmNo = itmNo;
	}

	public BigDecimal getItmPrc() {
		return itmPrc;
	}

	public void setItmPrc(BigDecimal itmPrc) {
		this.itmPrc = itmPrc;
	}

	public int getItmPrcId() {
		return itmPrcId;
	}

	public void setItmPrcId(int itmPrcId) {
		this.itmPrcId = itmPrcId;
	}

	public BigDecimal getItmPv() {
		return itmPv;
	}

	public void setItmPv(BigDecimal itmPv) {
		this.itmPv = itmPv;
	}

	public int getItmQty() {
		return itmQty;
	}

	public void setItmQty(int itmQty) {
		this.itmQty = itmQty;
	}

	public int getItmStkId() {
		return itmStkId;
	}

	public void setItmStkId(int itmStkId) {
		this.itmStkId = itmStkId;
	}

	public int getItmTax() {
		return itmTax;
	}

	public void setItmTax(int itmTax) {
		this.itmTax = itmTax;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public Date getUpdDt() {
		return updDt;
	}

	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}

	public int getUpdUserId() {
		return updUserId;
	}

	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}

	public int getItmCompId() {
		return itmCompId;
	}

	public void setItmCompId(int itmCompId) {
		this.itmCompId = itmCompId;
	}

	public int getIsExstCust() {
		return isExstCust;
	}

	public void setIsExstCust(int isExstCust) {
		this.isExstCust = isExstCust;
	}
}