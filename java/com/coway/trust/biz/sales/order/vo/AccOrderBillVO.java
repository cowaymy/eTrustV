package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the PAY0016D database table.
 * 
 */
public class AccOrderBillVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int accBillId;

	private int accBillTaskId;
	
	private String accBillRefDt;
	
	private String accBillRefNo;
	
	private int accBillOrdId;
	
	private String accBillOrdNo;
	
	private int accBillTypeId;
	
	private int accBillModeId;
	
	private int accBillSchdulId;
	
	private int accBillSchdulPriod;
	
	private int accBillAdjId;
	
	private BigDecimal accBillSchdulAmt;
	
	private BigDecimal accBillAdjAmt;
	
	private BigDecimal accBillTxsAmt;
	
	private BigDecimal accBillNetAmt;
	
	private int accBillStus;
	
	private String accBillRem;
	
	private String accBillCrtDt;
	
	private int accBillCrtUserId;
	
	private int accBillGrpId;
	
	private int accBillTaxCodeId;
	
	private int accBillTaxRate;
	
	private int accBillAcctCnvr;
	
	private int accBillCntrctId;

	public int getAccBillId() {
		return accBillId;
	}

	public void setAccBillId(int accBillId) {
		this.accBillId = accBillId;
	}

	public int getAccBillTaskId() {
		return accBillTaskId;
	}

	public void setAccBillTaskId(int accBillTaskId) {
		this.accBillTaskId = accBillTaskId;
	}

	public String getAccBillRefDt() {
		return accBillRefDt;
	}

	public void setAccBillRefDt(String accBillRefDt) {
		this.accBillRefDt = accBillRefDt;
	}

	public String getAccBillRefNo() {
		return accBillRefNo;
	}

	public void setAccBillRefNo(String accBillRefNo) {
		this.accBillRefNo = accBillRefNo;
	}

	public int getAccBillOrdId() {
		return accBillOrdId;
	}

	public void setAccBillOrdId(int accBillOrdId) {
		this.accBillOrdId = accBillOrdId;
	}

	public String getAccBillOrdNo() {
		return accBillOrdNo;
	}

	public void setAccBillOrdNo(String accBillOrdNo) {
		this.accBillOrdNo = accBillOrdNo;
	}

	public int getAccBillTypeId() {
		return accBillTypeId;
	}

	public void setAccBillTypeId(int accBillTypeId) {
		this.accBillTypeId = accBillTypeId;
	}

	public int getAccBillModeId() {
		return accBillModeId;
	}

	public void setAccBillModeId(int accBillModeId) {
		this.accBillModeId = accBillModeId;
	}

	public int getAccBillSchdulId() {
		return accBillSchdulId;
	}

	public void setAccBillSchdulId(int accBillSchdulId) {
		this.accBillSchdulId = accBillSchdulId;
	}

	public int getAccBillSchdulPriod() {
		return accBillSchdulPriod;
	}

	public void setAccBillSchdulPriod(int accBillSchdulPriod) {
		this.accBillSchdulPriod = accBillSchdulPriod;
	}

	public int getAccBillAdjId() {
		return accBillAdjId;
	}

	public void setAccBillAdjId(int accBillAdjId) {
		this.accBillAdjId = accBillAdjId;
	}

	public BigDecimal getAccBillSchdulAmt() {
		return accBillSchdulAmt;
	}

	public void setAccBillSchdulAmt(BigDecimal accBillSchdulAmt) {
		this.accBillSchdulAmt = accBillSchdulAmt;
	}

	public BigDecimal getAccBillAdjAmt() {
		return accBillAdjAmt;
	}

	public void setAccBillAdjAmt(BigDecimal accBillAdjAmt) {
		this.accBillAdjAmt = accBillAdjAmt;
	}

	public BigDecimal getAccBillTxsAmt() {
		return accBillTxsAmt;
	}

	public void setAccBillTxsAmt(BigDecimal accBillTxsAmt) {
		this.accBillTxsAmt = accBillTxsAmt;
	}

	public BigDecimal getAccBillNetAmt() {
		return accBillNetAmt;
	}

	public void setAccBillNetAmt(BigDecimal accBillNetAmt) {
		this.accBillNetAmt = accBillNetAmt;
	}

	public int getAccBillStus() {
		return accBillStus;
	}

	public void setAccBillStus(int accBillStus) {
		this.accBillStus = accBillStus;
	}

	public String getAccBillRem() {
		return accBillRem;
	}

	public void setAccBillRem(String accBillRem) {
		this.accBillRem = accBillRem;
	}

	public String getAccBillCrtDt() {
		return accBillCrtDt;
	}

	public void setAccBillCrtDt(String accBillCrtDt) {
		this.accBillCrtDt = accBillCrtDt;
	}

	public int getAccBillCrtUserId() {
		return accBillCrtUserId;
	}

	public void setAccBillCrtUserId(int accBillCrtUserId) {
		this.accBillCrtUserId = accBillCrtUserId;
	}

	public int getAccBillGrpId() {
		return accBillGrpId;
	}

	public void setAccBillGrpId(int accBillGrpId) {
		this.accBillGrpId = accBillGrpId;
	}

	public int getAccBillTaxCodeId() {
		return accBillTaxCodeId;
	}

	public void setAccBillTaxCodeId(int accBillTaxCodeId) {
		this.accBillTaxCodeId = accBillTaxCodeId;
	}

	public int getAccBillTaxRate() {
		return accBillTaxRate;
	}

	public void setAccBillTaxRate(int accBillTaxRate) {
		this.accBillTaxRate = accBillTaxRate;
	}

	public int getAccBillAcctCnvr() {
		return accBillAcctCnvr;
	}

	public void setAccBillAcctCnvr(int accBillAcctCnvr) {
		this.accBillAcctCnvr = accBillAcctCnvr;
	}

	public int getAccBillCntrctId() {
		return accBillCntrctId;
	}

	public void setAccBillCntrctId(int accBillCntrctId) {
		this.accBillCntrctId = accBillCntrctId;
	}
}