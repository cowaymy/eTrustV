package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0005D database table.
 * 
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesOrderExchangeBUSrvConfigVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int buSrvConfigId;
	
	private int soExchgId;
	
	private int srvConfigId;

	public int getBuSrvConfigId() {
		return buSrvConfigId;
	}

	public void setBuSrvConfigId(int buSrvConfigId) {
		this.buSrvConfigId = buSrvConfigId;
	}

	public int getSoExchgId() {
		return soExchgId;
	}

	public void setSoExchgId(int soExchgId) {
		this.soExchgId = soExchgId;
	}

	public int getSrvConfigId() {
		return srvConfigId;
	}

	public void setSrvConfigId(int srvConfigId) {
		this.srvConfigId = srvConfigId;
	}
	
}