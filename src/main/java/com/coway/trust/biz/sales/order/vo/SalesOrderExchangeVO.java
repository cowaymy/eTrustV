package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0095D database table.
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesOrderExchangeVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int soExchgId;
	private int soId;
	private int soExchgTypeId;
	private int soExchgStusId;
	private int soExchgResnId;
	private int soCurStusId;
	private int installEntryId;
	private int soExchgOldAppTypeId;
	private int soExchgNwAppTypeId;
	private int soExchgOldStkId;
	private int soExchgNwStkId;
	private int soExchgOldPrcId;
	private int soExchgNwPrcId;
	private BigDecimal soExchgOldPrc;
	private BigDecimal soExchgNwPrc;
	private BigDecimal soExchgOldPv;
	private BigDecimal soExchgNwPv;
	private BigDecimal soExchgOldRentAmt;
	private BigDecimal soExchgNwRentAmt;
	private int soExchgOldPromoId;
	private int soExchgNwPromoId;
	private String soExchgCrtDt;
	private int soExchgCrtUserId;
	private String soExchgUpdDt;
	private int soExchgUpdUserId;
	private int soExchgOldSrvConfigId;
	private int soExchgNwSrvConfigId;
	private int soExchgSyncChk;
	private int soExchgOldCallEntryId;
	private int soExchgNwCallEntryId;
	private int soExchgStkRetMovId;
	private String soExchgRem;
	private BigDecimal soExchgOldDefRentAmt;
	private BigDecimal soExchgNwDefRentAmt;
	private int soExchgUnderFreeAsId;
	private int soExchgOldCustId;
	private int soExchgNwCustId;
	private String soExchgFormNo;
	private int PTRStusId;
	private String PTRNo;
	private int soExchgAtchGrpId;
	//private String soExchgOldSrvType;
	//private String soExchgNwSrvType;

  public int getSoExchgId() {
		return soExchgId;
	}
	public void setSoExchgId(int soExchgId) {
		this.soExchgId = soExchgId;
	}
	public int getSoId() {
		return soId;
	}
	public void setSoId(int soId) {
		this.soId = soId;
	}
	public int getSoExchgTypeId() {
		return soExchgTypeId;
	}
	public void setSoExchgTypeId(int soExchgTypeId) {
		this.soExchgTypeId = soExchgTypeId;
	}
	public int getSoExchgStusId() {
		return soExchgStusId;
	}
	public void setSoExchgStusId(int soExchgStusId) {
		this.soExchgStusId = soExchgStusId;
	}
	public int getPTRStusId() {
		return PTRStusId;
	}
	public void setPTRStusId(int PTRStusId) {
		this.PTRStusId = PTRStusId;
	}
	public String getPTRNo() {
		return PTRNo;
	}
	public void setPTRNo(String PTRNo) {
		this.PTRNo = PTRNo;
	}
	public int getSoExchgResnId() {
		return soExchgResnId;
	}
	public void setSoExchgResnId(int soExchgResnId) {
		this.soExchgResnId = soExchgResnId;
	}
	public int getSoCurStusId() {
		return soCurStusId;
	}
	public void setSoCurStusId(int soCurStusId) {
		this.soCurStusId = soCurStusId;
	}
	public int getInstallEntryId() {
		return installEntryId;
	}
	public void setInstallEntryId(int installEntryId) {
		this.installEntryId = installEntryId;
	}
	public int getSoExchgOldAppTypeId() {
		return soExchgOldAppTypeId;
	}
	public void setSoExchgOldAppTypeId(int soExchgOldAppTypeId) {
		this.soExchgOldAppTypeId = soExchgOldAppTypeId;
	}
	public int getSoExchgNwAppTypeId() {
		return soExchgNwAppTypeId;
	}
	public void setSoExchgNwAppTypeId(int soExchgNwAppTypeId) {
		this.soExchgNwAppTypeId = soExchgNwAppTypeId;
	}
	public int getSoExchgOldStkId() {
		return soExchgOldStkId;
	}
	public void setSoExchgOldStkId(int soExchgOldStkId) {
		this.soExchgOldStkId = soExchgOldStkId;
	}
	public int getSoExchgNwStkId() {
		return soExchgNwStkId;
	}
	public void setSoExchgNwStkId(int soExchgNwStkId) {
		this.soExchgNwStkId = soExchgNwStkId;
	}
	public int getSoExchgOldPrcId() {
		return soExchgOldPrcId;
	}
	public void setSoExchgOldPrcId(int soExchgOldPrcId) {
		this.soExchgOldPrcId = soExchgOldPrcId;
	}
	public int getSoExchgNwPrcId() {
		return soExchgNwPrcId;
	}
	public void setSoExchgNwPrcId(int soExchgNwPrcId) {
		this.soExchgNwPrcId = soExchgNwPrcId;
	}
	public BigDecimal getSoExchgOldPrc() {
		return soExchgOldPrc;
	}
	public void setSoExchgOldPrc(BigDecimal soExchgOldPrc) {
		this.soExchgOldPrc = soExchgOldPrc;
	}
	public BigDecimal getSoExchgNwPrc() {
		return soExchgNwPrc;
	}
	public void setSoExchgNwPrc(BigDecimal soExchgNwPrc) {
		this.soExchgNwPrc = soExchgNwPrc;
	}
	public BigDecimal getSoExchgOldPv() {
		return soExchgOldPv;
	}
	public void setSoExchgOldPv(BigDecimal soExchgOldPv) {
		this.soExchgOldPv = soExchgOldPv;
	}
	public BigDecimal getSoExchgNwPv() {
		return soExchgNwPv;
	}
	public void setSoExchgNwPv(BigDecimal soExchgNwPv) {
		this.soExchgNwPv = soExchgNwPv;
	}
	public BigDecimal getSoExchgOldRentAmt() {
		return soExchgOldRentAmt;
	}
	public void setSoExchgOldRentAmt(BigDecimal soExchgOldRentAmt) {
		this.soExchgOldRentAmt = soExchgOldRentAmt;
	}
	public BigDecimal getSoExchgNwRentAmt() {
		return soExchgNwRentAmt;
	}
	public void setSoExchgNwRentAmt(BigDecimal soExchgNwRentAmt) {
		this.soExchgNwRentAmt = soExchgNwRentAmt;
	}
	public int getSoExchgOldPromoId() {
		return soExchgOldPromoId;
	}
	public void setSoExchgOldPromoId(int soExchgOldPromoId) {
		this.soExchgOldPromoId = soExchgOldPromoId;
	}
	public int getSoExchgNwPromoId() {
		return soExchgNwPromoId;
	}
	public void setSoExchgNwPromoId(int soExchgNwPromoId) {
		this.soExchgNwPromoId = soExchgNwPromoId;
	}
	public String getSoExchgCrtDt() {
		return soExchgCrtDt;
	}
	public void setSoExchgCrtDt(String soExchgCrtDt) {
		this.soExchgCrtDt = soExchgCrtDt;
	}
	public int getSoExchgCrtUserId() {
		return soExchgCrtUserId;
	}
	public void setSoExchgCrtUserId(int soExchgCrtUserId) {
		this.soExchgCrtUserId = soExchgCrtUserId;
	}
	public String getSoExchgUpdDt() {
		return soExchgUpdDt;
	}
	public void setSoExchgUpdDt(String soExchgUpdDt) {
		this.soExchgUpdDt = soExchgUpdDt;
	}
	public int getSoExchgUpdUserId() {
		return soExchgUpdUserId;
	}
	public void setSoExchgUpdUserId(int soExchgUpdUserId) {
		this.soExchgUpdUserId = soExchgUpdUserId;
	}
	public int getSoExchgOldSrvConfigId() {
		return soExchgOldSrvConfigId;
	}
	public void setSoExchgOldSrvConfigId(int soExchgOldSrvConfigId) {
		this.soExchgOldSrvConfigId = soExchgOldSrvConfigId;
	}
	public int getSoExchgNwSrvConfigId() {
		return soExchgNwSrvConfigId;
	}
	public void setSoExchgNwSrvConfigId(int soExchgNwSrvConfigId) {
		this.soExchgNwSrvConfigId = soExchgNwSrvConfigId;
	}
	public int getSoExchgSyncChk() {
		return soExchgSyncChk;
	}
	public void setSoExchgSyncChk(int soExchgSyncChk) {
		this.soExchgSyncChk = soExchgSyncChk;
	}
	public int getSoExchgOldCallEntryId() {
		return soExchgOldCallEntryId;
	}
	public void setSoExchgOldCallEntryId(int soExchgOldCallEntryId) {
		this.soExchgOldCallEntryId = soExchgOldCallEntryId;
	}
	public int getSoExchgNwCallEntryId() {
		return soExchgNwCallEntryId;
	}
	public void setSoExchgNwCallEntryId(int soExchgNwCallEntryId) {
		this.soExchgNwCallEntryId = soExchgNwCallEntryId;
	}
	public int getSoExchgStkRetMovId() {
		return soExchgStkRetMovId;
	}
	public void setSoExchgStkRetMovId(int soExchgStkRetMovId) {
		this.soExchgStkRetMovId = soExchgStkRetMovId;
	}
	public String getSoExchgRem() {
		return soExchgRem;
	}
	public void setSoExchgRem(String soExchgRem) {
		this.soExchgRem = soExchgRem;
	}
	public BigDecimal getSoExchgOldDefRentAmt() {
		return soExchgOldDefRentAmt;
	}
	public void setSoExchgOldDefRentAmt(BigDecimal soExchgOldDefRentAmt) {
		this.soExchgOldDefRentAmt = soExchgOldDefRentAmt;
	}
	public BigDecimal getSoExchgNwDefRentAmt() {
		return soExchgNwDefRentAmt;
	}
	public void setSoExchgNwDefRentAmt(BigDecimal soExchgNwDefRentAmt) {
		this.soExchgNwDefRentAmt = soExchgNwDefRentAmt;
	}
	public int getSoExchgUnderFreeAsId() {
		return soExchgUnderFreeAsId;
	}
	public void setSoExchgUnderFreeAsId(int soExchgUnderFreeAsId) {
		this.soExchgUnderFreeAsId = soExchgUnderFreeAsId;
	}
	public int getSoExchgOldCustId() {
		return soExchgOldCustId;
	}
	public void setSoExchgOldCustId(int soExchgOldCustId) {
		this.soExchgOldCustId = soExchgOldCustId;
	}
	public int getSoExchgNwCustId() {
		return soExchgNwCustId;
	}
	public void setSoExchgNwCustId(int soExchgNwCustId) {
		this.soExchgNwCustId = soExchgNwCustId;
	}
	public String getSoExchgFormNo() {
		return soExchgFormNo;
	}
	public void setSoExchgFormNo(String soExchgFormNo) {
		this.soExchgFormNo = soExchgFormNo;
	}
	public int getSoExchgAtchGrpId() {
	  return soExchgAtchGrpId;
	}
	public void setSoExchgAtchGrpId(int soExchgAtchGrpId) {
	  this.soExchgAtchGrpId = soExchgAtchGrpId;
	}
  //public String getSoExchgOldSrvType() {
  //  return soExchgOldSrvType;
  //}
  //public void setSoExchgOldSrvType(String soExchgOldSrvType) {
  //  this.soExchgOldSrvType = soExchgOldSrvType;
  //}
  //public String getSoExchgNwSrvType() {
  //  return soExchgNwSrvType;
  //}
  //public void setSoExchgNwSrvType(String soExchgNwSrvType) {
  //  this.soExchgNwSrvType = soExchgNwSrvType;
  //}
}