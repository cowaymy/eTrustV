package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0088D database table.
 * 
 */
public class SrvConfigPeriodVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int srvPrdId;

	private int srvConfigId;

	private int srvMbrshId;

	private int srvPrdCntrctId;

	private Date srvPrdCrtDt;

	private int srvPrdCrtUserId;

	private int srvPrdDur;

	private Date srvPrdExprDt;

	private String srvPrdRem;

	private Date srvPrdStartDt;

	private int srvPrdStusId;

	private Date srvPrdUpdDt;

	private int srvPrdUpdUserId;

	public SrvConfigPeriodVO() {
	}

	public int getSrvPrdId() {
		return srvPrdId;
	}

	public void setSrvPrdId(int srvPrdId) {
		this.srvPrdId = srvPrdId;
	}

	public int getSrvConfigId() {
		return srvConfigId;
	}

	public void setSrvConfigId(int srvConfigId) {
		this.srvConfigId = srvConfigId;
	}

	public int getSrvMbrshId() {
		return srvMbrshId;
	}

	public void setSrvMbrshId(int srvMbrshId) {
		this.srvMbrshId = srvMbrshId;
	}

	public int getSrvPrdCntrctId() {
		return srvPrdCntrctId;
	}

	public void setSrvPrdCntrctId(int srvPrdCntrctId) {
		this.srvPrdCntrctId = srvPrdCntrctId;
	}

	public Date getSrvPrdCrtDt() {
		return srvPrdCrtDt;
	}

	public void setSrvPrdCrtDt(Date srvPrdCrtDt) {
		this.srvPrdCrtDt = srvPrdCrtDt;
	}

	public int getSrvPrdCrtUserId() {
		return srvPrdCrtUserId;
	}

	public void setSrvPrdCrtUserId(int srvPrdCrtUserId) {
		this.srvPrdCrtUserId = srvPrdCrtUserId;
	}

	public int getSrvPrdDur() {
		return srvPrdDur;
	}

	public void setSrvPrdDur(int srvPrdDur) {
		this.srvPrdDur = srvPrdDur;
	}

	public Date getSrvPrdExprDt() {
		return srvPrdExprDt;
	}

	public void setSrvPrdExprDt(Date srvPrdExprDt) {
		this.srvPrdExprDt = srvPrdExprDt;
	}

	public String getSrvPrdRem() {
		return srvPrdRem;
	}

	public void setSrvPrdRem(String srvPrdRem) {
		this.srvPrdRem = srvPrdRem;
	}

	public Date getSrvPrdStartDt() {
		return srvPrdStartDt;
	}

	public void setSrvPrdStartDt(Date srvPrdStartDt) {
		this.srvPrdStartDt = srvPrdStartDt;
	}

	public int getSrvPrdStusId() {
		return srvPrdStusId;
	}

	public void setSrvPrdStusId(int srvPrdStusId) {
		this.srvPrdStusId = srvPrdStusId;
	}

	public Date getSrvPrdUpdDt() {
		return srvPrdUpdDt;
	}

	public void setSrvPrdUpdDt(Date srvPrdUpdDt) {
		this.srvPrdUpdDt = srvPrdUpdDt;
	}

	public int getSrvPrdUpdUserId() {
		return srvPrdUpdUserId;
	}

	public void setSrvPrdUpdUserId(int srvPrdUpdUserId) {
		this.srvPrdUpdUserId = srvPrdUpdUserId;
	}

}