/**
 * 
 */
package com.coway.trust.biz.sales.order;

import java.io.Serializable;
import java.sql.Date;

/**
 * @author Yunseok_Jang
 *
 */
public class OrderReferralVO implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -7856087835380262632L;
	
	private int salesOrdId;
	private int ordRefId;
	private String salesOrdNo;
	private Date crtDt;
	private int stusCode;
	private String refStateId;
	private int userId;
	private String userName;
	private String refName;
	private String refStateName;
	private String refCntc;
	private String refRem;
	
	public int getSalesOrdId() {
		return salesOrdId;
	}
	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}
	public int getOrdRefId() {
		return ordRefId;
	}
	public void setOrdRefId(int ordRefId) {
		this.ordRefId = ordRefId;
	}
	public String getSalesOrdNo() {
		return salesOrdNo;
	}
	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}
	public Date getCrtDt() {
		return crtDt;
	}
	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}
	public int getStusCode() {
		return stusCode;
	}
	public void setStusCode(int stusCode) {
		this.stusCode = stusCode;
	}
	public String getRefStateId() {
		return refStateId;
	}
	public void setRefStateId(String refStateId) {
		this.refStateId = refStateId;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getRefName() {
		return refName;
	}
	public void setRefName(String refName) {
		this.refName = refName;
	}
	public String getRefStateName() {
		return refStateName;
	}
	public void setRefStateName(String refStateName) {
		this.refStateName = refStateName;
	}
	public String getRefCntc() {
		return refCntc;
	}
	public void setRefCntc(String refCntc) {
		this.refCntc = refCntc;
	}
	public String getRefRem() {
		return refRem;
	}
	public void setRefRem(String refRem) {
		this.refRem = refRem;
	}
		
}
