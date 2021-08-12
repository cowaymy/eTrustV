package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the PAY0033D database table.
 * 
 */
public class AccTaxInvoiceOutrightVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int taxInvcId;
	
	private String taxInvcRefNo;
	
	private String taxInvcRefDt;
	
	private String taxInvcCustName;
	
	private String taxInvcCntcPerson;
	
	private String taxInvcAddr1;
	
	private String taxInvcAddr2;
	
	private String taxInvcAddr3;
	
	private String taxInvcAddr4;
	
	private String taxInvcPostCode;
	
	private String taxInvcStateName;
	
	private String taxInvcCnty;
	
	private int taxInvcTaskId;
	
	private String taxInvcCrtDt;
	
	private String taxInvcRem;
	
	private BigDecimal taxInvcChrg;
	
	private BigDecimal taxInvcOverdu;
	
	private BigDecimal taxInvcAmtDue;
	
	private String taxInvcPoNo;
	
	private String areaId;
	
	private String addrDtl;
	
	private String street;

	public int getTaxInvcId() {
		return taxInvcId;
	}

	public void setTaxInvcId(int taxInvcId) {
		this.taxInvcId = taxInvcId;
	}

	public String getTaxInvcRefNo() {
		return taxInvcRefNo;
	}

	public void setTaxInvcRefNo(String taxInvcRefNo) {
		this.taxInvcRefNo = taxInvcRefNo;
	}

	public String getTaxInvcRefDt() {
		return taxInvcRefDt;
	}

	public void setTaxInvcRefDt(String taxInvcRefDt) {
		this.taxInvcRefDt = taxInvcRefDt;
	}

	public String getTaxInvcCustName() {
		return taxInvcCustName;
	}

	public void setTaxInvcCustName(String taxInvcCustName) {
		this.taxInvcCustName = taxInvcCustName;
	}

	public String getTaxInvcCntcPerson() {
		return taxInvcCntcPerson;
	}

	public void setTaxInvcCntcPerson(String taxInvcCntcPerson) {
		this.taxInvcCntcPerson = taxInvcCntcPerson;
	}

	public String getTaxInvcAddr1() {
		return taxInvcAddr1;
	}

	public void setTaxInvcAddr1(String taxInvcAddr1) {
		this.taxInvcAddr1 = taxInvcAddr1;
	}

	public String getTaxInvcAddr2() {
		return taxInvcAddr2;
	}

	public void setTaxInvcAddr2(String taxInvcAddr2) {
		this.taxInvcAddr2 = taxInvcAddr2;
	}

	public String getTaxInvcAddr3() {
		return taxInvcAddr3;
	}

	public void setTaxInvcAddr3(String taxInvcAddr3) {
		this.taxInvcAddr3 = taxInvcAddr3;
	}

	public String getTaxInvcAddr4() {
		return taxInvcAddr4;
	}

	public void setTaxInvcAddr4(String taxInvcAddr4) {
		this.taxInvcAddr4 = taxInvcAddr4;
	}

	public String getTaxInvcPostCode() {
		return taxInvcPostCode;
	}

	public void setTaxInvcPostCode(String taxInvcPostCode) {
		this.taxInvcPostCode = taxInvcPostCode;
	}

	public String getTaxInvcStateName() {
		return taxInvcStateName;
	}

	public void setTaxInvcStateName(String taxInvcStateName) {
		this.taxInvcStateName = taxInvcStateName;
	}

	public String getTaxInvcCnty() {
		return taxInvcCnty;
	}

	public void setTaxInvcCnty(String taxInvcCnty) {
		this.taxInvcCnty = taxInvcCnty;
	}

	public int getTaxInvcTaskId() {
		return taxInvcTaskId;
	}

	public void setTaxInvcTaskId(int taxInvcTaskId) {
		this.taxInvcTaskId = taxInvcTaskId;
	}

	public String getTaxInvcCrtDt() {
		return taxInvcCrtDt;
	}

	public void setTaxInvcCrtDt(String taxInvcCrtDt) {
		this.taxInvcCrtDt = taxInvcCrtDt;
	}

	public String getTaxInvcRem() {
		return taxInvcRem;
	}

	public void setTaxInvcRem(String taxInvcRem) {
		this.taxInvcRem = taxInvcRem;
	}

	public BigDecimal getTaxInvcChrg() {
		return taxInvcChrg;
	}

	public void setTaxInvcChrg(BigDecimal taxInvcChrg) {
		this.taxInvcChrg = taxInvcChrg;
	}

	public BigDecimal getTaxInvcOverdu() {
		return taxInvcOverdu;
	}

	public void setTaxInvcOverdu(BigDecimal taxInvcOverdu) {
		this.taxInvcOverdu = taxInvcOverdu;
	}

	public BigDecimal getTaxInvcAmtDue() {
		return taxInvcAmtDue;
	}

	public void setTaxInvcAmtDue(BigDecimal taxInvcAmtDue) {
		this.taxInvcAmtDue = taxInvcAmtDue;
	}

	public String getTaxInvcPoNo() {
		return taxInvcPoNo;
	}

	public void setTaxInvcPoNo(String taxInvcPoNo) {
		this.taxInvcPoNo = taxInvcPoNo;
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