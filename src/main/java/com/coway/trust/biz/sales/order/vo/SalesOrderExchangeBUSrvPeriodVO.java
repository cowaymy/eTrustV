package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0007D database table.
 * 
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesOrderExchangeBUSrvPeriodVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int buSrvPriodId;
	
	private int soExchgId;
	
	private int srvPrdId;

	public int getBuSrvPriodId() {
		return buSrvPriodId;
	}

	public void setBuSrvPriodId(int buSrvPriodId) {
		this.buSrvPriodId = buSrvPriodId;
	}

	public int getSoExchgId() {
		return soExchgId;
	}

	public void setSoExchgId(int soExchgId) {
		this.soExchgId = soExchgId;
	}

	public int getSrvPrdId() {
		return srvPrdId;
	}

	public void setSrvPrdId(int srvPrdId) {
		this.srvPrdId = srvPrdId;
	}
	
}