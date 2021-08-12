package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the PAY0035D database table.
 * 
 */
public class AccTradeLedgerVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int tradeRunId;

	private int tradeId;
	
	private int tradeSoId;
	
	private String tradeDocNo;
	
	private int tradeDocTypeId;
	
	private String tradeDtTm;
	
	private BigDecimal tradeAmt;
	
	private String tradeBatchNo;
	
	private int tradeInstNo;
	
	private int tradeUpdUserId;
	
	private String tradeUpdDt;
	
	private int tradeIsSync;
	
	private BigDecimal r01;

	public int getTradeRunId() {
		return tradeRunId;
	}

	public void setTradeRunId(int tradeRunId) {
		this.tradeRunId = tradeRunId;
	}

	public int getTradeId() {
		return tradeId;
	}

	public void setTradeId(int tradeId) {
		this.tradeId = tradeId;
	}

	public int getTradeSoId() {
		return tradeSoId;
	}

	public void setTradeSoId(int tradeSoId) {
		this.tradeSoId = tradeSoId;
	}

	public String getTradeDocNo() {
		return tradeDocNo;
	}

	public void setTradeDocNo(String tradeDocNo) {
		this.tradeDocNo = tradeDocNo;
	}

	public int getTradeDocTypeId() {
		return tradeDocTypeId;
	}

	public void setTradeDocTypeId(int tradeDocTypeId) {
		this.tradeDocTypeId = tradeDocTypeId;
	}

	public String getTradeDtTm() {
		return tradeDtTm;
	}

	public void setTradeDtTm(String tradeDtTm) {
		this.tradeDtTm = tradeDtTm;
	}

	public BigDecimal getTradeAmt() {
		return tradeAmt;
	}

	public void setTradeAmt(BigDecimal tradeAmt) {
		this.tradeAmt = tradeAmt;
	}

	public String getTradeBatchNo() {
		return tradeBatchNo;
	}

	public void setTradeBatchNo(String tradeBatchNo) {
		this.tradeBatchNo = tradeBatchNo;
	}

	public int getTradeInstNo() {
		return tradeInstNo;
	}

	public void setTradeInstNo(int tradeInstNo) {
		this.tradeInstNo = tradeInstNo;
	}

	public int getTradeUpdUserId() {
		return tradeUpdUserId;
	}

	public void setTradeUpdUserId(int tradeUpdUserId) {
		this.tradeUpdUserId = tradeUpdUserId;
	}

	public String getTradeUpdDt() {
		return tradeUpdDt;
	}

	public void setTradeUpdDt(String tradeUpdDt) {
		this.tradeUpdDt = tradeUpdDt;
	}

	public int getTradeIsSync() {
		return tradeIsSync;
	}

	public void setTradeIsSync(int tradeIsSync) {
		this.tradeIsSync = tradeIsSync;
	}

	public BigDecimal getR01() {
		return r01;
	}

	public void setR01(BigDecimal r01) {
		this.r01 = r01;
	}

}