package com.coway.trust.api.mobile.payment.eGhlPaymentCollection;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "EGhlPaymentCollectionApiForm", description = "EGhlPaymentCollectionApiForm")
public class EGhlPaymentCollectionApiForm {
	private String custIc;
	private String custId;
	private String userName;

	public static Map<String, Object> createMap(EGhlPaymentCollectionApiForm vo){
    	Map<String, Object> params = new HashMap<>();
    	params.put("cutIc", vo.getCustIc());
    	params.put("custId", vo.getCustId());
    	params.put("cutIc", vo.getUserName());

    	return params;
	}

	public String getCustIc() {
		return custIc;
	}

	public void setCustIc(String custIc) {
		this.custIc = custIc;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
}
