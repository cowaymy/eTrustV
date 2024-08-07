package com.coway.trust.api.mobile.sales.ccpApi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : PreCcpRegisterApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             		Author                 Description
 * -------------    	-----------             -------------
 * 2023. 02. 08.    Low Kim Ching      First creation
 * </pre>
 */
@ApiModel(value = "PreCcpRegisterApiDto", description = "PreCcpRegisterApiDto")
public class PreCcpRegisterApiDto {

    @SuppressWarnings("unchecked")
	public static PreCcpRegisterApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, PreCcpRegisterApiDto.class);
	}

	public static Map<String, Object> createMap(PreCcpRegisterApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("custId", vo.getCustId());
		params.put("custName", vo.getCustName());
		params.put("custMonth", vo.getCustMonth());
		params.put("appvReq", vo.getAppvReq());
		params.put("chsStatus", vo.getChsStatus());
		params.put("chsRsn", vo.getChsRsn());

		params.put("salesOrdNo", vo.getSalesOrdNo());
		params.put("rentStus", vo.getRentStus());
		params.put("paymentMode", vo.getPaymentMode());
		params.put("outstandingAmt", vo.getOutstandingAmt());
		params.put("unbillAmt", vo.getUnbillAmt());

		params.put("success", vo.getSuccess());
		params.put("msg", vo.getMsg());

		return params;
	}


	private int custId;
	private String custName;
	private String custIc;
	private String custMobileno;
	private String custEmail;
	private String chsStatus;
	private String crtDt;
	private String chsRsn;
	private String appvReq;
	private int custMonth;

	private String salesOrdNo;
	private String rentStus;
	private String outstandingAmt;
	private String unbillAmt;
	private String paymentMode;

	private int success;
	private String msg;

    public int getSuccess() {
        return success;
    }
    public void setSuccess(int success) {
        this.success = success;
    }

    public String getMsg() {
        return msg;
    }
    public void setMsg(String msg) {
        this.msg = msg;
    }

    public int getCustId() {
        return custId;
    }
    public void setCustId(int custId) {
        this.custId = custId;
    }

    public String getCustName() {
        return custName;
    }
    public void setCustName(String custName) {
        this.custName = custName;
    }

    public String getCustIc() {
        return custIc;
    }
    public void setCustIc(String custIc) {
        this.custIc = custIc;
    }

    public String getCustMobileno() {
        return custMobileno;
    }
    public void setCustMobileno(String custMobileno) {
        this.custMobileno = custMobileno;
    }

    public String getCustEmail() {
        return custEmail;
    }
    public void setCustEmail(String custEmail) {
        this.custEmail = custEmail;
    }

    public String getChsStatus() {
        return chsStatus;
    }
    public void setChsStatus(String chsStatus) {
        this.chsStatus = chsStatus;
    }

    public String getCrtDt() {
        return crtDt;
    }
    public void setCrtDt(String crtDt) {
        this.crtDt = crtDt;
    }

    public int getCustMonth() {
        return custMonth;
    }
    public void setCustMonth(int custMonth) {
        this.custMonth = custMonth;
    }

    public String getAppvReq() {
        return appvReq;
    }
    public void setAppvReq(String appvReq) {
        this.appvReq = appvReq;
    }

    public String getChsRsn() {
        return chsRsn;
    }
    public void setChsRsn(String chsRsn) {
        this.chsRsn = chsRsn;
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
