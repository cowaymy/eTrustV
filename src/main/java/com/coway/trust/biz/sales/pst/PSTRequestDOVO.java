/**
 * 
 */
package com.coway.trust.biz.sales.pst;

import java.io.Serializable;
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
	private String pstCustPo;			// PO Number
	private Date crtDt;					// Create Date
	private String code1;				// PSO Status

	/** PSTRequestDOList 조회조건 */
	
	
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
	

}
