package com.coway.trust.api.mobile.services.dtAs;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class DtASRequestRegistForm {

	private String userId;
	private String salesOrderNo;
	private String customerId;
	private String productCode;
	private String errTypeId;
	private String errReasonId;
	private String resultRemark;
	private String transactionId;

	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getSalesOrderNo() {
		return salesOrderNo;
	}
	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public String getProductCode() {
		return productCode;
	}
	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public String getErrTypeId() {
		return errTypeId;
	}
	public void setErrTypeId(String errTypeId) {
		this.errTypeId = errTypeId;
	}
	public String getErrReasonId() {
		return errReasonId;
	}
	public void setErrReasonId(String errReasonId) {
		this.errReasonId = errReasonId;
	}
	public String getResultRemark() {
		return resultRemark;
	}
	public void setResultRemark(String resultRemark) {
		this.resultRemark = resultRemark;
	}


	public String getTransactionId() {
		return transactionId;
	}
	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}



	public static Map<String, Object> createMaps(DtASRequestRegistForm aSRequestRegistForm) {

		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> map;

		map = BeanConverter.toMap(aSRequestRegistForm);

		return map;
}




}
