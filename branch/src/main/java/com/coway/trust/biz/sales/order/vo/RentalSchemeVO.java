package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;


/**
 * The persistent class for the SAL0071D database table.
 * 
 */
public class RentalSchemeVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int renSchId;

	private int isSync;

	private String renSchDt;

	private int renSchTerms;

	private int salesOrdId;

	private String stusCodeId;

	public RentalSchemeVO() {
	}

	public int getRenSchId() {
		return renSchId;
	}

	public void setRenSchId(int renSchId) {
		this.renSchId = renSchId;
	}

	public int getIsSync() {
		return isSync;
	}

	public void setIsSync(int isSync) {
		this.isSync = isSync;
	}

	public String getRenSchDt() {
		return renSchDt;
	}

	public void setRenSchDt(String renSchDt) {
		this.renSchDt = renSchDt;
	}

	public int getRenSchTerms() {
		return renSchTerms;
	}

	public void setRenSchTerms(int renSchTerms) {
		this.renSchTerms = renSchTerms;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public String getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(String stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

}