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

	private int cntrctId;

	private Date cntrctCrtDt;

	private int cntrctCrtUserId;

	private int cntrctObligtPriod;

	private int cntrctRcoPriod;

	private String cntrctRem;

	private int cntrctRentalPriod;

	private int cntrctSalesOrdId;

	private int cntrctStusId;

	private Date cntrctUpdDt;

	private int cntrctUpdUserId;

	public SalesOrderContractVO() {
	}

	public int getCntrctId() {
		return cntrctId;
	}

	public void setCntrctId(int cntrctId) {
		this.cntrctId = cntrctId;
	}

	public Date getCntrctCrtDt() {
		return cntrctCrtDt;
	}

	public void setCntrctCrtDt(Date cntrctCrtDt) {
		this.cntrctCrtDt = cntrctCrtDt;
	}

	public int getCntrctCrtUserId() {
		return cntrctCrtUserId;
	}

	public void setCntrctCrtUserId(int cntrctCrtUserId) {
		this.cntrctCrtUserId = cntrctCrtUserId;
	}

	public int getCntrctObligtPriod() {
		return cntrctObligtPriod;
	}

	public void setCntrctObligtPriod(int cntrctObligtPriod) {
		this.cntrctObligtPriod = cntrctObligtPriod;
	}

	public int getCntrctRcoPriod() {
    return cntrctRcoPriod;
  }

  public void setCntrctRcoPriod(int cntrctRcoPriod) {
    this.cntrctRcoPriod = cntrctRcoPriod;
  }

	public String getCntrctRem() {
		return cntrctRem;
	}

	public void setCntrctRem(String cntrctRem) {
		this.cntrctRem = cntrctRem;
	}

	public int getCntrctRentalPriod() {
		return cntrctRentalPriod;
	}

	public void setCntrctRentalPriod(int cntrctRentalPriod) {
		this.cntrctRentalPriod = cntrctRentalPriod;
	}

	public int getCntrctSalesOrdId() {
		return cntrctSalesOrdId;
	}

	public void setCntrctSalesOrdId(int cntrctSalesOrdId) {
		this.cntrctSalesOrdId = cntrctSalesOrdId;
	}

	public int getCntrctStusId() {
		return cntrctStusId;
	}

	public void setCntrctStusId(int cntrctStusId) {
		this.cntrctStusId = cntrctStusId;
	}

	public Date getCntrctUpdDt() {
		return cntrctUpdDt;
	}

	public void setCntrctUpdDt(Date cntrctUpdDt) {
		this.cntrctUpdDt = cntrctUpdDt;
	}

	public int getCntrctUpdUserId() {
		return cntrctUpdUserId;
	}

	public void setCntrctUpdUserId(int cntrctUpdUserId) {
		this.cntrctUpdUserId = cntrctUpdUserId;
	}

}