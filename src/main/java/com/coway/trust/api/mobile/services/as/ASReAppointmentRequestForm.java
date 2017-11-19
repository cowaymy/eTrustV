package com.coway.trust.api.mobile.services.as;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.api.mobile.services.installation.InstallationResultForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class ASReAppointmentRequestForm {

	@ApiModelProperty(value = "사용자 ID (예_CT123456)")
	private String userId;

	@ApiModelProperty(value = "주문번호")
	private String salesOrderNo;

	@ApiModelProperty(value = "EX_BS00000 / AS00000")
	private String serviceNo;

	@ApiModelProperty(value = "작업 변경 날짜(YYYYMMDD)")
	private String appointmentDate;

	@ApiModelProperty(value = "작업 변경 시간(HHMM)")
	private String appointmentTime;
	
	
	private String transactionId;
	
	
	

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

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

	public String getServiceNo() {
		return serviceNo;
	}

	public void setServiceNo(String serviceNo) {
		this.serviceNo = serviceNo;
	}

	public String getAppointmentDate() {
		return appointmentDate;
	}

	public void setAppointmentDate(String appointmentDate) {
		this.appointmentDate = appointmentDate;
	}

	public String getAppointmentTime() {
		return appointmentTime;
	}

	public void setAppointmentTime(String appointmentTime) {
		this.appointmentTime = appointmentTime;
	}
	
	
	
	
	
	public static Map<String, Object> createMaps(ASReAppointmentRequestForm aSReAppointmentRequestForm) {
		
			List<Map<String, Object>> list = new ArrayList<>();
			Map<String, Object> map;
			
//				map = BeanConverter.toMap(pRReAppointmentRequestForm, "signData", "partList");
//				map.put("signData", Base64.decodeBase64(installationResultForm.getSignData()));
				
				map = BeanConverter.toMap(aSReAppointmentRequestForm);
				
				// install Result
//				map.put("userId", aSReAppointmentRequestForm.getUserId());
//				map.put("salesOrderNo", aSReAppointmentRequestForm.getSalesOrderNo());
//				map.put("serviceNo", aSReAppointmentRequestForm.getServiceNo());
//				map.put("appointmentDate", aSReAppointmentRequestForm.getAppointmentDate());
//				map.put("appointmentTime", aSReAppointmentRequestForm.getAppointmentTime());

//				list.add(map);
				
				return map;
	}
	
}
