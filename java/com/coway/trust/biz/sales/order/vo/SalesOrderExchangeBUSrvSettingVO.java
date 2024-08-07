package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0008D database table.
 * 
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesOrderExchangeBUSrvSettingVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int buSrvSetngId;
	
	private int soExchgId;
	
	private int srvSettId;

	public int getBuSrvSetngId() {
		return buSrvSetngId;
	}

	public void setBuSrvSetngId(int buSrvSetngId) {
		this.buSrvSetngId = buSrvSetngId;
	}

	public int getSoExchgId() {
		return soExchgId;
	}

	public void setSoExchgId(int soExchgId) {
		this.soExchgId = soExchgId;
	}

	public int getSrvSettId() {
		return srvSettId;
	}

	public void setSrvSettId(int srvSettId) {
		this.srvSettId = srvSettId;
	}
	
}