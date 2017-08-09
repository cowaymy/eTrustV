package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0047D database table.
 * 
 */
public class InstallResultVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long resultId;

	private BigDecimal adjAmt;

	private BigDecimal allowComm;

	private Date crtDt;

	private BigDecimal crtUserId;

	private BigDecimal ctId;

	private String docRefNo1;

	private String docRefNo2;

	private BigDecimal entryId;

	private BigDecimal failId;

	private BigDecimal glPost;

	private Date installDt;

	private BigDecimal isTradeIn;

	private String mobileId;

	private Date nextCallDt;

	private String rem;

	private BigDecimal requireSms;

	private String serialNo;

	private String sirimNo;

	private BigDecimal stusCodeId;

	private Date updDt;

	private BigDecimal updUserId;

	public InstallResultVO() {
	}

	public long getResultId() {
		return this.resultId;
	}

	public void setResultId(long resultId) {
		this.resultId = resultId;
	}

	public BigDecimal getAdjAmt() {
		return this.adjAmt;
	}

	public void setAdjAmt(BigDecimal adjAmt) {
		this.adjAmt = adjAmt;
	}

	public BigDecimal getAllowComm() {
		return this.allowComm;
	}

	public void setAllowComm(BigDecimal allowComm) {
		this.allowComm = allowComm;
	}

	public Date getCrtDt() {
		return this.crtDt;
	}

	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}

	public BigDecimal getCrtUserId() {
		return this.crtUserId;
	}

	public void setCrtUserId(BigDecimal crtUserId) {
		this.crtUserId = crtUserId;
	}

	public BigDecimal getCtId() {
		return this.ctId;
	}

	public void setCtId(BigDecimal ctId) {
		this.ctId = ctId;
	}

	public String getDocRefNo1() {
		return this.docRefNo1;
	}

	public void setDocRefNo1(String docRefNo1) {
		this.docRefNo1 = docRefNo1;
	}

	public String getDocRefNo2() {
		return this.docRefNo2;
	}

	public void setDocRefNo2(String docRefNo2) {
		this.docRefNo2 = docRefNo2;
	}

	public BigDecimal getEntryId() {
		return this.entryId;
	}

	public void setEntryId(BigDecimal entryId) {
		this.entryId = entryId;
	}

	public BigDecimal getFailId() {
		return this.failId;
	}

	public void setFailId(BigDecimal failId) {
		this.failId = failId;
	}

	public BigDecimal getGlPost() {
		return this.glPost;
	}

	public void setGlPost(BigDecimal glPost) {
		this.glPost = glPost;
	}

	public Date getInstallDt() {
		return this.installDt;
	}

	public void setInstallDt(Date installDt) {
		this.installDt = installDt;
	}

	public BigDecimal getIsTradeIn() {
		return this.isTradeIn;
	}

	public void setIsTradeIn(BigDecimal isTradeIn) {
		this.isTradeIn = isTradeIn;
	}

	public String getMobileId() {
		return this.mobileId;
	}

	public void setMobileId(String mobileId) {
		this.mobileId = mobileId;
	}

	public Date getNextCallDt() {
		return this.nextCallDt;
	}

	public void setNextCallDt(Date nextCallDt) {
		this.nextCallDt = nextCallDt;
	}

	public String getRem() {
		return this.rem;
	}

	public void setRem(String rem) {
		this.rem = rem;
	}

	public BigDecimal getRequireSms() {
		return this.requireSms;
	}

	public void setRequireSms(BigDecimal requireSms) {
		this.requireSms = requireSms;
	}

	public String getSerialNo() {
		return this.serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getSirimNo() {
		return this.sirimNo;
	}

	public void setSirimNo(String sirimNo) {
		this.sirimNo = sirimNo;
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

}