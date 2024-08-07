package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0020D database table.
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesReqCancelVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int soReqId;

	private int soReqSoId;

	private int soReqStusId;

	private int soReqResnId;

	private int soReqPrevCallEntryId;

	private int soReqCurCallEntryId;

	private int soReqCurStusId;

	private String soReqCrtDt;

	private int soReqCrtUserId;

	private String soReqUpdDt;

	private int soReqUpdUserId;

	private int soReqCurStkId;

	private int soReqCurAppTypeId;

	private BigDecimal soReqCurAmt;

	private BigDecimal soReqCurPv;

	private BigDecimal soReqCurrAmt;

	private String soReqActualCanclDt;

	private BigDecimal soReqCanclTotOtstnd;

	private BigDecimal soReqCanclPnaltyAmt;

	private int soReqCanclObPriod;

	private int soReqCanclUnderCoolPriod;

	private BigDecimal soReqCanclRentalOtstnd;

	private int soReqCanclTotUsedPriod;

	private String soReqNo;

	private BigDecimal soReqCanclAdjAmt;

	private int soReqster;

	private String soReqPreRetnDt;

	private String soReqRem;

	private String soReqBankAcc;

	private String soReqIssBank;

	private String soReqAccName;

	private String soReqAttach;

	private String atchFileGrpId;

	private String soReqFollowUp;


  public int getSoReqId() {
		return soReqId;
	}

	public void setSoReqId(int soReqId) {
		this.soReqId = soReqId;
	}

	public int getSoReqSoId() {
		return soReqSoId;
	}

	public void setSoReqSoId(int soReqSoId) {
		this.soReqSoId = soReqSoId;
	}

	public int getSoReqStusId() {
		return soReqStusId;
	}

	public void setSoReqStusId(int soReqStusId) {
		this.soReqStusId = soReqStusId;
	}

	public int getSoReqResnId() {
		return soReqResnId;
	}

	public void setSoReqResnId(int soReqResnId) {
		this.soReqResnId = soReqResnId;
	}

	public int getSoReqPrevCallEntryId() {
		return soReqPrevCallEntryId;
	}

	public void setSoReqPrevCallEntryId(int soReqPrevCallEntryId) {
		this.soReqPrevCallEntryId = soReqPrevCallEntryId;
	}

	public int getSoReqCurCallEntryId() {
		return soReqCurCallEntryId;
	}

	public void setSoReqCurCallEntryId(int soReqCurCallEntryId) {
		this.soReqCurCallEntryId = soReqCurCallEntryId;
	}

	public int getSoReqCurStusId() {
		return soReqCurStusId;
	}

	public void setSoReqCurStusId(int soReqCurStusId) {
		this.soReqCurStusId = soReqCurStusId;
	}

	public String getSoReqCrtDt() {
		return soReqCrtDt;
	}

	public void setSoReqCrtDt(String soReqCrtDt) {
		this.soReqCrtDt = soReqCrtDt;
	}

	public int getSoReqCrtUserId() {
		return soReqCrtUserId;
	}

	public void setSoReqCrtUserId(int soReqCrtUserId) {
		this.soReqCrtUserId = soReqCrtUserId;
	}

	public String getSoReqUpdDt() {
		return soReqUpdDt;
	}

	public void setSoReqUpdDt(String soReqUpdDt) {
		this.soReqUpdDt = soReqUpdDt;
	}

	public int getSoReqUpdUserId() {
		return soReqUpdUserId;
	}

	public void setSoReqUpdUserId(int soReqUpdUserId) {
		this.soReqUpdUserId = soReqUpdUserId;
	}

	public int getSoReqCurStkId() {
		return soReqCurStkId;
	}

	public void setSoReqCurStkId(int soReqCurStkId) {
		this.soReqCurStkId = soReqCurStkId;
	}

	public int getSoReqCurAppTypeId() {
		return soReqCurAppTypeId;
	}

	public void setSoReqCurAppTypeId(int soReqCurAppTypeId) {
		this.soReqCurAppTypeId = soReqCurAppTypeId;
	}

	public BigDecimal getSoReqCurAmt() {
		return soReqCurAmt;
	}

	public void setSoReqCurAmt(BigDecimal soReqCurAmt) {
		this.soReqCurAmt = soReqCurAmt;
	}

	public BigDecimal getSoReqCurPv() {
		return soReqCurPv;
	}

	public void setSoReqCurPv(BigDecimal soReqCurPv) {
		this.soReqCurPv = soReqCurPv;
	}

	public BigDecimal getSoReqCurrAmt() {
		return soReqCurrAmt;
	}

	public void setSoReqCurrAmt(BigDecimal soReqCurrAmt) {
		this.soReqCurrAmt = soReqCurrAmt;
	}

	public String getSoReqActualCanclDt() {
		return soReqActualCanclDt;
	}

	public void setSoReqActualCanclDt(String soReqActualCanclDt) {
		this.soReqActualCanclDt = soReqActualCanclDt;
	}

	public BigDecimal getSoReqCanclTotOtstnd() {
		return soReqCanclTotOtstnd;
	}

	public void setSoReqCanclTotOtstnd(BigDecimal soReqCanclTotOtstnd) {
		this.soReqCanclTotOtstnd = soReqCanclTotOtstnd;
	}

	public BigDecimal getSoReqCanclPnaltyAmt() {
		return soReqCanclPnaltyAmt;
	}

	public void setSoReqCanclPnaltyAmt(BigDecimal soReqCanclPnaltyAmt) {
		this.soReqCanclPnaltyAmt = soReqCanclPnaltyAmt;
	}

	public int getSoReqCanclObPriod() {
		return soReqCanclObPriod;
	}

	public void setSoReqCanclObPriod(int soReqCanclObPriod) {
		this.soReqCanclObPriod = soReqCanclObPriod;
	}

	public int getSoReqCanclUnderCoolPriod() {
		return soReqCanclUnderCoolPriod;
	}

	public void setSoReqCanclUnderCoolPriod(int soReqCanclUnderCoolPriod) {
		this.soReqCanclUnderCoolPriod = soReqCanclUnderCoolPriod;
	}

	public BigDecimal getSoReqCanclRentalOtstnd() {
		return soReqCanclRentalOtstnd;
	}

	public void setSoReqCanclRentalOtstnd(BigDecimal soReqCanclRentalOtstnd) {
		this.soReqCanclRentalOtstnd = soReqCanclRentalOtstnd;
	}

	public int getSoReqCanclTotUsedPriod() {
		return soReqCanclTotUsedPriod;
	}

	public void setSoReqCanclTotUsedPriod(int soReqCanclTotUsedPriod) {
		this.soReqCanclTotUsedPriod = soReqCanclTotUsedPriod;
	}

	public String getSoReqNo() {
		return soReqNo;
	}

	public void setSoReqNo(String soReqNo) {
		this.soReqNo = soReqNo;
	}

	public BigDecimal getSoReqCanclAdjAmt() {
		return soReqCanclAdjAmt;
	}

	public void setSoReqCanclAdjAmt(BigDecimal soReqCanclAdjAmt) {
		this.soReqCanclAdjAmt = soReqCanclAdjAmt;
	}

	public int getSoReqster() {
		return soReqster;
	}

	public void setSoReqster(int soReqster) {
		this.soReqster = soReqster;
	}

	public String getSoReqPreRetnDt() {
		return soReqPreRetnDt;
	}

	public void setSoReqPreRetnDt(String soReqPreRetnDt) {
		this.soReqPreRetnDt = soReqPreRetnDt;
	}

	public String getSoReqRem() {
		return soReqRem;
	}

	public void setSoReqRem(String soReqRem) {
		this.soReqRem = soReqRem;
	}

	public String getSoReqBankAcc() {
		return soReqBankAcc;
	}

	public void setSoReqBankAcc(String soReqBankAcc) {
		this.soReqBankAcc = soReqBankAcc;
	}

	public String getSoReqIssBank() {
		return soReqIssBank;
	}

	public void setSoReqIssBank(String soReqIssBank) {
		this.soReqIssBank = soReqIssBank;
	}

	public String getSoReqAccName() {
		return soReqAccName;
	}

	public void setSoReqAccName(String soReqAccName) {
		this.soReqAccName = soReqAccName;
	}

	public String getSoReqAttach() {
		return soReqAttach;
	}

	public void setSoReqAttach(String soReqAttach) {
		this.soReqAttach = soReqAttach;
	}

  public String getAtchFileGrpId() {
    return atchFileGrpId;
  }

  public void setAtchFileGrpId(String atchFileGrpId) {
    this.atchFileGrpId = atchFileGrpId;
  }

  public String getSoReqFollowUp() {
    return soReqFollowUp;
  }

  public void setSoReqFollowUp(String soReqFollowUp) {
    this.soReqFollowUp = soReqFollowUp;
  }

}