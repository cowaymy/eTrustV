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

	private int ccpId;

	private String ccpCtosBatchNo;

	private int ccpFico;

	private int ccpFicoLok;

	private int ccpHasGrnt;

	private int ccpIncomeRangeId;

	private int ccpIsCurr;

	private int ccpIsHold;

	private int ccpIsLou;

	private int ccpIsSaman;

	private int ccpIsSync;

	private String ccpPncRem;

	private String ccpRem;

	private int ccpResnId;

	private int ccpRjStusId;

	private int ccpSalesOrdId;

	private int ccpSchemeTypeId;

	private int ccpStusId;

	private BigDecimal ccpTotScrePoint;

	private int ccpTypeId;

	private Date ccpUpdDt;

	private int ccpUpdUserId;

	// CCP Own Purchase SHI Index
	private int ccpOpcShi;

	// CCP Own Purchase Mem ID
	private int ccpOpcMemId;

	public CcpDecisionMVO() {
	}

	public int getCcpId() {
		return ccpId;
	}

	public void setCcpId(int ccpId) {
		this.ccpId = ccpId;
	}

	public String getCcpCtosBatchNo() {
		return ccpCtosBatchNo;
	}

	public void setCcpCtosBatchNo(String ccpCtosBatchNo) {
		this.ccpCtosBatchNo = ccpCtosBatchNo;
	}

	public int getCcpFico() {
		return ccpFico;
	}

	public void setCcpFico(int ccpFico) {
		this.ccpFico = ccpFico;
	}

	public int getCcpFicoLok() {
		return ccpFicoLok;
	}

	public void setCcpFicoLok(int ccpFicoLok) {
		this.ccpFicoLok = ccpFicoLok;
	}

	public int getCcpHasGrnt() {
		return ccpHasGrnt;
	}

	public void setCcpHasGrnt(int ccpHasGrnt) {
		this.ccpHasGrnt = ccpHasGrnt;
	}

	public int getCcpIncomeRangeId() {
		return ccpIncomeRangeId;
	}

	public void setCcpIncomeRangeId(int ccpIncomeRangeId) {
		this.ccpIncomeRangeId = ccpIncomeRangeId;
	}

	public int getCcpIsCurr() {
		return ccpIsCurr;
	}

	public void setCcpIsCurr(int ccpIsCurr) {
		this.ccpIsCurr = ccpIsCurr;
	}

	public int getCcpIsHold() {
		return ccpIsHold;
	}

	public void setCcpIsHold(int ccpIsHold) {
		this.ccpIsHold = ccpIsHold;
	}

	public int getCcpIsLou() {
		return ccpIsLou;
	}

	public void setCcpIsLou(int ccpIsLou) {
		this.ccpIsLou = ccpIsLou;
	}

	public int getCcpIsSaman() {
		return ccpIsSaman;
	}

	public void setCcpIsSaman(int ccpIsSaman) {
		this.ccpIsSaman = ccpIsSaman;
	}

	public int getCcpIsSync() {
		return ccpIsSync;
	}

	public void setCcpIsSync(int ccpIsSync) {
		this.ccpIsSync = ccpIsSync;
	}

	public String getCcpPncRem() {
		return ccpPncRem;
	}

	public void setCcpPncRem(String ccpPncRem) {
		this.ccpPncRem = ccpPncRem;
	}

	public String getCcpRem() {
		return ccpRem;
	}

	public void setCcpRem(String ccpRem) {
		this.ccpRem = ccpRem;
	}

	public int getCcpResnId() {
		return ccpResnId;
	}

	public void setCcpResnId(int ccpResnId) {
		this.ccpResnId = ccpResnId;
	}

	public int getCcpRjStusId() {
		return ccpRjStusId;
	}

	public void setCcpRjStusId(int ccpRjStusId) {
		this.ccpRjStusId = ccpRjStusId;
	}

	public int getCcpSalesOrdId() {
		return ccpSalesOrdId;
	}

	public void setCcpSalesOrdId(int ccpSalesOrdId) {
		this.ccpSalesOrdId = ccpSalesOrdId;
	}

	public int getCcpSchemeTypeId() {
		return ccpSchemeTypeId;
	}

	public void setCcpSchemeTypeId(int ccpSchemeTypeId) {
		this.ccpSchemeTypeId = ccpSchemeTypeId;
	}

	public int getCcpStusId() {
		return ccpStusId;
	}

	public void setCcpStusId(int ccpStusId) {
		this.ccpStusId = ccpStusId;
	}

	public BigDecimal getCcpTotScrePoint() {
		return ccpTotScrePoint;
	}

	public void setCcpTotScrePoint(BigDecimal ccpTotScrePoint) {
		this.ccpTotScrePoint = ccpTotScrePoint;
	}

	public int getCcpTypeId() {
		return ccpTypeId;
	}

	public void setCcpTypeId(int ccpTypeId) {
		this.ccpTypeId = ccpTypeId;
	}

	public Date getCcpUpdDt() {
		return ccpUpdDt;
	}

	public void setCcpUpdDt(Date ccpUpdDt) {
		this.ccpUpdDt = ccpUpdDt;
	}

	public int getCcpUpdUserId() {
		return ccpUpdUserId;
	}

	public void setCcpUpdUserId(int ccpUpdUserId) {
		this.ccpUpdUserId = ccpUpdUserId;
	}

	public int getCcpOpcShi() {
		return ccpOpcShi;
	}

	public void setCcpOpcShi(int ccpOpcShi) {
		this.ccpOpcShi = ccpOpcShi;
	}

	public int getCcpOpcMemId() {
		return ccpOpcMemId;
	}

	public void setCcpOpcMemId(int ccpOpcMemId) {
		this.ccpOpcMemId = ccpOpcMemId;
	}

}