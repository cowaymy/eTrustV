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

	private int docSubId;

	private Date crtDt;

	private int crtUserId;

	private int docCopyQty;

	private int docMemId;

	private int docSoId;

	private int docSubBatchId;

	private String docSubDt;

	private int docSubTypeId;

	private int docTypeId;

	private int stusId;

	private Date updDt;

	private int updUserId;

	private int codeId;

	private String typeDesc;

	private int chkfield;

	private int docSubBrnchId;

	public DocSubmissionVO() {
	}

	public int getDocSubId() {
		return docSubId;
	}

	public void setDocSubId(int docSubId) {
		this.docSubId = docSubId;
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

	public int getDocCopyQty() {
		return docCopyQty;
	}

	public void setDocCopyQty(int docCopyQty) {
		this.docCopyQty = docCopyQty;
	}

	public int getDocMemId() {
		return docMemId;
	}

	public void setDocMemId(int docMemId) {
		this.docMemId = docMemId;
	}

	public int getDocSoId() {
		return docSoId;
	}

	public void setDocSoId(int docSoId) {
		this.docSoId = docSoId;
	}

	public int getDocSubBatchId() {
		return docSubBatchId;
	}

	public void setDocSubBatchId(int docSubBatchId) {
		this.docSubBatchId = docSubBatchId;
	}

	public String getDocSubDt() {
		return docSubDt;
	}

	public void setDocSubDt(String docSubDt) {
		this.docSubDt = docSubDt;
	}

	public int getDocSubTypeId() {
		return docSubTypeId;
	}

	public void setDocSubTypeId(int docSubTypeId) {
		this.docSubTypeId = docSubTypeId;
	}

	public int getDocTypeId() {
		return docTypeId;
	}

	public void setDocTypeId(int docTypeId) {
		this.docTypeId = docTypeId;
	}

	public int getStusId() {
		return stusId;
	}

	public void setStusId(int stusId) {
		this.stusId = stusId;
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

	public int getCodeId() {
		return codeId;
	}

	public void setCodeId(int codeId) {
		this.codeId = codeId;
	}

	public String getTypeDesc() {
		return typeDesc;
	}

	public void setTypeDesc(String typeDesc) {
		this.typeDesc = typeDesc;
	}

	public int getChkfield() {
		return chkfield;
	}

	public void setChkfield(int chkfield) {
		this.chkfield = chkfield;
	}

	public int getDocSubBrnchId() {
		return docSubBrnchId;
	}

	public void setDocSubBrnchId(int docSubBrnchId) {
		this.docSubBrnchId = docSubBrnchId;
	}

}