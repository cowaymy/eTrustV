package com.coway.trust.biz.sales.promotion.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0018D database table.
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesPromoDVO implements Serializable {

	private static final long serialVersionUID = 1L;

	private int promoItmId;

	private int promoReqstItmId;

	private int promoReqstId;

	private int promoId;

	private int promoItmStkId;//

	private int promoItmCurId;

	private int promoItmPrc;

	private int promoItmPv;

	private int promoItmStusId;

	private int promoItmUpdUserId;

	private Date promoItmUpdDt;

	private int promoItmRental;

	private int promoItmRentPriod;

	private int promoItmObligPriod;

	private String itmcd;//

	private String itmname;//

	private BigDecimal amt;

	private BigDecimal prcRpf;

	private BigDecimal prcPv;

	private String srvType;//

	private int promoItmPvSs;

	private int promoAmtSs;

	private int crtUserId;

	private int updUserId;

	private BigDecimal promoItmPvGst;

	private BigDecimal stkCtgryId;

	private String actionTab;

	public int getPromoItmId() {
		return promoItmId;
	}

	public int getPromoReqstItmId() {
		return promoReqstItmId;
	}

	public int getPromoReqstId() {
		return promoReqstId;
	}

	public void setPromoReqstId(int promoReqstId) {
		this.promoReqstId = promoReqstId;
	}

	public void setPromoItmId(int promoItmId) {
		this.promoItmId = promoItmId;
	}

	public void setPromoReqstItmId(int promoReqstItmId) {
		this.promoReqstItmId = promoReqstItmId;
	}

	public int getPromoId() {
		return promoId;
	}

	public void setPromoId(int promoId) {
		this.promoId = promoId;
	}

	public int getPromoItmStkId() {
		return promoItmStkId;
	}

	public void setPromoItmStkId(int promoItmStkId) {
		this.promoItmStkId = promoItmStkId;
	}

	public int getPromoItmCurId() {
		return promoItmCurId;
	}

	public void setPromoItmCurId(int promoItmCurId) {
		this.promoItmCurId = promoItmCurId;
	}

	public int getPromoItmPrc() {
		return promoItmPrc;
	}

	public void setPromoItmPrc(int promoItmPrc) {
		this.promoItmPrc = promoItmPrc;
	}

	public int getPromoItmPv() {
		return promoItmPv;
	}

	public void setPromoItmPv(int promoItmPv) {
		this.promoItmPv = promoItmPv;
	}

	public int getPromoItmStusId() {
		return promoItmStusId;
	}

	public void setPromoItmStusId(int promoItmStusId) {
		this.promoItmStusId = promoItmStusId;
	}

	public int getPromoItmUpdUserId() {
		return promoItmUpdUserId;
	}

	public void setPromoItmUpdUserId(int promoItmUpdUserId) {
		this.promoItmUpdUserId = promoItmUpdUserId;
	}

	public Date getPromoItmUpdDt() {
		return promoItmUpdDt;
	}

	public void setPromoItmUpdDt(Date promoItmUpdDt) {
		this.promoItmUpdDt = promoItmUpdDt;
	}

	public int getPromoItmRental() {
		return promoItmRental;
	}

	public void setPromoItmRental(int promoItmRental) {
		this.promoItmRental = promoItmRental;
	}

	public int getPromoItmRentPriod() {
		return promoItmRentPriod;
	}

	public void setPromoItmRentPriod(int promoItmRentPriod) {
		this.promoItmRentPriod = promoItmRentPriod;
	}

	public int getPromoItmObligPriod() {
		return promoItmObligPriod;
	}

	public void setPromoItmObligPriod(int promoItmObligPriod) {
		this.promoItmObligPriod = promoItmObligPriod;
	}

	public String getItmcd() {
		return itmcd;
	}

	public void setItmcd(String itmcd) {
		this.itmcd = itmcd;
	}

	public String getItmname() {
		return itmname;
	}

	public void setItmname(String itmname) {
		this.itmname = itmname;
	}

	public BigDecimal getAmt() {
		return amt;
	}

	public void setAmt(BigDecimal amt) {
		this.amt = amt;
	}

	public BigDecimal getPrcRpf() {
		return prcRpf;
	}

	public void setPrcRpf(BigDecimal prcRpf) {
		this.prcRpf = prcRpf;
	}

	public BigDecimal getPrcPv() {
		return prcPv;
	}

	public void setPrcPv(BigDecimal prcPv) {
		this.prcPv = prcPv;
	}

	public int getCrtUserId() {
		return crtUserId;
	}

	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}

	public int getUpdUserId() {
		return updUserId;
	}

	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}

	public BigDecimal getPromoItmPvGst() {
		return promoItmPvGst;
	}

	public void setPromoItmPvGst(BigDecimal promoItmPvGst) {
		this.promoItmPvGst = promoItmPvGst;
	}

	public BigDecimal getStkCtgryId() {
		return stkCtgryId;
	}

	public void setStkCtgryId(BigDecimal stkCtgryId) {
		this.stkCtgryId = stkCtgryId;
	}

	public String getActionTab() {
		return actionTab;
	}

	  public void setActionTab(String actionTab) {
		    this.actionTab = actionTab;
    }

    public String getSrvType() {
      return srvType;
    }

    public void setSrvType(String srvType) {
      this.srvType = srvType;
    }

    public int getPromoItmPvSs() {
      return promoItmPvSs;
    }

    public void setPromoItmPvSs(int promoItmPvSs) {
      this.promoItmPvSs = promoItmPvSs;
    }

    public int getPromoAmtSs() {
      return promoAmtSs;
    }

    public void setPromoAmtSs(int promoAmtSs) {
      this.promoAmtSs = promoAmtSs;
    }


}