package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0090D database table.
 * 
 */
public class SrvConfigurationVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int srvConfigId;

	private int srvBsGen;

	private int srvBsWeek;

	private int srvCodyId;

	private Date srvCrtDt;

	private int srvCrtUserId;

	private String srvPrevDt;

	private String srvRem;

	private int srvSoId;

	private int srvStusId;

	private Date srvUpdDt;

	private int srvUpdUserId;

	public SrvConfigurationVO() {
	}

	public int getSrvConfigId() {
		return srvConfigId;
	}

	public void setSrvConfigId(int srvConfigId) {
		this.srvConfigId = srvConfigId;
	}

	public int getSrvBsGen() {
		return srvBsGen;
	}

	public void setSrvBsGen(int srvBsGen) {
		this.srvBsGen = srvBsGen;
	}

	public int getSrvBsWeek() {
		return srvBsWeek;
	}

	public void setSrvBsWeek(int srvBsWeek) {
		this.srvBsWeek = srvBsWeek;
	}

	public int getSrvCodyId() {
		return srvCodyId;
	}

	public void setSrvCodyId(int srvCodyId) {
		this.srvCodyId = srvCodyId;
	}

	public Date getSrvCrtDt() {
		return srvCrtDt;
	}

	public void setSrvCrtDt(Date srvCrtDt) {
		this.srvCrtDt = srvCrtDt;
	}

	public int getSrvCrtUserId() {
		return srvCrtUserId;
	}

	public void setSrvCrtUserId(int srvCrtUserId) {
		this.srvCrtUserId = srvCrtUserId;
	}

	public String getSrvPrevDt() {
		return srvPrevDt;
	}

	public void setSrvPrevDt(String srvPrevDt) {
		this.srvPrevDt = srvPrevDt;
	}

	public String getSrvRem() {
		return srvRem;
	}

	public void setSrvRem(String srvRem) {
		this.srvRem = srvRem;
	}

	public int getSrvSoId() {
		return srvSoId;
	}

	public void setSrvSoId(int srvSoId) {
		this.srvSoId = srvSoId;
	}

	public int getSrvStusId() {
		return srvStusId;
	}

	public void setSrvStusId(int srvStusId) {
		this.srvStusId = srvStusId;
	}

	public Date getSrvUpdDt() {
		return srvUpdDt;
	}

	public void setSrvUpdDt(Date srvUpdDt) {
		this.srvUpdDt = srvUpdDt;
	}

	public int getSrvUpdUserId() {
		return srvUpdUserId;
	}

	public void setSrvUpdUserId(int srvUpdUserId) {
		this.srvUpdUserId = srvUpdUserId;
	}

}