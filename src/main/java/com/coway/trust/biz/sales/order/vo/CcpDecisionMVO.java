package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0102D database table.
 * 
 */
public class CcpDecisionMVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long ccpId;

	private String ccpCtosBatchNo;

	private BigDecimal ccpFico;

	private BigDecimal ccpFicoLok;

	private BigDecimal ccpHasGrnt;

	private BigDecimal ccpIncomeRangeId;

	private BigDecimal ccpIsCurr;

	private BigDecimal ccpIsHold;

	private BigDecimal ccpIsLou;

	private BigDecimal ccpIsSaman;

	private BigDecimal ccpIsSync;

	private String ccpPncRem;

	private String ccpRem;

	private BigDecimal ccpResnId;

	private BigDecimal ccpRjStusId;

	private BigDecimal ccpSalesOrdId;

	private BigDecimal ccpSchemeTypeId;

	private BigDecimal ccpStusId;

	private BigDecimal ccpTotScrePoint;

	private BigDecimal ccpTypeId;

	private Date ccpUpdDt;

	private BigDecimal ccpUpdUserId;

	public CcpDecisionMVO() {
	}

	public long getCcpId() {
		return this.ccpId;
	}

	public void setCcpId(long ccpId) {
		this.ccpId = ccpId;
	}

	public String getCcpCtosBatchNo() {
		return this.ccpCtosBatchNo;
	}

	public void setCcpCtosBatchNo(String ccpCtosBatchNo) {
		this.ccpCtosBatchNo = ccpCtosBatchNo;
	}

	public BigDecimal getCcpFico() {
		return this.ccpFico;
	}

	public void setCcpFico(BigDecimal ccpFico) {
		this.ccpFico = ccpFico;
	}

	public BigDecimal getCcpFicoLok() {
		return this.ccpFicoLok;
	}

	public void setCcpFicoLok(BigDecimal ccpFicoLok) {
		this.ccpFicoLok = ccpFicoLok;
	}

	public BigDecimal getCcpHasGrnt() {
		return this.ccpHasGrnt;
	}

	public void setCcpHasGrnt(BigDecimal ccpHasGrnt) {
		this.ccpHasGrnt = ccpHasGrnt;
	}

	public BigDecimal getCcpIncomeRangeId() {
		return this.ccpIncomeRangeId;
	}

	public void setCcpIncomeRangeId(BigDecimal ccpIncomeRangeId) {
		this.ccpIncomeRangeId = ccpIncomeRangeId;
	}

	public BigDecimal getCcpIsCurr() {
		return this.ccpIsCurr;
	}

	public void setCcpIsCurr(BigDecimal ccpIsCurr) {
		this.ccpIsCurr = ccpIsCurr;
	}

	public BigDecimal getCcpIsHold() {
		return this.ccpIsHold;
	}

	public void setCcpIsHold(BigDecimal ccpIsHold) {
		this.ccpIsHold = ccpIsHold;
	}

	public BigDecimal getCcpIsLou() {
		return this.ccpIsLou;
	}

	public void setCcpIsLou(BigDecimal ccpIsLou) {
		this.ccpIsLou = ccpIsLou;
	}

	public BigDecimal getCcpIsSaman() {
		return this.ccpIsSaman;
	}

	public void setCcpIsSaman(BigDecimal ccpIsSaman) {
		this.ccpIsSaman = ccpIsSaman;
	}

	public BigDecimal getCcpIsSync() {
		return this.ccpIsSync;
	}

	public void setCcpIsSync(BigDecimal ccpIsSync) {
		this.ccpIsSync = ccpIsSync;
	}

	public String getCcpPncRem() {
		return this.ccpPncRem;
	}

	public void setCcpPncRem(String ccpPncRem) {
		this.ccpPncRem = ccpPncRem;
	}

	public String getCcpRem() {
		return this.ccpRem;
	}

	public void setCcpRem(String ccpRem) {
		this.ccpRem = ccpRem;
	}

	public BigDecimal getCcpResnId() {
		return this.ccpResnId;
	}

	public void setCcpResnId(BigDecimal ccpResnId) {
		this.ccpResnId = ccpResnId;
	}

	public BigDecimal getCcpRjStusId() {
		return this.ccpRjStusId;
	}

	public void setCcpRjStusId(BigDecimal ccpRjStusId) {
		this.ccpRjStusId = ccpRjStusId;
	}

	public BigDecimal getCcpSalesOrdId() {
		return this.ccpSalesOrdId;
	}

	public void setCcpSalesOrdId(BigDecimal ccpSalesOrdId) {
		this.ccpSalesOrdId = ccpSalesOrdId;
	}

	public BigDecimal getCcpSchemeTypeId() {
		return this.ccpSchemeTypeId;
	}

	public void setCcpSchemeTypeId(BigDecimal ccpSchemeTypeId) {
		this.ccpSchemeTypeId = ccpSchemeTypeId;
	}

	public BigDecimal getCcpStusId() {
		return this.ccpStusId;
	}

	public void setCcpStusId(BigDecimal ccpStusId) {
		this.ccpStusId = ccpStusId;
	}

	public BigDecimal getCcpTotScrePoint() {
		return this.ccpTotScrePoint;
	}

	public void setCcpTotScrePoint(BigDecimal ccpTotScrePoint) {
		this.ccpTotScrePoint = ccpTotScrePoint;
	}

	public BigDecimal getCcpTypeId() {
		return this.ccpTypeId;
	}

	public void setCcpTypeId(BigDecimal ccpTypeId) {
		this.ccpTypeId = ccpTypeId;
	}

	public Date getCcpUpdDt() {
		return this.ccpUpdDt;
	}

	public void setCcpUpdDt(Date ccpUpdDt) {
		this.ccpUpdDt = ccpUpdDt;
	}

	public BigDecimal getCcpUpdUserId() {
		return this.ccpUpdUserId;
	}

	public void setCcpUpdUserId(BigDecimal ccpUpdUserId) {
		this.ccpUpdUserId = ccpUpdUserId;
	}

}