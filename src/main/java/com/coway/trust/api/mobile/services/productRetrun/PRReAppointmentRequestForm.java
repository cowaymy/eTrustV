package com.coway.trust.api.mobile.services.productRetrun;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.api.mobile.services.installation.InstallationResultForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class PRReAppointmentRequestForm {

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
	
	
	
	
	
	public static Map<String, Object> createMaps(PRReAppointmentRequestForm pRReAppointmentRequestForm) {
		
		List<Map<String, Object>> list = new ArrayList<>();

			Map<String, Object> map=null;
			
			
//				map = BeanConverter.toMap(pRReAppointmentRequestForm, "signData", "partList");
//				map.put("signData", Base64.decodeBase64(installationResultForm.getSignData()));

				// install Result
				map.put("userId", pRReAppointmentRequestForm.getUserId());
				map.put("salesOrderNo", pRReAppointmentRequestForm.getSalesOrderNo());
				map.put("serviceNo", pRReAppointmentRequestForm.getServiceNo());
				map.put("appointmentDate", pRReAppointmentRequestForm.getAppointmentDate());
				map.put("appointmentTime", pRReAppointmentRequestForm.getAppointmentTime());

//				list.add(map);
				
				return map;
	}
	
}
