package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the PAY0036D database table.
 * 
 */
public class AccTRXVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int trxId;

	private int trxNo;
	  
	private int trxItmNo;
	  
	private int trxGlAccId;
	  
	private String trxGlDept;
	 
	private String trxPrjct;
	  
	private int trxFinYear;
	  
	private int trxPriod;
	  
	private int trxSrcTypeId;
	  
	private int trxDocTypeId;
	  
	private String trxDocNo;
	  
	private String trxDocDt;
	  
	private int trxCustBillId;
	  
	private String trxChequeNo;
	  
	private String trxCrCardSlip;
	  
	private String trxBisNo;
	  
	private String trxReconDt;
	  
	private String trxRem;
	  
	private String trxCurrId;
	  
	private BigDecimal trxCurrRate;
	  
	private BigDecimal trxAmt;     
	  
	private BigDecimal trxAmtRm;
	  
	private int trxIsSynch;

	public int getTrxId() {
		return trxId;
	}

	public void setTrxId(int trxId) {
		this.trxId = trxId;
	}

	public int getTrxNo() {
		return trxNo;
	}

	public void setTrxNo(int trxNo) {
		this.trxNo = trxNo;
	}

	public int getTrxItmNo() {
		return trxItmNo;
	}

	public void setTrxItmNo(int trxItmNo) {
		this.trxItmNo = trxItmNo;
	}

	public int getTrxGlAccId() {
		return trxGlAccId;
	}

	public void setTrxGlAccId(int trxGlAccId) {
		this.trxGlAccId = trxGlAccId;
	}

	public String getTrxGlDept() {
		return trxGlDept;
	}

	public void setTrxGlDept(String trxGlDept) {
		this.trxGlDept = trxGlDept;
	}

	public String getTrxPrjct() {
		return trxPrjct;
	}

	public void setTrxPrjct(String trxPrjct) {
		this.trxPrjct = trxPrjct;
	}

	public int getTrxFinYear() {
		return trxFinYear;
	}

	public void setTrxFinYear(int trxFinYear) {
		this.trxFinYear = trxFinYear;
	}

	public int getTrxPriod() {
		return trxPriod;
	}

	public void setTrxPriod(int trxPriod) {
		this.trxPriod = trxPriod;
	}

	public int getTrxSrcTypeId() {
		return trxSrcTypeId;
	}

	public void setTrxSrcTypeId(int trxSrcTypeId) {
		this.trxSrcTypeId = trxSrcTypeId;
	}

	public int getTrxDocTypeId() {
		return trxDocTypeId;
	}

	public void setTrxDocTypeId(int trxDocTypeId) {
		this.trxDocTypeId = trxDocTypeId;
	}

	public String getTrxDocNo() {
		return trxDocNo;
	}

	public void setTrxDocNo(String trxDocNo) {
		this.trxDocNo = trxDocNo;
	}

	public String getTrxDocDt() {
		return trxDocDt;
	}

	public void setTrxDocDt(String trxDocDt) {
		this.trxDocDt = trxDocDt;
	}

	public int getTrxCustBillId() {
		return trxCustBillId;
	}

	public void setTrxCustBillId(int trxCustBillId) {
		this.trxCustBillId = trxCustBillId;
	}

	public String getTrxChequeNo() {
		return trxChequeNo;
	}

	public void setTrxChequeNo(String trxChequeNo) {
		this.trxChequeNo = trxChequeNo;
	}

	public String getTrxCrCardSlip() {
		return trxCrCardSlip;
	}

	public void setTrxCrCardSlip(String trxCrCardSlip) {
		this.trxCrCardSlip = trxCrCardSlip;
	}

	public String getTrxBisNo() {
		return trxBisNo;
	}

	public void setTrxBisNo(String trxBisNo) {
		this.trxBisNo = trxBisNo;
	}

	public String getTrxReconDt() {
		return trxReconDt;
	}

	public void setTrxReconDt(String trxReconDt) {
		this.trxReconDt = trxReconDt;
	}

	public String getTrxRem() {
		return trxRem;
	}

	public void setTrxRem(String trxRem) {
		this.trxRem = trxRem;
	}

	public String getTrxCurrId() {
		return trxCurrId;
	}

	public void setTrxCurrId(String trxCurrId) {
		this.trxCurrId = trxCurrId;
	}

	public BigDecimal getTrxCurrRate() {
		return trxCurrRate;
	}

	public void setTrxCurrRate(BigDecimal trxCurrRate) {
		this.trxCurrRate = trxCurrRate;
	}

	public BigDecimal getTrxAmt() {
		return trxAmt;
	}

	public void setTrxAmt(BigDecimal trxAmt) {
		this.trxAmt = trxAmt;
	}

	public BigDecimal getTrxAmtRm() {
		return trxAmtRm;
	}

	public void setTrxAmtRm(BigDecimal trxAmtRm) {
		this.trxAmtRm = trxAmtRm;
	}

	public int getTrxIsSynch() {
		return trxIsSynch;
	}

	public void setTrxIsSynch(int trxIsSynch) {
		this.trxIsSynch = trxIsSynch;
	}

}