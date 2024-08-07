package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0074D database table.
 *
 */
public class RentPaySetVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long rentPayId;

	private int aeonCnvr;

	private int bankId;

	private int custAccId;

	private int custCrcId;

	private int custId;

	private String ddApplyDt;

	private String ddRejctDt;

	private String ddStartDt;

	private String ddSubmitDt;

	private int editTypeId;

	private int failResnId;

	private int is3rdParty;

	private String issuNric;

	private int lastApplyUser;

	private int modeId;

	private String nricOld;

	private int payTrm;

	private String rem;

	private int salesOrdId;

	private int stusCodeId;

	private int svcCntrctId;

	private Date updDt;

	private int updUserId;

	private String pnpRpsCrcNo;

	public RentPaySetVO() {
	}

	public long getRentPayId() {
		return rentPayId;
	}

	public void setRentPayId(long rentPayId) {
		this.rentPayId = rentPayId;
	}

	public int getAeonCnvr() {
		return aeonCnvr;
	}

	public void setAeonCnvr(int aeonCnvr) {
		this.aeonCnvr = aeonCnvr;
	}

	public int getBankId() {
		return bankId;
	}

	public void setBankId(int bankId) {
		this.bankId = bankId;
	}

	public int getCustAccId() {
		return custAccId;
	}

	public void setCustAccId(int custAccId) {
		this.custAccId = custAccId;
	}

	public int getCustCrcId() {
		return custCrcId;
	}

	public void setCustCrcId(int custCrcId) {
		this.custCrcId = custCrcId;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getDdApplyDt() {
		return ddApplyDt;
	}

	public void setDdApplyDt(String ddApplyDt) {
		this.ddApplyDt = ddApplyDt;
	}

	public String getDdRejctDt() {
		return ddRejctDt;
	}

	public void setDdRejctDt(String ddRejctDt) {
		this.ddRejctDt = ddRejctDt;
	}

	public String getDdStartDt() {
		return ddStartDt;
	}

	public void setDdStartDt(String ddStartDt) {
		this.ddStartDt = ddStartDt;
	}

	public String getDdSubmitDt() {
		return ddSubmitDt;
	}

	public void setDdSubmitDt(String ddSubmitDt) {
		this.ddSubmitDt = ddSubmitDt;
	}

	public int getEditTypeId() {
		return editTypeId;
	}

	public void setEditTypeId(int editTypeId) {
		this.editTypeId = editTypeId;
	}

	public int getFailResnId() {
		return failResnId;
	}

	public void setFailResnId(int failResnId) {
		this.failResnId = failResnId;
	}

	public int getIs3rdParty() {
		return is3rdParty;
	}

	public void setIs3rdParty(int is3rdParty) {
		this.is3rdParty = is3rdParty;
	}

	public String getIssuNric() {
		return issuNric;
	}

	public void setIssuNric(String issuNric) {
		this.issuNric = issuNric;
	}

	public int getLastApplyUser() {
		return lastApplyUser;
	}

	public void setLastApplyUser(int lastApplyUser) {
		this.lastApplyUser = lastApplyUser;
	}

	public int getModeId() {
		return modeId;
	}

	public void setModeId(int modeId) {
		this.modeId = modeId;
	}

	public String getNricOld() {
		return nricOld;
	}

	public void setNricOld(String nricOld) {
		this.nricOld = nricOld;
	}

	public int getPayTrm() {
		return payTrm;
	}

	public void setPayTrm(int payTrm) {
		this.payTrm = payTrm;
	}

	public String getRem() {
		return rem;
	}

	public void setRem(String rem) {
		this.rem = rem;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public int getSvcCntrctId() {
		return svcCntrctId;
	}

	public void setSvcCntrctId(int svcCntrctId) {
		this.svcCntrctId = svcCntrctId;
	}

	public Date getUpdDt() {
		return updDt;
	}

	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}

	public int getUpdUserId() {
		return updUserId;
	}

	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}

  public String getPnpRpsCrcNo() {
    return pnpRpsCrcNo;
  }

  public void setPnpRpsCrcNo(String pnpRpsCrcNo) {
    this.pnpRpsCrcNo = pnpRpsCrcNo;
  }

}