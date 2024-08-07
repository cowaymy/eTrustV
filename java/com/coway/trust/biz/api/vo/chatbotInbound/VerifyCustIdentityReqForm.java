package com.coway.trust.biz.api.vo.chatbotInbound;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "VerifyCustIdentityReqForm", description = "VerifyCustIdentityReqForm")
public class VerifyCustIdentityReqForm {
	private String custPhoneNo;

	public String getCustPhoneNo() {
		return custPhoneNo;
	}
	public void setCustPhoneNo(String custPhoneNo) {
		this.custPhoneNo = custPhoneNo;
	}
}