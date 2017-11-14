package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0013D database table.
 * 
 */
public class SalesOrderSchemeConversionVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int cnvrId;
	
	private int salesOrdId;
	
	private int cnvrSchemeId;
	
	private int salesAppTypeId;
	
	private int salesOrdPromoId;
	
	private BigDecimal salesOrdPreRpf;
	
	private BigDecimal salesOrdPrePrc;
	
	private BigDecimal salesOrdPrePv;
	
	private int salesOrdPreSrvFreq;
	
	private BigDecimal salesOrdNwRpf;
	
	private BigDecimal salesOrdNwPrc;
	
	private int salesOrdNwSrvFreq;
	
	private BigDecimal salesOrdNwPv;
	
	private int cnvrStusId;
	
	private String cnvrRem;
	
	private int cnvrCrtUserId;
	
	private String cnvrCrtDt;
	
	private String cnvrUpdDt;
	
	private int cnvrUpdUserId;

	public int getCnvrId() {
		return cnvrId;
	}

	public void setCnvrId(int cnvrId) {
		this.cnvrId = cnvrId;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public int getCnvrSchemeId() {
		return cnvrSchemeId;
	}

	public void setCnvrSchemeId(int cnvrSchemeId) {
		this.cnvrSchemeId = cnvrSchemeId;
	}

	public int getSalesAppTypeId() {
		return salesAppTypeId;
	}

	public void setSalesAppTypeId(int salesAppTypeId) {
		this.salesAppTypeId = salesAppTypeId;
	}

	public int getSalesOrdPromoId() {
		return salesOrdPromoId;
	}

	public void setSalesOrdPromoId(int salesOrdPromoId) {
		this.salesOrdPromoId = salesOrdPromoId;
	}

	public BigDecimal getSalesOrdPreRpf() {
		return salesOrdPreRpf;
	}

	public void setSalesOrdPreRpf(BigDecimal salesOrdPreRpf) {
		this.salesOrdPreRpf = salesOrdPreRpf;
	}

	public BigDecimal getSalesOrdPrePrc() {
		return salesOrdPrePrc;
	}

	public void setSalesOrdPrePrc(BigDecimal salesOrdPrePrc) {
		this.salesOrdPrePrc = salesOrdPrePrc;
	}

	public BigDecimal getSalesOrdPrePv() {
		return salesOrdPrePv;
	}

	public void setSalesOrdPrePv(BigDecimal salesOrdPrePv) {
		this.salesOrdPrePv = salesOrdPrePv;
	}

	public int getSalesOrdPreSrvFreq() {
		return salesOrdPreSrvFreq;
	}

	public void setSalesOrdPreSrvFreq(int salesOrdPreSrvFreq) {
		this.salesOrdPreSrvFreq = salesOrdPreSrvFreq;
	}

	public BigDecimal getSalesOrdNwRpf() {
		return salesOrdNwRpf;
	}

	public void setSalesOrdNwRpf(BigDecimal salesOrdNwRpf) {
		this.salesOrdNwRpf = salesOrdNwRpf;
	}

	public BigDecimal getSalesOrdNwPrc() {
		return salesOrdNwPrc;
	}

	public void setSalesOrdNwPrc(BigDecimal salesOrdNwPrc) {
		this.salesOrdNwPrc = salesOrdNwPrc;
	}

	public int getSalesOrdNwSrvFreq() {
		return salesOrdNwSrvFreq;
	}

	public void setSalesOrdNwSrvFreq(int salesOrdNwSrvFreq) {
		this.salesOrdNwSrvFreq = salesOrdNwSrvFreq;
	}

	public BigDecimal getSalesOrdNwPv() {
		return salesOrdNwPv;
	}

	public void setSalesOrdNwPv(BigDecimal salesOrdNwPv) {
		this.salesOrdNwPv = salesOrdNwPv;
	}

	public int getCnvrStusId() {
		return cnvrStusId;
	}

	public void setCnvrStusId(int cnvrStusId) {
		this.cnvrStusId = cnvrStusId;
	}

	public String getCnvrRem() {
		return cnvrRem;
	}

	public void setCnvrRem(String cnvrRem) {
		this.cnvrRem = cnvrRem;
	}

	public int getCnvrCrtUserId() {
		return cnvrCrtUserId;
	}

	public void setCnvrCrtUserId(int cnvrCrtUserId) {
		this.cnvrCrtUserId = cnvrCrtUserId;
	}

	public String getCnvrCrtDt() {
		return cnvrCrtDt;
	}

	public void setCnvrCrtDt(String cnvrCrtDt) {
		this.cnvrCrtDt = cnvrCrtDt;
	}

	public String getCnvrUpdDt() {
		return cnvrUpdDt;
	}

	public void setCnvrUpdDt(String cnvrUpdDt) {
		this.cnvrUpdDt = cnvrUpdDt;
	}

	public int getCnvrUpdUserId() {
		return cnvrUpdUserId;
	}

	public void setCnvrUpdUserId(int cnvrUpdUserId) {
		this.cnvrUpdUserId = cnvrUpdUserId;
	}
		
}