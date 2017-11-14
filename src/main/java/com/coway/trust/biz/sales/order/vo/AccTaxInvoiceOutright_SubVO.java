package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the PAY0034D database table.
 * 
 */
public class AccTaxInvoiceOutright_SubVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int invcItmId;
	
	private int taxInvcId;
	
	private String invcItmOrdNo;
	
	private String invcItmPoNo;
	
	private int invcItmGstRate;
	
	private BigDecimal invcItmGstTxs;
	
	private BigDecimal invcItmAmtDue;
	
	private BigDecimal invcItmRentalFee;
	
	private String invcItmProductCtgry;
	
	private String invcItmProductModel;
	
	private String invcItmProductSerialNo;
	
	private String invcItmAdd1;
	
	private String invcItmAdd2;
	
	private String invcItmAdd3;
	
	private String invcItmPostCode;
	
	private String invcItmStateName;
	
	private String invcItmCnty;
	
	private BigDecimal invcItmFeesGstTxs;
	
	private BigDecimal invcItmFeesAmtDue;
	
	private BigDecimal invcItmFeesChrg;
	
	private String areaId;
	
	private String addrDtl;
	
	private String street;

	public int getInvcItmId() {
		return invcItmId;
	}

	public void setInvcItmId(int invcItmId) {
		this.invcItmId = invcItmId;
	}

	public int getTaxInvcId() {
		return taxInvcId;
	}

	public void setTaxInvcId(int taxInvcId) {
		this.taxInvcId = taxInvcId;
	}

	public String getInvcItmOrdNo() {
		return invcItmOrdNo;
	}

	public void setInvcItmOrdNo(String invcItmOrdNo) {
		this.invcItmOrdNo = invcItmOrdNo;
	}

	public String getInvcItmPoNo() {
		return invcItmPoNo;
	}

	public void setInvcItmPoNo(String invcItmPoNo) {
		this.invcItmPoNo = invcItmPoNo;
	}

	public int getInvcItmGstRate() {
		return invcItmGstRate;
	}

	public void setInvcItmGstRate(int invcItmGstRate) {
		this.invcItmGstRate = invcItmGstRate;
	}

	public BigDecimal getInvcItmGstTxs() {
		return invcItmGstTxs;
	}

	public void setInvcItmGstTxs(BigDecimal invcItmGstTxs) {
		this.invcItmGstTxs = invcItmGstTxs;
	}

	public BigDecimal getInvcItmAmtDue() {
		return invcItmAmtDue;
	}

	public void setInvcItmAmtDue(BigDecimal invcItmAmtDue) {
		this.invcItmAmtDue = invcItmAmtDue;
	}

	public BigDecimal getInvcItmRentalFee() {
		return invcItmRentalFee;
	}

	public void setInvcItmRentalFee(BigDecimal invcItmRentalFee) {
		this.invcItmRentalFee = invcItmRentalFee;
	}

	public String getInvcItmProductCtgry() {
		return invcItmProductCtgry;
	}

	public void setInvcItmProductCtgry(String invcItmProductCtgry) {
		this.invcItmProductCtgry = invcItmProductCtgry;
	}

	public String getInvcItmProductModel() {
		return invcItmProductModel;
	}

	public void setInvcItmProductModel(String invcItmProductModel) {
		this.invcItmProductModel = invcItmProductModel;
	}

	public String getInvcItmProductSerialNo() {
		return invcItmProductSerialNo;
	}

	public void setInvcItmProductSerialNo(String invcItmProductSerialNo) {
		this.invcItmProductSerialNo = invcItmProductSerialNo;
	}

	public String getInvcItmAdd1() {
		return invcItmAdd1;
	}

	public void setInvcItmAdd1(String invcItmAdd1) {
		this.invcItmAdd1 = invcItmAdd1;
	}

	public String getInvcItmAdd2() {
		return invcItmAdd2;
	}

	public void setInvcItmAdd2(String invcItmAdd2) {
		this.invcItmAdd2 = invcItmAdd2;
	}

	public String getInvcItmAdd3() {
		return invcItmAdd3;
	}

	public void setInvcItmAdd3(String invcItmAdd3) {
		this.invcItmAdd3 = invcItmAdd3;
	}

	public String getInvcItmPostCode() {
		return invcItmPostCode;
	}

	public void setInvcItmPostCode(String invcItmPostCode) {
		this.invcItmPostCode = invcItmPostCode;
	}

	public String getInvcItmStateName() {
		return invcItmStateName;
	}

	public void setInvcItmStateName(String invcItmStateName) {
		this.invcItmStateName = invcItmStateName;
	}

	public String getInvcItmCnty() {
		return invcItmCnty;
	}

	public void setInvcItmCnty(String invcItmCnty) {
		this.invcItmCnty = invcItmCnty;
	}

	public BigDecimal getInvcItmFeesGstTxs() {
		return invcItmFeesGstTxs;
	}

	public void setInvcItmFeesGstTxs(BigDecimal invcItmFeesGstTxs) {
		this.invcItmFeesGstTxs = invcItmFeesGstTxs;
	}

	public BigDecimal getInvcItmFeesAmtDue() {
		return invcItmFeesAmtDue;
	}

	public void setInvcItmFeesAmtDue(BigDecimal invcItmFeesAmtDue) {
		this.invcItmFeesAmtDue = invcItmFeesAmtDue;
	}

	public BigDecimal getInvcItmFeesChrg() {
		return invcItmFeesChrg;
	}

	public void setInvcItmFeesChrg(BigDecimal invcItmFeesChrg) {
		this.invcItmFeesChrg = invcItmFeesChrg;
	}

	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}

	public String getAddrDtl() {
		return addrDtl;
	}

	public void setAddrDtl(String addrDtl) {
		this.addrDtl = addrDtl;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

}