package com.coway.trust.api.mobile.services.as;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class ASRequestRegistForm {
	
	
	private String userId;
	private String salesOrderNo;
	private String customerId;
	private String productCode;
	private String defectCodeId;
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
	public String getDefectCodeId() {
		return defectCodeId;
	}
	public void setDefectCodeId(String defectCodeId) {
		this.defectCodeId = defectCodeId;
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
	
	
	
	public static Map<String, Object> createMaps(ASRequestRegistForm aSRequestRegistForm) {
		
		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> map;
		
		map = BeanConverter.toMap(aSRequestRegistForm);
		
		return map;
}
	
	
	

}
