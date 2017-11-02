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
public class PSTLogVO implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6442289869821780061L;
	
	private String pstTrnsitId;
	private int pstSalesOrdId;
	private int pstStockId;
	private String pstStockRem;
	private int pstQty;
	private int pstTypeId;
	private String pstRefNo;
	private Date crtDt;
	private int crtUserId;
	
	public String getPstTrnsitId() {
		return pstTrnsitId;
	}
	public void setPstTrnsitId(String pstTrnsitId) {
		this.pstTrnsitId = pstTrnsitId;
	}
	public int getPstSalesOrdId() {
		return pstSalesOrdId;
	}
	public void setPstSalesOrdId(int pstSalesOrdId) {
		this.pstSalesOrdId = pstSalesOrdId;
	}
	public int getPstStockId() {
		return pstStockId;
	}
	public void setPstStockId(int pstStockId) {
		this.pstStockId = pstStockId;
	}
	public String getPstStockRem() {
		return pstStockRem;
	}
	public void setPstStockRem(String pstStockRem) {
		this.pstStockRem = pstStockRem;
	}
	public int getPstQty() {
		return pstQty;
	}
	public void setPstQty(int pstQty) {
		this.pstQty = pstQty;
	}
	public int getPstTypeId() {
		return pstTypeId;
	}
	public void setPstTypeId(int pstTypeId) {
		this.pstTypeId = pstTypeId;
	}
	public String getPstRefNo() {
		return pstRefNo;
	}
	public void setPstRefNo(String pstRefNo) {
		this.pstRefNo = pstRefNo;
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
}
