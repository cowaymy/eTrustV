package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0024D database table.
 * 
 */
public class CustBillMasterVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long custBillId;

	private BigDecimal custBillAddId;

	private BigDecimal custBillCntId;

	private Date custBillCrtDt;

	private BigDecimal custBillCrtUserId;

	private BigDecimal custBillCustCareCntId;

	private BigDecimal custBillCustId;

	private String custBillEmail;

	private String custBillEmailAdd;

	private String custBillGrpNo;

	private BigDecimal custBillInchgMemId;

	private BigDecimal custBillIsEstm;

	private BigDecimal custBillIsPost;

	private BigDecimal custBillIsSms;

	private BigDecimal custBillIsSms2;

	private BigDecimal custBillIsWebPortal;

	private String custBillPayRefNo1;

	private String custBillPayRefNo2;

	private BigDecimal custBillPayTrm;

	private String custBillRem;

	private BigDecimal custBillSoId;

	private BigDecimal custBillStusId;

	private Date custBillUpdDt;

	private BigDecimal custBillUpdUserId;

	private String custBillWebPortalUrl;

	public CustBillMasterVO() {
	}

	public long getCustBillId() {
		return this.custBillId;
	}

	public void setCustBillId(long custBillId) {
		this.custBillId = custBillId;
	}

	public BigDecimal getCustBillAddId() {
		return this.custBillAddId;
	}

	public void setCustBillAddId(BigDecimal custBillAddId) {
		this.custBillAddId = custBillAddId;
	}

	public BigDecimal getCustBillCntId() {
		return this.custBillCntId;
	}

	public void setCustBillCntId(BigDecimal custBillCntId) {
		this.custBillCntId = custBillCntId;
	}

	public Date getCustBillCrtDt() {
		return this.custBillCrtDt;
	}

	public void setCustBillCrtDt(Date custBillCrtDt) {
		this.custBillCrtDt = custBillCrtDt;
	}

	public BigDecimal getCustBillCrtUserId() {
		return this.custBillCrtUserId;
	}

	public void setCustBillCrtUserId(BigDecimal custBillCrtUserId) {
		this.custBillCrtUserId = custBillCrtUserId;
	}

	public BigDecimal getCustBillCustCareCntId() {
		return this.custBillCustCareCntId;
	}

	public void setCustBillCustCareCntId(BigDecimal custBillCustCareCntId) {
		this.custBillCustCareCntId = custBillCustCareCntId;
	}

	public BigDecimal getCustBillCustId() {
		return this.custBillCustId;
	}

	public void setCustBillCustId(BigDecimal custBillCustId) {
		this.custBillCustId = custBillCustId;
	}

	public String getCustBillEmail() {
		return this.custBillEmail;
	}

	public void setCustBillEmail(String custBillEmail) {
		this.custBillEmail = custBillEmail;
	}

	public String getCustBillEmailAdd() {
		return this.custBillEmailAdd;
	}

	public void setCustBillEmailAdd(String custBillEmailAdd) {
		this.custBillEmailAdd = custBillEmailAdd;
	}

	public String getCustBillGrpNo() {
		return this.custBillGrpNo;
	}

	public void setCustBillGrpNo(String custBillGrpNo) {
		this.custBillGrpNo = custBillGrpNo;
	}

	public BigDecimal getCustBillInchgMemId() {
		return this.custBillInchgMemId;
	}

	public void setCustBillInchgMemId(BigDecimal custBillInchgMemId) {
		this.custBillInchgMemId = custBillInchgMemId;
	}

	public BigDecimal getCustBillIsEstm() {
		return this.custBillIsEstm;
	}

	public void setCustBillIsEstm(BigDecimal custBillIsEstm) {
		this.custBillIsEstm = custBillIsEstm;
	}

	public BigDecimal getCustBillIsPost() {
		return this.custBillIsPost;
	}

	public void setCustBillIsPost(BigDecimal custBillIsPost) {
		this.custBillIsPost = custBillIsPost;
	}

	public BigDecimal getCustBillIsSms() {
		return this.custBillIsSms;
	}

	public void setCustBillIsSms(BigDecimal custBillIsSms) {
		this.custBillIsSms = custBillIsSms;
	}

	public BigDecimal getCustBillIsSms2() {
		return this.custBillIsSms2;
	}

	public void setCustBillIsSms2(BigDecimal custBillIsSms2) {
		this.custBillIsSms2 = custBillIsSms2;
	}

	public BigDecimal getCustBillIsWebPortal() {
		return this.custBillIsWebPortal;
	}

	public void setCustBillIsWebPortal(BigDecimal custBillIsWebPortal) {
		this.custBillIsWebPortal = custBillIsWebPortal;
	}

	public String getCustBillPayRefNo1() {
		return this.custBillPayRefNo1;
	}

	public void setCustBillPayRefNo1(String custBillPayRefNo1) {
		this.custBillPayRefNo1 = custBillPayRefNo1;
	}

	public String getCustBillPayRefNo2() {
		return this.custBillPayRefNo2;
	}

	public void setCustBillPayRefNo2(String custBillPayRefNo2) {
		this.custBillPayRefNo2 = custBillPayRefNo2;
	}

	public BigDecimal getCustBillPayTrm() {
		return this.custBillPayTrm;
	}

	public void setCustBillPayTrm(BigDecimal custBillPayTrm) {
		this.custBillPayTrm = custBillPayTrm;
	}

	public String getCustBillRem() {
		return this.custBillRem;
	}

	public void setCustBillRem(String custBillRem) {
		this.custBillRem = custBillRem;
	}

	public BigDecimal getCustBillSoId() {
		return this.custBillSoId;
	}

	public void setCustBillSoId(BigDecimal custBillSoId) {
		this.custBillSoId = custBillSoId;
	}

	public BigDecimal getCustBillStusId() {
		return this.custBillStusId;
	}

	public void setCustBillStusId(BigDecimal custBillStusId) {
		this.custBillStusId = custBillStusId;
	}

	public Date getCustBillUpdDt() {
		return this.custBillUpdDt;
	}

	public void setCustBillUpdDt(Date custBillUpdDt) {
		this.custBillUpdDt = custBillUpdDt;
	}

	public BigDecimal getCustBillUpdUserId() {
		return this.custBillUpdUserId;
	}

	public void setCustBillUpdUserId(BigDecimal custBillUpdUserId) {
		this.custBillUpdUserId = custBillUpdUserId;
	}

	public String getCustBillWebPortalUrl() {
		return this.custBillWebPortalUrl;
	}

	public void setCustBillWebPortalUrl(String custBillWebPortalUrl) {
		this.custBillWebPortalUrl = custBillWebPortalUrl;
	}

}