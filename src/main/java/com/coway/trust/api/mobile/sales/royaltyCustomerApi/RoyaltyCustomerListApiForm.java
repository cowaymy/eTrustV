package com.coway.trust.api.mobile.sales.royaltyCustomerApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiFormDto;

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
@ApiModel(value = "RoyaltyCustomerListApiForm", description = "RoyaltyCustomerListApiForm")
public class RoyaltyCustomerListApiForm {

	public static Map<String, Object> createMap(RoyaltyCustomerListApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("loyaltyId", vo.getLoyaltyId());
	//	params.put("salesOrdId", vo.getSalesOrdId());
		params.put("salesOrdNo", vo.getSalesOrdNo());
	//	params.put("custID", vo.getCustID());
		params.put("hpCallReasonCode", vo.getHpCallReasonCode());
		params.put("hpCallRemark", vo.getHpCallRemark());
	//	params.put("updUserId", vo.getUpdUserId());
		params.put("hpCode", vo.getHpCode());
		params.put("whLocId", vo.getWhLocId());
		params.put("regId", vo.getRegId());

		return params;
	}


/*	public static Map<String, Object> createMap(StockAuditApiFormDto vo) {
		Map<String, Object> params = new HashMap<>();
        params.put("regId", vo.getRegId());
		params.put("whLocId", vo.getWhLocId());
		params.put("stockAuditNo", vo.getStockAuditNo());
        params.put("viewGu", vo.getViewGu());
        params.put("docStartDt", vo.getDocStartDt());
        params.put("docEndDt", vo.getDocEndDt());
		return params;
	}*/


	private int WhLocId;
	private int loyaltyId;
	private int salesOrdId;
	private int salesOrdNo;
	private int custID;
	private int hpCallReasonCode;
	private String hpCallRemark;
	private int updUserId;
	private String updDt;
	private String regId;
	private String hpCode;




	public String getHpCode() {
		return hpCode;
	}
	public void setHpCode(String hpCode) {
		this.hpCode = hpCode;
	}
	public int getWhLocId() {
		return WhLocId;
	}
	public void setWhLocId(int whLocId) {
		WhLocId = whLocId;
	}
	public String getRegId() {
		return regId;
	}
	public void setRegId(String regId) {
		this.regId = regId;
	}
	public int getUpdUserId() {
		return updUserId;
	}
	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}
	public String getUpdDt() {
		return updDt;
	}
	public void setUpdDt(String updDt) {
		this.updDt = updDt;
	}
	public int getLoyaltyId() {
		return loyaltyId;
	}
	public void setLoyaltyId(int loyaltyId) {
		this.loyaltyId = loyaltyId;
	}
	public int getSalesOrdId() {
		return salesOrdId;
	}
	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}
	public int getSalesOrdNo() {
		return salesOrdNo;
	}
	public void setSalesOrdNo(int salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}
	public int getCustID() {
		return custID;
	}
	public void setCustID(int custID) {
		this.custID = custID;
	}
	public int getHpCallReasonCode() {
		return hpCallReasonCode;
	}
	public void setHpCallReasonCode(int hpCallReasonCode) {
		this.hpCallReasonCode = hpCallReasonCode;
	}
	public String getHpCallRemark() {
		return hpCallRemark;
	}
	public void setHpCallRemark(String hpCallRemark) {
		this.hpCallRemark = hpCallRemark;
	}





}
