package com.coway.trust.api.mobile.payment.mobileLumpSumPayment;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "MobileLumpSumPaymentApiForm", description = "MobileLumpSumPaymentApiForm")
public class MobileLumpSumPaymentApiForm {
	//Customer Search
	private String custCiType;
	private String custCi;
	private String ordNoList;

	//Order Search
	private int custId;

	public static Map<String, Object> createMap(MobileLumpSumPaymentApiForm vo){
    	Map<String, Object> params = new HashMap<>();
    	//Customer Search
    	params.put("custCiType", vo.getCustCiType());
    	params.put("custCi", vo.getCustCi());

    	//Order Search
    	params.put("custId", vo.getCustId());
    	params.put("ordNoList", vo.getOrdNoList());

    	return params;
	}

	public String getCustCiType() {
		return custCiType;
	}
	public void setCustCiType(String custCiType) {
		this.custCiType = custCiType;
	}
	public String getCustCi() {
		return custCi;
	}
	public void setCustCi(String custCi) {
		this.custCi = custCi;
	}
	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getOrdNoList() {
		return ordNoList;
	}

	public void setOrdNoList(String ordNoList) {
		this.ordNoList = ordNoList;
	}
}
