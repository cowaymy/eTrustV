package com.coway.trust.api.mobile.sales.epapanApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : ProductInfoListApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "EpapanApiForm", description = "EpapanApiForm")
public class EpapanApiForm {

	public static Map<String, Object> createMap(EpapanApiForm vo){
		Map<String, Object> params = new HashMap<>();


		params.put("appTypeId", vo.getAppTypeId());
		params.put("stkId", vo.getStkId());
		params.put("empChk", vo.getEmpChk());
		params.put("promoCustType", vo.getPromoCustType());
		params.put("exTrade", vo.getExTrade());
		params.put("srvPacId", vo.getSrvPacId());
		params.put("isSrvPac", vo.getIsSrvPac());
		params.put("voucherPromotion", vo.getVoucherPromotion());
		params.put("custStatus", vo.getCustStatus());

		params.put("promoId", vo.getPromoId());


		return params;
	}




	/*
	 * */

    public String appTypeId;
    public String stkId;
    public String empChk;
    public String promoCustType;
    public String exTrade;
    public String srvPacId;
    public String isSrvPac;
    public String voucherPromotion;
    public String custStatus;

    public String promoId;



    public String getPromoId() {
		return promoId;
	}
	public void setPromoId(String promoId) {
		this.promoId = promoId;
	}
	public String getAppTypeId() {
    	return appTypeId;
    }
    public void setAppTypeId(String appTypeId) {
    	this.appTypeId = appTypeId;
    }
    public String getStkId() {
    	return stkId;
    }
    public void setStkId(String stkId) {
    	this.stkId = stkId;
    }
    public String getEmpChk() {
    	return empChk;
    }
    public void setEmpChk(String empChk) {
    	this.empChk = empChk;
    }
    public String getPromoCustType() {
    	return promoCustType;
    }
    public void setPromoCustType(String promoCustType) {
    	this.promoCustType = promoCustType;
    }
    public String getExTrade() {
    	return exTrade;
    }
    public void setExTrade(String exTrade) {
    	this.exTrade = exTrade;
    }
    public String getSrvPacId() {
    	return srvPacId;
    }
    public void setSrvPacId(String srvPacId) {
    	this.srvPacId = srvPacId;
    }
    public String getIsSrvPac() {
    	return isSrvPac;
    }
    public void setIsSrvPac(String isSrvPac) {
    	this.isSrvPac = isSrvPac;
    }
    public String getVoucherPromotion() {
    	return voucherPromotion;
    }
    public void setVoucherPromotion(String voucherPromotion) {
    	this.voucherPromotion = voucherPromotion;
    }
    public String getCustStatus() {
    	return custStatus;
    }
    public void setCustStatus(String custStatus) {
    	this.custStatus = custStatus;
    }





}
