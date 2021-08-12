/**
 * 
 */
package com.coway.trust.biz.sales.pst;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * @author Yunseok_Jang
 *
 */
public class PSTSalesDVO implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2192446305482795004L;
	
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
	private Date crtDt;
	private int crtUserId;
	private String pstStockRem;
	private int pstCurRate;
	private int pstCurTypeId;
	private int pstTotAmt;

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
	public Date getCrtDt() {
		return crtDt;
	}
	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
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
	public int getPstCurRate() {
		return pstCurRate;
	}
	public void setPstCurRate(int pstCurRate) {
		this.pstCurRate = pstCurRate;
	}
	public int getPstCurTypeId() {
		return pstCurTypeId;
	}
	public void setPstCurTypeId(int pstCurTypeId) {
		this.pstCurTypeId = pstCurTypeId;
	}
	public int getPstTotAmt() {
		return pstTotAmt;
	}
	public void setPstTotAmt(int pstTotAmt) {
		this.pstTotAmt = pstTotAmt;
	}
	
}
