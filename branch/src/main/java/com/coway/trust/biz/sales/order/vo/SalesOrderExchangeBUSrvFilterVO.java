package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0006D database table.
 * 
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesOrderExchangeBUSrvFilterVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int buSrvFilterId;
	
	private int soExchgId;
	
	private int srvFilterId;

	public int getBuSrvFilterId() {
		return buSrvFilterId;
	}

	public void setBuSrvFilterId(int buSrvFilterId) {
		this.buSrvFilterId = buSrvFilterId;
	}

	public int getSoExchgId() {
		return soExchgId;
	}

	public void setSoExchgId(int soExchgId) {
		this.soExchgId = soExchgId;
	}

	public int getSrvFilterId() {
		return srvFilterId;
	}

	public void setSrvFilterId(int srvFilterId) {
		this.srvFilterId = srvFilterId;
	}

}