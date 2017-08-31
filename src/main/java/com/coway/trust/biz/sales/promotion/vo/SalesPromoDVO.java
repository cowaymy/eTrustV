package com.coway.trust.biz.sales.promotion.vo;

import java.io.Serializable;
import java.util.Date;


/**
 * The persistent class for the SAL0018D database table.
 * 
 */
public class SalesPromoDVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private int promoItmId;
	
	private int promoId;
	
	private int promoItmStkId;
	
	private int promoItmCurId;
	
	private int promoItmPrc;
	
	private int promoItmPv;
	
	private int promoItmStusId;
	
	private int promoItmUpdUserId;
	
	private Date promoItmUpdDt;
	
	private int promoItmRental;
	
	private int promoItmRentPriod;
	
	private int promoItmObligPriod;
	
	public int getPromoItmId() {
		return promoItmId;
	}
	
	public void setPromoItmId(int promoItmId) {
		this.promoItmId = promoItmId;
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
	
}