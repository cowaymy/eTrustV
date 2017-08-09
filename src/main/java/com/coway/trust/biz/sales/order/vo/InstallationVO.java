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

	private long installId;

	private String actDt;

	private String actTm;

	private BigDecimal addId;

	private BigDecimal brnchId;

	private BigDecimal cntId;

	private BigDecimal editTypeId;

	private String instct;

	private BigDecimal isTradeIn;

	private String preCallDt;

	private String preDt;

	private String preTm;

	private BigDecimal salesOrdId;

	private BigDecimal stusCodeId;

	private Date updDt;

	private BigDecimal updUserId;

	private String vrifyRem;

	public InstallationVO() {
	}

	public long getInstallId() {
		return this.installId;
	}

	public void setInstallId(long installId) {
		this.installId = installId;
	}

	public String getActDt() {
		return this.actDt;
	}

	public void setActDt(String actDt) {
		this.actDt = actDt;
	}

	public String getActTm() {
		return this.actTm;
	}

	public void setActTm(String actTm) {
		this.actTm = actTm;
	}

	public BigDecimal getAddId() {
		return this.addId;
	}

	public void setAddId(BigDecimal addId) {
		this.addId = addId;
	}

	public BigDecimal getBrnchId() {
		return this.brnchId;
	}

	public void setBrnchId(BigDecimal brnchId) {
		this.brnchId = brnchId;
	}

	public BigDecimal getCntId() {
		return this.cntId;
	}

	public void setCntId(BigDecimal cntId) {
		this.cntId = cntId;
	}

	public BigDecimal getEditTypeId() {
		return this.editTypeId;
	}

	public void setEditTypeId(BigDecimal editTypeId) {
		this.editTypeId = editTypeId;
	}

	public String getInstct() {
		return this.instct;
	}

	public void setInstct(String instct) {
		this.instct = instct;
	}

	public BigDecimal getIsTradeIn() {
		return this.isTradeIn;
	}

	public void setIsTradeIn(BigDecimal isTradeIn) {
		this.isTradeIn = isTradeIn;
	}

	public String getPreCallDt() {
		return this.preCallDt;
	}

	public void setPreCallDt(String preCallDt) {
		this.preCallDt = preCallDt;
	}

	public String getPreDt() {
		return this.preDt;
	}

	public void setPreDt(String preDt) {
		this.preDt = preDt;
	}

	public String getPreTm() {
		return this.preTm;
	}

	public void setPreTm(String preTm) {
		this.preTm = preTm;
	}

	public BigDecimal getSalesOrdId() {
		return this.salesOrdId;
	}

	public void setSalesOrdId(BigDecimal salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public BigDecimal getStusCodeId() {
		return this.stusCodeId;
	}

	public void setStusCodeId(BigDecimal stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public Date getUpdDt() {
		return this.updDt;
	}

	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}

	public BigDecimal getUpdUserId() {
		return this.updUserId;
	}

	public void setUpdUserId(BigDecimal updUserId) {
		this.updUserId = updUserId;
	}

	public String getVrifyRem() {
		return this.vrifyRem;
	}

	public void setVrifyRem(String vrifyRem) {
		this.vrifyRem = vrifyRem;
	}

}