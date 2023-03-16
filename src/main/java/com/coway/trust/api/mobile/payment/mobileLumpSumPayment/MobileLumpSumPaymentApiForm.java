package com.coway.trust.api.mobile.payment.mobileLumpSumPayment;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "MobileLumpSumPaymentApiForm", description = "MobileLumpSumPaymentApiForm")
public class MobileLumpSumPaymentApiForm {
	//Customer Search
	private String custCiType;
	private String custCi;

	//Order Search
	private String custId;

	public static Map<String, Object> createMap(MobileLumpSumPaymentApiForm vo){
    	Map<String, Object> params = new HashMap<>();
    	//Customer Search
    	params.put("custCiType", vo.getCustCiType());
    	params.put("custCi", vo.getCustCi());

    	//Order Search
    	params.put("custId", vo.getCustId());

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
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
}
