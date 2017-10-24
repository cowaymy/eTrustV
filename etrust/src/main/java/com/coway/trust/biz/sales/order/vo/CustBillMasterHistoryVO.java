package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0025D database table.
 * 
 */
public class CustBillMasterHistoryVO implements Serializable {
	private static final long serialVersionUID = 1L;
    
	private int addrIdNw;
	
	private int addrIdOld;
	
	private int cntcIdNw;
	
	private int cntcIdOld;
	
	private int custBillId;
	
	private String emailAddNw;
	
	private String emailAddOld;
	
	private String emailNw;
	
	private String emailOld;
	
	private Date histCrtDt;
	
	private int histCrtUserId;
	
	private int histId;
	
	private int isEStateNw;
	
	private int isEStateOld;
	
	private int isPostNw;
	
	private int isPostOld;
	
	private int isSmsNw;
	
	private int isSmsOld;
	
	private String remNw;
	
	private String remOld;
	
	private int salesOrdIdNw;
	
	private int salesOrdIdOld;
	
	private int stusIdNw;
	
	private int stusIdOld;
	
	private String sysHistRem;
	
	private int typeId;
	
	private String userHistRem;

	public int getAddrIdNw() {
		return addrIdNw;
	}

	public void setAddrIdNw(int addrIdNw) {
		this.addrIdNw = addrIdNw;
	}

	public int getAddrIdOld() {
		return addrIdOld;
	}

	public void setAddrIdOld(int addrIdOld) {
		this.addrIdOld = addrIdOld;
	}

	public int getCntcIdNw() {
		return cntcIdNw;
	}

	public void setCntcIdNw(int cntcIdNw) {
		this.cntcIdNw = cntcIdNw;
	}

	public int getCntcIdOld() {
		return cntcIdOld;
	}

	public void setCntcIdOld(int cntcIdOld) {
		this.cntcIdOld = cntcIdOld;
	}

	public int getCustBillId() {
		return custBillId;
	}

	public void setCustBillId(int custBillId) {
		this.custBillId = custBillId;
	}

	public String getEmailAddNw() {
		return emailAddNw;
	}

	public void setEmailAddNw(String emailAddNw) {
		this.emailAddNw = emailAddNw;
	}

	public String getEmailAddOld() {
		return emailAddOld;
	}

	public void setEmailAddOld(String emailAddOld) {
		this.emailAddOld = emailAddOld;
	}

	public String getEmailNw() {
		return emailNw;
	}

	public void setEmailNw(String emailNw) {
		this.emailNw = emailNw;
	}

	public String getEmailOld() {
		return emailOld;
	}

	public void setEmailOld(String emailOld) {
		this.emailOld = emailOld;
	}

	public Date getHistCrtDt() {
		return histCrtDt;
	}

	public void setHistCrtDt(Date histCrtDt) {
		this.histCrtDt = histCrtDt;
	}

	public int getHistCrtUserId() {
		return histCrtUserId;
	}

	public void setHistCrtUserId(int histCrtUserId) {
		this.histCrtUserId = histCrtUserId;
	}

	public int getHistId() {
		return histId;
	}

	public void setHistId(int histId) {
		this.histId = histId;
	}

	public int getIsEStateNw() {
		return isEStateNw;
	}

	public void setIsEStateNw(int isEStateNw) {
		this.isEStateNw = isEStateNw;
	}

	public int getIsEStateOld() {
		return isEStateOld;
	}

	public void setIsEStateOld(int isEStateOld) {
		this.isEStateOld = isEStateOld;
	}

	public int getIsPostNw() {
		return isPostNw;
	}

	public void setIsPostNw(int isPostNw) {
		this.isPostNw = isPostNw;
	}

	public int getIsPostOld() {
		return isPostOld;
	}

	public void setIsPostOld(int isPostOld) {
		this.isPostOld = isPostOld;
	}

	public int getIsSmsNw() {
		return isSmsNw;
	}

	public void setIsSmsNw(int isSmsNw) {
		this.isSmsNw = isSmsNw;
	}

	public int getIsSmsOld() {
		return isSmsOld;
	}

	public void setIsSmsOld(int isSmsOld) {
		this.isSmsOld = isSmsOld;
	}

	public String getRemNw() {
		return remNw;
	}

	public void setRemNw(String remNw) {
		this.remNw = remNw;
	}

	public String getRemOld() {
		return remOld;
	}

	public void setRemOld(String remOld) {
		this.remOld = remOld;
	}

	public int getSalesOrdIdNw() {
		return salesOrdIdNw;
	}

	public void setSalesOrdIdNw(int salesOrdIdNw) {
		this.salesOrdIdNw = salesOrdIdNw;
	}

	public int getSalesOrdIdOld() {
		return salesOrdIdOld;
	}

	public void setSalesOrdIdOld(int salesOrdIdOld) {
		this.salesOrdIdOld = salesOrdIdOld;
	}

	public int getStusIdNw() {
		return stusIdNw;
	}

	public void setStusIdNw(int stusIdNw) {
		this.stusIdNw = stusIdNw;
	}

	public int getStusIdOld() {
		return stusIdOld;
	}

	public void setStusIdOld(int stusIdOld) {
		this.stusIdOld = stusIdOld;
	}

	public String getSysHistRem() {
		return sysHistRem;
	}

	public void setSysHistRem(String sysHistRem) {
		this.sysHistRem = sysHistRem;
	}

	public int getTypeId() {
		return typeId;
	}

	public void setTypeId(int typeId) {
		this.typeId = typeId;
	}

	public String getUserHistRem() {
		return userHistRem;
	}

	public void setUserHistRem(String userHistRem) {
		this.userHistRem = userHistRem;
	}

}