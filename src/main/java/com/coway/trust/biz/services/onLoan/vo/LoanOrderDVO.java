/**
 *
 */
package com.coway.trust.biz.services.onLoan.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * The persistent class for the SVC0114D database table.
 *
 * @author HQIT-HUIDING
 * @date Feb 17, 2020
 *
 */
public class LoanOrderDVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int editTypeId;
	private int itmCallEntryId;
	private int itmId;
	private int itmNo;
	private BigDecimal itmPrc;
	private int itmPrcId;
	private int itmQty;
	private int itmStkId;
	private int itmTax;
	private int loanOrdId;
	private int stusCodeId;
	private Date updDt;
	private int updUserId;
	private int itmCompId;

	public int getItmCompId() {
		return itmCompId;
	}

	public void setItmCompId(int itmCompId) {
		this.itmCompId = itmCompId;
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

	public int getLoanOrdId() {
		return loanOrdId;
	}

	public void setLoanOrdId(int loanOrdId) {
		this.loanOrdId = loanOrdId;
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

	public LoanOrderDVO() {
	}
}
