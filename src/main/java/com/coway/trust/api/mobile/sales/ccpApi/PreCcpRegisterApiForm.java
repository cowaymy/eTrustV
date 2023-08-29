package com.coway.trust.api.mobile.sales.ccpApi;

import java.util.HashMap;
import java.util.Map;
import com.coway.trust.util.BeanConverter;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : PreCcpRegisterApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             		Author          			Description
 * -------------    	-----------     			-------------
 * 2023. 02. 08.    Low Kim Ching   	First creation
 * </pre>
 */
@ApiModel(value = "PreCcpRegisterApiForm", description = "PreCcpRegisterApiForm")
public class PreCcpRegisterApiForm {

    public static PreCcpRegisterApiForm create(Map<String, Object> preCcpMap) {
        return BeanConverter.toBean(preCcpMap, PreCcpRegisterApiForm.class);
    }

	public static Map<String, Object> createMap(PreCcpRegisterApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("selectType", vo.getSelectType());
		params.put("selectKeyword", vo.getSelectKeyword());
        params.put("reqstDtFrom", vo.getReqstDtFrom());
        params.put("reqstDtTo", vo.getReqstDtTo());
        params.put("custId", vo.getCustId());
        params.put("regId", vo.getRegId());

        params.put("salesOrdNo", vo.getSalesOrdNo());
		params.put("rentStus", vo.getRentStus());
		params.put("paymentMode", vo.getPaymentMode());
		params.put("outstandingAmt", vo.getOutstandingAmt());
		params.put("unbillAmt", vo.getUnbillAmt());
		return params;
	}

	private String selectType;
	private String selectKeyword;
	private int custId;
    private String regId;
    private String yymmdd;
    private String yyyymmdd;
    private String ddmmyyyy;
    private int memId;
    private String reqstDtFrom;
    private String reqstDtTo;

    private String name;
    private String nric;
    private String mobileNo;
    private String email;

    private String customerName;
    private String customerNric;
    private String customerMobileNo;
    private String customerEmailAddr;
    private String chsStatus;
    private String chsRsn;
    private String appvReq;
    private String customerMonth;

    private String salesOrdNo;
	private String rentStus;
	private String outstandingAmt;
	private String unbillAmt;
	private String paymentMode;

    public String getCustomerMonth() {
        return customerMonth;
    }
    public void setCustomerMonth(String customerMonth) {
        this.customerMonth = customerMonth;
    }

    public String getAppvReq() {
        return appvReq;
    }
    public void setAppvReq(String appvReq) {
        this.appvReq = appvReq;
    }

    public String getCustomerName() {
        return customerName;
    }
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerNric() {
        return customerNric;
    }
    public void setCustomerNric(String customerNric) {
        this.customerNric = customerNric;
    }

    public String getCustomerMobileNo() {
        return customerMobileNo;
    }
    public void setCustomerMobileNo(String customerMobileNo) {
        this.customerMobileNo = customerMobileNo;
    }

    public String getCustomerEmailAddr() {
        return customerEmailAddr;
    }
    public void setCustomerEmailAddr(String customerEmailAddr) {
        this.customerEmailAddr = customerEmailAddr;
    }

    public String getChsStatus() {
        return chsStatus;
    }
    public void setChsStatus(String chsStatus) {
        this.chsStatus = chsStatus;
    }

    public String getChsRsn() {
        return chsRsn;
    }
    public void setChsRsn(String chsRsn) {
        this.chsRsn = chsRsn;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getNric() {
        return nric;
    }
    public void setNric(String nric) {
        this.nric = nric;
    }

    public String getMobileNo() {
        return mobileNo;
    }
    public void setMobileNo(String mobileNo) {
        this.mobileNo = mobileNo;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getSelectType() {
        return selectType;
    }
    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }

    public String getSelectKeyword() {
        return selectKeyword;
    }
    public void setSelectKeyword(String selectKeyword) {
        this.selectKeyword = selectKeyword;
    }

    public int getCustId() {
        return custId;
    }
    public void setCustId(int custId) {
        this.custId = custId;
    }

    public String getRegId() {
        return regId;
    }
    public void setRegId(String regId) {
        this.regId = regId;
    }

    public String getYyyymmdd() {
        return yyyymmdd;
    }
    public void setYyyymmdd(String yyyymmdd) {
        this.yyyymmdd = yyyymmdd;
    }

    public String getYymmdd() {
        return yymmdd;
    }
    public void setYymmdd(String yymmdd) {
        this.yymmdd = yymmdd;
    }

    public String getDdmmyyyy() {
        return ddmmyyyy;
    }
    public void setDdmmyyyy(String ddmmyyyy) {
        this.ddmmyyyy = ddmmyyyy;
    }

    public int getMemId() {
        return memId;
    }
    public void setMemId(int memId) {
        this.memId = memId;
    }

    public String getReqstDtFrom() {
        return reqstDtFrom;
    }
    public void setReqstDtFrom(String reqstDtFrom) {
        this.reqstDtFrom = reqstDtFrom;
    }

    public String getReqstDtTo() {
        return reqstDtTo;
    }
    public void setReqstDtTo(String reqstDtTo) {
        this.reqstDtTo = reqstDtTo;
    }

    public String getSalesOrdNo() {
        return salesOrdNo;
    }
    public void setSalesOrdNo(String salesOrdNo) {
        this.salesOrdNo = salesOrdNo;
    }

    public String getRentStus() {
        return rentStus;
    }
    public void setRentStus(String rentStus) {
        this.rentStus = rentStus;
    }

    public String getOutstandingAmt() {
        return outstandingAmt;
    }
    public void setOutstandingAmt(String outstandingAmt) {
        this.outstandingAmt = outstandingAmt;
    }

    public String getUnbillAmt() {
        return unbillAmt;
    }
    public void setUnbillAmt(String unbillAmt) {
        this.unbillAmt = unbillAmt;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(String paymentMode) {
        this.paymentMode = paymentMode;
    }
}
