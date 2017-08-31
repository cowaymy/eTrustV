package com.coway.trust.biz.sales.promotion.vo;

import java.io.Serializable;
import java.util.Date;


/**
 * The persistent class for the SAL0019D database table.
 * 
 */
public class SalesPromoFreeGiftVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private int promoFreeGiftId;
	
	private int promoFreeGiftPromoId;
	
	private int promoFreeGiftStkId;
	
	private int promoFreeGiftStusId;
	
	private Date promoFreeGiftStartDt;
	
	private Date promoFreeGiftExprDt;
	
	private int promoFreeGiftCrtUserId;
	
	private Date promoFreeGiftCrtDt;

	public int getPromoFreeGiftId() {
		return promoFreeGiftId;
	}

	public void setPromoFreeGiftId(int promoFreeGiftId) {
		this.promoFreeGiftId = promoFreeGiftId;
	}

	public int getPromoFreeGiftPromoId() {
		return promoFreeGiftPromoId;
	}

	public void setPromoFreeGiftPromoId(int promoFreeGiftPromoId) {
		this.promoFreeGiftPromoId = promoFreeGiftPromoId;
	}

	public int getPromoFreeGiftStkId() {
		return promoFreeGiftStkId;
	}

	public void setPromoFreeGiftStkId(int promoFreeGiftStkId) {
		this.promoFreeGiftStkId = promoFreeGiftStkId;
	}

	public int getPromoFreeGiftStusId() {
		return promoFreeGiftStusId;
	}

	public void setPromoFreeGiftStusId(int promoFreeGiftStusId) {
		this.promoFreeGiftStusId = promoFreeGiftStusId;
	}

	public Date getPromoFreeGiftStartDt() {
		return promoFreeGiftStartDt;
	}

	public void setPromoFreeGiftStartDt(Date promoFreeGiftStartDt) {
		this.promoFreeGiftStartDt = promoFreeGiftStartDt;
	}

	public Date getPromoFreeGiftExprDt() {
		return promoFreeGiftExprDt;
	}

	public void setPromoFreeGiftExprDt(Date promoFreeGiftExprDt) {
		this.promoFreeGiftExprDt = promoFreeGiftExprDt;
	}

	public int getPromoFreeGiftCrtUserId() {
		return promoFreeGiftCrtUserId;
	}

	public void setPromoFreeGiftCrtUserId(int promoFreeGiftCrtUserId) {
		this.promoFreeGiftCrtUserId = promoFreeGiftCrtUserId;
	}

	public Date getPromoFreeGiftCrtDt() {
		return promoFreeGiftCrtDt;
	}

	public void setPromoFreeGiftCrtDt(Date promoFreeGiftCrtDt) {
		this.promoFreeGiftCrtDt = promoFreeGiftCrtDt;
	}
	
}