package com.coway.trust.biz.api.vo.procurement;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "VendorPaymentReqForm", description = "VendorPaymentReqForm")
public class VendorPaymentReqForm {
	private Integer syncEmro;

	public Integer getSyncEmro() {
		return syncEmro;
	}

	public void setSyncEmro(Integer syncEmro) {
		this.syncEmro = syncEmro;
	}
}
