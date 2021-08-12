/**
 * 
 */
package com.coway.trust.biz.sales.pst;

import java.io.Serializable;
import java.sql.Clob;
import java.util.Date;

/**
 * @author Yunseok_Jang
 *
 */
public class PSTRequestDOVO implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5608032363988701275L;
	
	/** 아이디 */
	private String id;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	/** PSTRequestDOList 항목 */
	private String pstRefNo;			// PSO Number
	private String dealerName;		// Dealer Name
	private String pstCustPo;			// PO Number (Customer PO)
	private Date crtDt;					// Create Date
	private String code1;				// PSO Status

	/** PSTRequestDOList 조회조건 */
	private String dealerNric;			// NRIC / Company No
	private Date createStDate;
	private Date createEnDate;
	
	/** PSTRequestDODetailPop */
	/** PST Info*/
	private int pstSalesOrdId;
	private String code;					// Currency Type
	private int pstCurRate;			// Currency Rate
	private String userName;			// Person In Charge
	private String userName1;			// Create By
	private Clob pstRem;				// Remark
	
	/** PST StockList*/
	private String c2;					// Stock Description
	private int pstItmReqQty;			// Request Quantity
	private int pstItmDoQty;			// Do Quantity
	private int pstItmCanQty;			// Cancel Quantity
	private int pstItmBalQty;			// Balance Quantity
	private int pstItmPrc;				// Item Price
	
	
	
	
	public String getPstRefNo() {
		return pstRefNo;
	}

	public void setPstRefNo(String pstRefNo) {
		this.pstRefNo = pstRefNo;
	}

	public String getDealerName() {
		return dealerName;
	}

	public void setDealerName(String dealerName) {
		this.dealerName = dealerName;
	}

	public String getPstCustPo() {
		return pstCustPo;
	}

	public void setPstCustPo(String pstCustPo) {
		this.pstCustPo = pstCustPo;
	}

	public Date getCrtDt() {
		return crtDt;
	}

	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}

	public String getCode1() {
		return code1;
	}

	public void setCode1(String code1) {
		this.code1 = code1;
	}

	public int getPstSalesOrdId() {
		return pstSalesOrdId;
	}

	public void setPstSalesOrdId(int pstSalesOrdId) {
		this.pstSalesOrdId = pstSalesOrdId;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public int getPstCurRate() {
		return pstCurRate;
	}

	public void setPstCurRate(int pstCurRate) {
		this.pstCurRate = pstCurRate;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserName1() {
		return userName1;
	}

	public void setUserName1(String userName1) {
		this.userName1 = userName1;
	}

	public Clob getPstRem() {
		return pstRem;
	}

	public void setPstRem(Clob pstRem) {
		this.pstRem = pstRem;
	}

	public String getC2() {
		return c2;
	}

	public void setC2(String c2) {
		this.c2 = c2;
	}

	public int getPstItmReqQty() {
		return pstItmReqQty;
	}

	public void setPstItmReqQty(int pstItmReqQty) {
		this.pstItmReqQty = pstItmReqQty;
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

	public int getPstItmBalQty() {
		return pstItmBalQty;
	}

	public void setPstItmBalQty(int pstItmBalQty) {
		this.pstItmBalQty = pstItmBalQty;
	}

	public int getPstItmPrc() {
		return pstItmPrc;
	}

	public void setPstItmPrc(int pstItmPrc) {
		this.pstItmPrc = pstItmPrc;
	}

	public String getDealerNric() {
		return dealerNric;
	}

	public void setDealerNric(String dealerNric) {
		this.dealerNric = dealerNric;
	}

	public Date getCreateStDate() {
		return createStDate;
	}

	public void setCreateStDate(Date createStDate) {
		this.createStDate = createStDate;
	}

	public Date getCreateEnDate() {
		return createEnDate;
	}

	public void setCreateEnDate(Date createEnDate) {
		this.createEnDate = createEnDate;
	}

	

}
