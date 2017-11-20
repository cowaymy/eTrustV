package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;


/**
 * The persistent class for the SAL0087D database table.
 * 
 */
public class SrvConfigFilterVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int srvFilterId;

	private int srvConfigId;

	private String srvFilterCrtDt;

	private int srvFilterCrtUserId;

	private String srvFilterExprDt;

	private int srvFilterPriod;

	private String srvFilterPrvChgDt;

	private String srvFilterRem;

	private int srvFilterStkId;

	private int srvFilterStusId;

	private String srvFilterUpdDt;

	private int srvFilterUpdUserId;
	
	private int srvFilterLastSerial;
	
	private int srvFilterPrevSerial;
	
	public int getSrvFilterLastSerial() {
		return srvFilterLastSerial;
	}

	public void setSrvFilterLastSerial(int srvFilterLastSerial) {
		this.srvFilterLastSerial = srvFilterLastSerial;
	}

	public int getSrvFilterPrevSerial() {
		return srvFilterPrevSerial;
	}

	public void setSrvFilterPrevSerial(int srvFilterPrevSerial) {
		this.srvFilterPrevSerial = srvFilterPrevSerial;
	}



	public SrvConfigFilterVO() {
	}

	public int getSrvFilterId() {
		return srvFilterId;
	}

	public void setSrvFilterId(int srvFilterId) {
		this.srvFilterId = srvFilterId;
	}

	public int getSrvConfigId() {
		return srvConfigId;
	}

	public void setSrvConfigId(int srvConfigId) {
		this.srvConfigId = srvConfigId;
	}

	public String getSrvFilterCrtDt() {
		return srvFilterCrtDt;
	}

	public void setSrvFilterCrtDt(String srvFilterCrtDt) {
		this.srvFilterCrtDt = srvFilterCrtDt;
	}

	public int getSrvFilterCrtUserId() {
		return srvFilterCrtUserId;
	}

	public void setSrvFilterCrtUserId(int srvFilterCrtUserId) {
		this.srvFilterCrtUserId = srvFilterCrtUserId;
	}

	public String getSrvFilterExprDt() {
		return srvFilterExprDt;
	}

	public void setSrvFilterExprDt(String srvFilterExprDt) {
		this.srvFilterExprDt = srvFilterExprDt;
	}

	public int getSrvFilterPriod() {
		return srvFilterPriod;
	}

	public void setSrvFilterPriod(int srvFilterPriod) {
		this.srvFilterPriod = srvFilterPriod;
	}

	public String getSrvFilterPrvChgDt() {
		return srvFilterPrvChgDt;
	}

	public void setSrvFilterPrvChgDt(String srvFilterPrvChgDt) {
		this.srvFilterPrvChgDt = srvFilterPrvChgDt;
	}

	public String getSrvFilterRem() {
		return srvFilterRem;
	}

	public void setSrvFilterRem(String srvFilterRem) {
		this.srvFilterRem = srvFilterRem;
	}

	public int getSrvFilterStkId() {
		return srvFilterStkId;
	}

	public void setSrvFilterStkId(int srvFilterStkId) {
		this.srvFilterStkId = srvFilterStkId;
	}

	public int getSrvFilterStusId() {
		return srvFilterStusId;
	}

	public void setSrvFilterStusId(int srvFilterStusId) {
		this.srvFilterStusId = srvFilterStusId;
	}

	public String getSrvFilterUpdDt() {
		return srvFilterUpdDt;
	}

	public void setSrvFilterUpdDt(String srvFilterUpdDt) {
		this.srvFilterUpdDt = srvFilterUpdDt;
	}

	public int getSrvFilterUpdUserId() {
		return srvFilterUpdUserId;
	}

	public void setSrvFilterUpdUserId(int srvFilterUpdUserId) {
		this.srvFilterUpdUserId = srvFilterUpdUserId;
	}

}