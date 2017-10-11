package com.coway.trust.web.sales.pst;

import java.math.BigDecimal;
import java.util.Date;

import com.coway.trust.cmmn.model.BasicData;
import com.fasterxml.jackson.annotation.JsonFormat;

public class PSTStockListGridForm extends BasicData {
	private int pstItmId;
	private int pstSalesOrdId;
	private int pstItmStkId;
	private BigDecimal pstItmPrc;
	private int pstItmReqQty;
	private BigDecimal pstItmTotPrc;
	private int pstItmDoQty;
	private int pstItmCanQty;
	private int pstItmCanQty2;
	private int pstItmBalQty;
	private int crtUserId;
	private String pstStockRem;
	@JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy/MM/dd")
	private Date crtDt;
	private String c1;
	private String c2;
	private String c3;
	
	public int getPstItmId() {
		return pstItmId;
	}
	public void setPstItmId(int pstItmId) {
		this.pstItmId = pstItmId;
	}
	public int getPstSalesOrdId() {
		return pstSalesOrdId;
	}
	public void setPstSalesOrdId(int pstSalesOrdId) {
		this.pstSalesOrdId = pstSalesOrdId;
	}
	public int getPstItmStkId() {
		return pstItmStkId;
	}
	public void setPstItmStkId(int pstItmStkId) {
		this.pstItmStkId = pstItmStkId;
	}
	public BigDecimal getPstItmPrc() {
		return pstItmPrc;
	}
	public void setPstItmPrc(BigDecimal pstItmPrc) {
		this.pstItmPrc = pstItmPrc;
	}
	public int getPstItmReqQty() {
		return pstItmReqQty;
	}
	public void setPstItmReqQty(int pstItmReqQty) {
		this.pstItmReqQty = pstItmReqQty;
	}
	public BigDecimal getPstItmTotPrc() {
		return pstItmTotPrc;
	}
	public void setPstItmTotPrc(BigDecimal pstItmTotPrc) {
		this.pstItmTotPrc = pstItmTotPrc;
	}
	public int getPstItmDoQty() {
		return pstItmDoQty;
	}
	public void setPstItmDoQty(int pstItmDoQty) {
		this.pstItmDoQty = pstItmDoQty;
	}
	public int getPstItmCanQty() {
		return pstItmCanQty;
	}
	public void setPstItmCanQty(int pstItmCanQty) {
		this.pstItmCanQty = pstItmCanQty;
	}
	public int getPstItmCanQty2() {
		return pstItmCanQty2;
	}
	public void setPstItmCanQty2(int pstItmCanQty2) {
		this.pstItmCanQty2 = pstItmCanQty2;
	}
	public int getPstItmBalQty() {
		return pstItmBalQty;
	}
	public void setPstItmBalQty(int pstItmBalQty) {
		this.pstItmBalQty = pstItmBalQty;
	}
	public int getCrtUserId() {
		return crtUserId;
	}
	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}
	public String getPstStockRem() {
		return pstStockRem;
	}
	public void setPstStockRem(String pstStockRem) {
		this.pstStockRem = pstStockRem;
	}
	public Date getCrtDt() {
		return crtDt;
	}
	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}
	public String getC1() {
		return c1;
	}
	public void setC1(String c1) {
		this.c1 = c1;
	}
	public String getC2() {
		return c2;
	}
	public void setC2(String c2) {
		this.c2 = c2;
	}
	public String getC3() {
		return c3;
	}
	public void setC3(String c3) {
		this.c3 = c3;
	}

}
