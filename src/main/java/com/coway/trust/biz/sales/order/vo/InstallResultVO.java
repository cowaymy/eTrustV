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

	private int resultId;

	private BigDecimal adjAmt;

	private int allowComm;

	private Date crtDt;

	private int crtUserId;

	private int ctId;

	private String docRefNo1;

	private String docRefNo2;

	private int entryId;

	private int failId;

	private int glPost;

	private String installDt;

	private int isTradeIn;

	private String mobileId;

	private Date nextCallDt;

	private String rem;

	private int requireSms;

	private String serialNo;

	private String sirimNo;

	private int stusCodeId;

	private Date updDt;

	private int updUserId;

	public InstallResultVO() {
	}

	public int getResultId() {
		return resultId;
	}

	public void setResultId(int resultId) {
		this.resultId = resultId;
	}

	public BigDecimal getAdjAmt() {
		return adjAmt;
	}

	public void setAdjAmt(BigDecimal adjAmt) {
		this.adjAmt = adjAmt;
	}

	public int getAllowComm() {
		return allowComm;
	}

	public void setAllowComm(int allowComm) {
		this.allowComm = allowComm;
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

	public int getCtId() {
		return ctId;
	}

	public void setCtId(int ctId) {
		this.ctId = ctId;
	}

	public String getDocRefNo1() {
		return docRefNo1;
	}

	public void setDocRefNo1(String docRefNo1) {
		this.docRefNo1 = docRefNo1;
	}

	public String getDocRefNo2() {
		return docRefNo2;
	}

	public void setDocRefNo2(String docRefNo2) {
		this.docRefNo2 = docRefNo2;
	}

	public int getEntryId() {
		return entryId;
	}

	public void setEntryId(int entryId) {
		this.entryId = entryId;
	}

	public int getFailId() {
		return failId;
	}

	public void setFailId(int failId) {
		this.failId = failId;
	}

	public int getGlPost() {
		return glPost;
	}

	public void setGlPost(int glPost) {
		this.glPost = glPost;
	}

	public String getInstallDt() {
		return installDt;
	}

	public void setInstallDt(String installDt) {
		this.installDt = installDt;
	}

	public int getIsTradeIn() {
		return isTradeIn;
	}

	public void setIsTradeIn(int isTradeIn) {
		this.isTradeIn = isTradeIn;
	}

	public String getMobileId() {
		return mobileId;
	}

	public void setMobileId(String mobileId) {
		this.mobileId = mobileId;
	}

	public Date getNextCallDt() {
		return nextCallDt;
	}

	public void setNextCallDt(Date nextCallDt) {
		this.nextCallDt = nextCallDt;
	}

	public String getRem() {
		return rem;
	}

	public void setRem(String rem) {
		this.rem = rem;
	}

	public int getRequireSms() {
		return requireSms;
	}

	public void setRequireSms(int requireSms) {
		this.requireSms = requireSms;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getSirimNo() {
		return sirimNo;
	}

	public void setSirimNo(String sirimNo) {
		this.sirimNo = sirimNo;
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

}