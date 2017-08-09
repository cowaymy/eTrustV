package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the ORG0010D database table.
 * 
 */
public class DocSubmissionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long docSubId;

	private Date crtDt;

	private BigDecimal crtUserId;

	private BigDecimal docCopyQty;

	private BigDecimal docMemId;

	private BigDecimal docSoId;

	private BigDecimal docSubBatchId;

	private String docSubDt;

	private BigDecimal docSubTypeId;

	private BigDecimal docTypeId;

	private BigDecimal stusId;

	private Date updDt;

	private BigDecimal updUserId;

	public DocSubmissionVO() {
	}

	public long getDocSubId() {
		return this.docSubId;
	}

	public void setDocSubId(long docSubId) {
		this.docSubId = docSubId;
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

	public BigDecimal getDocCopyQty() {
		return this.docCopyQty;
	}

	public void setDocCopyQty(BigDecimal docCopyQty) {
		this.docCopyQty = docCopyQty;
	}

	public BigDecimal getDocMemId() {
		return this.docMemId;
	}

	public void setDocMemId(BigDecimal docMemId) {
		this.docMemId = docMemId;
	}

	public BigDecimal getDocSoId() {
		return this.docSoId;
	}

	public void setDocSoId(BigDecimal docSoId) {
		this.docSoId = docSoId;
	}

	public BigDecimal getDocSubBatchId() {
		return this.docSubBatchId;
	}

	public void setDocSubBatchId(BigDecimal docSubBatchId) {
		this.docSubBatchId = docSubBatchId;
	}

	public String getDocSubDt() {
		return this.docSubDt;
	}

	public void setDocSubDt(String docSubDt) {
		this.docSubDt = docSubDt;
	}

	public BigDecimal getDocSubTypeId() {
		return this.docSubTypeId;
	}

	public void setDocSubTypeId(BigDecimal docSubTypeId) {
		this.docSubTypeId = docSubTypeId;
	}

	public BigDecimal getDocTypeId() {
		return this.docTypeId;
	}

	public void setDocTypeId(BigDecimal docTypeId) {
		this.docTypeId = docTypeId;
	}

	public BigDecimal getStusId() {
		return this.stusId;
	}

	public void setStusId(BigDecimal stusId) {
		this.stusId = stusId;
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