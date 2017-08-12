package com.coway.trust.biz.sales.order;

import java.io.Serializable;
import java.util.Date;

public class OrderInvestVO implements Serializable {

	private static final long serialVersionUID = -5536533660309427760L;
	
	private String invReqNo;
	private String salesOrdNo;
	private String invReqCrtUserName;
	private int invReqStusId;
	private String invReqStusName;
	private int invReqPartyId;
	private String invReqPartyName;
	private Date invReqCrtDt;
	
	public String getInvReqNo() {
		return invReqNo;
	}
	public void setInvReqNo(String invReqNo) {
		this.invReqNo = invReqNo;
	}
	public String getSalesOrdNo() {
		return salesOrdNo;
	}
	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}
	public String getInvReqCrtUserName() {
		return invReqCrtUserName;
	}
	public void setInvReqCrtUserName(String invReqCrtUserName) {
		this.invReqCrtUserName = invReqCrtUserName;
	}
	public int getInvReqStusId() {
		return invReqStusId;
	}
	public void setInvReqStusId(int invReqStusId) {
		this.invReqStusId = invReqStusId;
	}
	public String getInvReqStusName() {
		return invReqStusName;
	}
	public void setInvReqStusName(String invReqStusName) {
		this.invReqStusName = invReqStusName;
	}
	public int getInvReqPartyId() {
		return invReqPartyId;
	}
	public void setInvReqPartyId(int invReqPartyId) {
		this.invReqPartyId = invReqPartyId;
	}
	public String getInvReqPartyName() {
		return invReqPartyName;
	}
	public void setInvReqPartyName(String invReqPartyName) {
		this.invReqPartyName = invReqPartyName;
	}
	public Date getInvReqCrtDt() {
		return invReqCrtDt;
	}
	public void setInvReqCrtDt(Date invReqCrtDt) {
		this.invReqCrtDt = invReqCrtDt;
	}
	
	

}
