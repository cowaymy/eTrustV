package com.coway.trust.biz.api.vo.selfcarePortal;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class ProductDetailVO
    implements Serializable
{
    private Double membershipOutstanding;

    private Double productTotalOutstanding;

    private String installDate;

    private String lastServiceDate;

    private String salesOrdNo;

    private String appType;

    private String stkCode;

    private String serialNo;

    private String stkDesc;
    
    private String prodCat;

    private String add1;

    private String add2;

    private String postCode;

    private String areaName;

    private String stateName;

    private String billerCode;

    private int accountCode;

    private String jompayRef;

    private String monthlyRental;

    private String codyContact;

    private String codyName;

    private String mailCntName;

    private String mailCntTelNo;

    private String mailCntEmail;

    private String mailCntNric;

    private String serviceMode;
    
    private Double unBillAmt;

    public Double getMembershipOutstanding() {
		return membershipOutstanding;
	}

	public void setMembershipOutstanding(Double membershipOutstanding) {
		this.membershipOutstanding = membershipOutstanding;
	}

	public Double getProductTotalOutstanding() {
		return productTotalOutstanding;
	}

	public void setProductTotalOutstanding(Double productTotalOutstanding) {
		this.productTotalOutstanding = productTotalOutstanding;
	}

	public String getInstallDate() {
		return installDate;
	}

	public void setInstallDate(String installDate) {
		this.installDate = installDate;
	}

	public String getLastServiceDate() {
		return lastServiceDate;
	}

	public void setLastServiceDate(String lastServiceDate) {
		this.lastServiceDate = lastServiceDate;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getAppType() {
		return appType;
	}

	public void setAppType(String appType) {
		this.appType = appType;
	}

	public String getStkCode() {
		return stkCode;
	}

	public void setStkCode(String stkCode) {
		this.stkCode = stkCode;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getStkDesc() {
		return stkDesc;
	}

	public void setStkDesc(String stkDesc) {
		this.stkDesc = stkDesc;
	}

	public String getProdCat() {
		return prodCat;
	}

	public void setProdCat(String prodCat) {
		this.prodCat = prodCat;
	}

	public String getAdd1() {
		return add1;
	}

	public void setAdd1(String add1) {
		this.add1 = add1;
	}

	public String getAdd2() {
		return add2;
	}

	public void setAdd2(String add2) {
		this.add2 = add2;
	}

	public String getPostCode() {
		return postCode;
	}

	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}

	public String getAreaName() {
		return areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}

	public String getStateName() {
		return stateName;
	}

	public void setStateName(String stateName) {
		this.stateName = stateName;
	}

	public String getBillerCode() {
		return billerCode;
	}

	public void setBillerCode(String billerCode) {
		this.billerCode = billerCode;
	}

	public int getAccountCode() {
		return accountCode;
	}

	public void setAccountCode(int accountCode) {
		this.accountCode = accountCode;
	}

	public String getJompayRef() {
		return jompayRef;
	}

	public void setJompayRef(String jompayRef) {
		this.jompayRef = jompayRef;
	}

	public String getMonthlyRental() {
		return monthlyRental;
	}

	public void setMonthlyRental(String monthlyRental) {
		this.monthlyRental = monthlyRental;
	}

	public String getCodyContact() {
		return codyContact;
	}

	public void setCodyContact(String codyContact) {
		this.codyContact = codyContact;
	}

	public String getCodyName() {
		return codyName;
	}

	public void setCodyName(String codyName) {
		this.codyName = codyName;
	}

	public String getMailCntName() {
		return mailCntName;
	}

	public void setMailCntName(String mailCntName) {
		this.mailCntName = mailCntName;
	}

	public String getMailCntTelNo() {
		return mailCntTelNo;
	}

	public void setMailCntTelNo(String mailCntTelNo) {
		this.mailCntTelNo = mailCntTelNo;
	}

	public String getMailCntEmail() {
		return mailCntEmail;
	}

	public void setMailCntEmail(String mailCntEmail) {
		this.mailCntEmail = mailCntEmail;
	}

	public String getMailCntNric() {
		return mailCntNric;
	}

	public void setMailCntNric(String mailCntNric) {
		this.mailCntNric = mailCntNric;
	}

	public String getServiceMode() {
		return serviceMode;
	}

	public void setServiceMode(String serviceMode) {
		this.serviceMode = serviceMode;
	}

	public Double getUnBillAmt() {
		return unBillAmt;
	}

	public void setUnBillAmt(Double unBillAmt) {
		this.unBillAmt = unBillAmt;
	}

	@SuppressWarnings("unchecked")
    public static ProductDetailVO create( EgovMap detList )
    {
        // TODO Auto-generated method stub
        return BeanConverter.toBean( detList, ProductDetailVO.class );
    }
}
