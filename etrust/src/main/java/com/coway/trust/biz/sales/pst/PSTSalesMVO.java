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
public class PSTSalesMVO implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2594924121072384758L;
	
	private int pstSalesOrdId;
	private String pstRefNo;
	private int pstDealerId;
	private int pstDealerMailCntId;
	private int pstDealerDelvryCntId;
	private int pstDealerMailAddId;
	private int pstDealerDelvryAddId;
	private BigDecimal pstCurRate;
	private int pstCurTypeId;
	private BigDecimal pstTotAmt;
	private String pstRem;
	private int pstStusId;
	private Date crtDt;
	private int crtUserId;
	private int pic;
	private String pstCustPo;
	private String ssID;
	
	public String getSsID() {
		return ssID;
	}
	public void setSsID(String ssID) {
		this.ssID = ssID;
	}
	public int getPstSalesOrdId() {
		return pstSalesOrdId;
	}
	public void setPstSalesOrdId(int pstSalesOrdId) {
		this.pstSalesOrdId = pstSalesOrdId;
	}
	public String getPstRefNo() {
		return pstRefNo;
	}
	public void setPstRefNo(String pstRefNo) {
		this.pstRefNo = pstRefNo;
	}
	public int getPstDealerId() {
		return pstDealerId;
	}
	public void setPstDealerId(int pstDealerId) {
		this.pstDealerId = pstDealerId;
	}
	public int getPstDealerMailCntId() {
		return pstDealerMailCntId;
	}
	public void setPstDealerMailCntId(int pstDealerMailCntId) {
		this.pstDealerMailCntId = pstDealerMailCntId;
	}
	public int getPstDealerDelvryCntId() {
		return pstDealerDelvryCntId;
	}
	public void setPstDealerDelvryCntId(int pstDealerDelvryCntId) {
		this.pstDealerDelvryCntId = pstDealerDelvryCntId;
	}
	public int getPstDealerMailAddId() {
		return pstDealerMailAddId;
	}
	public void setPstDealerMailAddId(int pstDealerMailAddId) {
		this.pstDealerMailAddId = pstDealerMailAddId;
	}
	public int getPstDealerDelvryAddId() {
		return pstDealerDelvryAddId;
	}
	public void setPstDealerDelvryAddId(int pstDealerDelvryAddId) {
		this.pstDealerDelvryAddId = pstDealerDelvryAddId;
	}
	public BigDecimal getPstCurRate() {
		return pstCurRate;
	}
	public void setPstCurRate(BigDecimal pstCurRate) {
		this.pstCurRate = pstCurRate;
	}
	public int getPstCurTypeId() {
		return pstCurTypeId;
	}
	public void setPstCurTypeId(int pstCurTypeId) {
		this.pstCurTypeId = pstCurTypeId;
	}
	public BigDecimal getPstTotAmt() {
		return pstTotAmt;
	}
	public void setPstTotAmt(BigDecimal pstTotAmt) {
		this.pstTotAmt = pstTotAmt;
	}
	public String getPstRem() {
		return pstRem;
	}
	public void setPstRem(String pstRem) {
		this.pstRem = pstRem;
	}
	public int getPstStusId() {
		return pstStusId;
	}
	public void setPstStusId(int pstStusId) {
		this.pstStusId = pstStusId;
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
	public int getPic() {
		return pic;
	}
	public void setPic(int pic) {
		this.pic = pic;
	}
	public String getPstCustPo() {
		return pstCustPo;
	}
	public void setPstCustPo(String pstCustPo) {
		this.pstCustPo = pstCustPo;
	}
}
