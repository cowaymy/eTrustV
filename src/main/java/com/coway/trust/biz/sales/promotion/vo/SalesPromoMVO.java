package com.coway.trust.biz.sales.promotion.vo;

import java.io.Serializable;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0017D database table.
 * 
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesPromoMVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private int promoId;

	private int promoMtchId;
	
	private String promoCode;
	
	private String promoDesc;
	
	private int promoTypeId;
	
	private int promoAppTypeId;
	
	private int promoSrvMemPacId;
	
	private String promoDtFrom;
	
	private String promoDtEnd;
	
	private int promoStusId;
	
	private Date promoUpdDt;
	
	private int promoUpdUserId;
	
	private int promoIsTrialCnvr;
	
	private int promoPrcPrcnt;
	
	private int promoCustType;
	
	private int promoDiscType;
	
	private int promoRpfDiscAmt;
	
	private int promoDiscPeriodTp;
	
	private int promoDiscPeriod;
	
	private int promoFreesvcPeriodTp;
	
	private int promoAddDiscPrc;
	
	private int promoAddDiscPv;
	
	private int empChk;
	
	private int exTrade;

	private int crtUserId;
	
	private Date crtDt;
    
	private int updUserId;
    
    private Date updDt;
    
	private int isNew;

	private int megaDeal;

	public int getPromoId() {
		return promoId;
	}

	public void setPromoId(int promoId) {
		this.promoId = promoId;
	}

	public int getPromoMtchId() {
		return promoMtchId;
	}

	public void setPromoMtchId(int promoMtchId) {
		this.promoMtchId = promoMtchId;
	}

	public String getPromoCode() {
		return promoCode;
	}

	public void setPromoCode(String promoCode) {
		this.promoCode = promoCode;
	}

	public String getPromoDesc() {
		return promoDesc;
	}

	public void setPromoDesc(String promoDesc) {
		this.promoDesc = promoDesc;
	}

	public int getPromoTypeId() {
		return promoTypeId;
	}

	public void setPromoTypeId(int promoTypeId) {
		this.promoTypeId = promoTypeId;
	}

	public int getPromoAppTypeId() {
		return promoAppTypeId;
	}

	public void setPromoAppTypeId(int promoAppTypeId) {
		this.promoAppTypeId = promoAppTypeId;
	}

	public int getPromoSrvMemPacId() {
		return promoSrvMemPacId;
	}

	public void setPromoSrvMemPacId(int promoSrvMemPacId) {
		this.promoSrvMemPacId = promoSrvMemPacId;
	}

	public String getPromoDtFrom() {
		return promoDtFrom;
	}

	public void setPromoDtFrom(String promoDtFrom) {
		this.promoDtFrom = promoDtFrom;
	}

	public String getPromoDtEnd() {
		return promoDtEnd;
	}

	public void setPromoDtEnd(String promoDtEnd) {
		this.promoDtEnd = promoDtEnd;
	}

	public int getPromoStusId() {
		return promoStusId;
	}

	public void setPromoStusId(int promoStusId) {
		this.promoStusId = promoStusId;
	}

	public Date getPromoUpdDt() {
		return promoUpdDt;
	}

	public void setPromoUpdDt(Date promoUpdDt) {
		this.promoUpdDt = promoUpdDt;
	}

	public int getPromoUpdUserId() {
		return promoUpdUserId;
	}

	public void setPromoUpdUserId(int promoUpdUserId) {
		this.promoUpdUserId = promoUpdUserId;
	}

	public int getPromoIsTrialCnvr() {
		return promoIsTrialCnvr;
	}

	public void setPromoIsTrialCnvr(int promoIsTrialCnvr) {
		this.promoIsTrialCnvr = promoIsTrialCnvr;
	}

	public int getPromoPrcPrcnt() {
		return promoPrcPrcnt;
	}

	public void setPromoPrcPrcnt(int promoPrcPrcnt) {
		this.promoPrcPrcnt = promoPrcPrcnt;
	}

	public int getPromoCustType() {
		return promoCustType;
	}

	public void setPromoCustType(int promoCustType) {
		this.promoCustType = promoCustType;
	}

	public int getPromoDiscType() {
		return promoDiscType;
	}

	public void setPromoDiscType(int promoDiscType) {
		this.promoDiscType = promoDiscType;
	}

	public int getPromoRpfDiscAmt() {
		return promoRpfDiscAmt;
	}

	public void setPromoRpfDiscAmt(int promoRpfDiscAmt) {
		this.promoRpfDiscAmt = promoRpfDiscAmt;
	}

	public int getPromoDiscPeriodTp() {
		return promoDiscPeriodTp;
	}

	public void setPromoDiscPeriodTp(int promoDiscPeriodTp) {
		this.promoDiscPeriodTp = promoDiscPeriodTp;
	}

	public int getPromoDiscPeriod() {
		return promoDiscPeriod;
	}

	public void setPromoDiscPeriod(int promoDiscPeriod) {
		this.promoDiscPeriod = promoDiscPeriod;
	}

	public int getPromoFreesvcPeriodTp() {
		return promoFreesvcPeriodTp;
	}

	public void setPromoFreesvcPeriodTp(int promoFreesvcPeriodTp) {
		this.promoFreesvcPeriodTp = promoFreesvcPeriodTp;
	}

	public int getPromoAddDiscPrc() {
		return promoAddDiscPrc;
	}

	public void setPromoAddDiscPrc(int promoAddDiscPrc) {
		this.promoAddDiscPrc = promoAddDiscPrc;
	}

	public int getPromoAddDiscPv() {
		return promoAddDiscPv;
	}

	public void setPromoAddDiscPv(int promoAddDiscPv) {
		this.promoAddDiscPv = promoAddDiscPv;
	}

	public int getEmpChk() {
		return empChk;
	}

	public void setEmpChk(int empChk) {
		this.empChk = empChk;
	}

	public int getExTrade() {
		return exTrade;
	}

	public void setExTrade(int exTrade) {
		this.exTrade = exTrade;
	}

	public int getCrtUserId() {
		return crtUserId;
	}

	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}

	public Date getCrtDt() {
		return crtDt;
	}

	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}

	public int getUpdUserId() {
		return updUserId;
	}

	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}

	public Date getUpdDt() {
		return updDt;
	}

	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}

	public int getIsNew() {
		return isNew;
	}

	public void setIsNew(int isNew) {
		this.isNew = isNew;
	}

	public int getMegaDeal() {
		return megaDeal;
	}

	public void setMegaDeal(int megaDeal) {
		this.megaDeal = megaDeal;
	}
	
}