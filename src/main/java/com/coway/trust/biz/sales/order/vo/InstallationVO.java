package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0045D database table.
 *
 */
public class InstallationVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int installId;

	private String actDt;

	private String actTm;

	private int addId;

	private int brnchId;

	private int cntId;

	private int editTypeId;

	private String instct;

	private int isTradeIn;

	private String preCallDt;

	private String preDt;

	private String preTm;

	private int salesOrdId;

	private int stusCodeId;

	private Date updDt;

	private int updUserId;

	private String vrifyRem;

	private String serviceType;

	public int getInstallId() {
		return installId;
	}

	public void setInstallId(int installId) {
		this.installId = installId;
	}

	public String getActDt() {
		return actDt;
	}

	public void setActDt(String actDt) {
		this.actDt = actDt;
	}

	public String getActTm() {
		return actTm;
	}

	public void setActTm(String actTm) {
		this.actTm = actTm;
	}

	public int getAddId() {
		return addId;
	}

	public void setAddId(int addId) {
		this.addId = addId;
	}

	public int getBrnchId() {
		return brnchId;
	}

	public void setBrnchId(int brnchId) {
		this.brnchId = brnchId;
	}

	public int getCntId() {
		return cntId;
	}

	public void setCntId(int cntId) {
		this.cntId = cntId;
	}

	public int getEditTypeId() {
		return editTypeId;
	}

	public void setEditTypeId(int editTypeId) {
		this.editTypeId = editTypeId;
	}

	public String getInstct() {
		return instct;
	}

	public void setInstct(String instct) {
		this.instct = instct;
	}

	public int getIsTradeIn() {
		return isTradeIn;
	}

	public void setIsTradeIn(int isTradeIn) {
		this.isTradeIn = isTradeIn;
	}

	public String getPreCallDt() {
		return preCallDt;
	}

	public void setPreCallDt(String preCallDt) {
		this.preCallDt = preCallDt;
	}

	public String getPreDt() {
		return preDt;
	}

	public void setPreDt(String preDt) {
		this.preDt = preDt;
	}

	public String getPreTm() {
		return preTm;
	}

	public void setPreTm(String preTm) {
		this.preTm = preTm;
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

	public String getVrifyRem() {
		return vrifyRem;
	}

	public void setVrifyRem(String vrifyRem) {
		this.vrifyRem = vrifyRem;
	}

  public String getServiceType() {
    return serviceType;
  }

  public void setServiceType(String serviceType) {
    this.serviceType = serviceType;
  }

}