package com.coway.trust.api.mobile.Service.registration;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartForm", description = "HeartForm")
public class HeartForm {

	@ApiModelProperty(value = "userId")
	private String userId;
	@ApiModelProperty(value = "salesOrderNo")
	private String salesOrderNo;
	@ApiModelProperty(value = "serviceNo")
	private String serviceNo;
	@ApiModelProperty(value = "temperatureSetting")
	private String temperatureSetting;
	@ApiModelProperty(value = "resultRemark")
	private String resultRemark;
	@ApiModelProperty(value = "nextAppointmentDate")
	private String nextAppointmentDate;
	@ApiModelProperty(value = "nextAppointmentTime")
	private String nextAppointmentTime;
	@ApiModelProperty(value = "ownerCode")
	private int ownerCode;
	@ApiModelProperty(value = "resultCustName")
	private String resultCustName;
	@ApiModelProperty(value = "resultIcMobileNo")
	private String resultIcMobileNo;
	@ApiModelProperty(value = "resultReportEmailNo")
	private String resultReportEmailNo;
	@ApiModelProperty(value = "resultAcceptanceName")
	private String resultAcceptanceName;
	@ApiModelProperty(value = "rcCode")
	private int rcCode;
	@ApiModelProperty(value = "signData")
	private String signData;
	@ApiModelProperty(value = "transactionId")
	private String transactionId;

	@ApiModelProperty(value = "heartDtails")
	private List<HeartDtailForm> heartDtails;

	public List<Map<String, Object>> createMaps(HeartForm heartForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (heartDtails != null && heartDtails.size() > 0) {
			Map<String, Object> map;
			for (HeartDtailForm dtl : heartDtails) {
				map = BeanConverter.toMap(heartForm, "signData", "heartDtails");
				map.put("signData", Base64.decodeBase64(heartForm.getSignData()));

				// heartDtails
				map.put("filterCode", dtl.getFilterCode());
				map.put("exchangeId", dtl.getExchangeId());
				map.put("filterChangeQty", dtl.getFilterChangeQty());

				list.add(map);
			}
		}
		return list;
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

	public String getTemperatureSetting() {
		return temperatureSetting;
	}

	public void setTemperatureSetting(String temperatureSetting) {
		this.temperatureSetting = temperatureSetting;
	}

	public String getResultRemark() {
		return resultRemark;
	}

	public void setResultRemark(String resultRemark) {
		this.resultRemark = resultRemark;
	}

	public String getNextAppointmentDate() {
		return nextAppointmentDate;
	}

	public void setNextAppointmentDate(String nextAppointmentDate) {
		this.nextAppointmentDate = nextAppointmentDate;
	}

	public String getNextAppointmentTime() {
		return nextAppointmentTime;
	}

	public void setNextAppointmentTime(String nextAppointmentTime) {
		this.nextAppointmentTime = nextAppointmentTime;
	}

	public int getOwnerCode() {
		return ownerCode;
	}

	public void setOwnerCode(int ownerCode) {
		this.ownerCode = ownerCode;
	}

	public String getResultCustName() {
		return resultCustName;
	}

	public void setResultCustName(String resultCustName) {
		this.resultCustName = resultCustName;
	}

	public String getResultIcMobileNo() {
		return resultIcMobileNo;
	}

	public void setResultIcMobileNo(String resultIcMobileNo) {
		this.resultIcMobileNo = resultIcMobileNo;
	}

	public String getResultReportEmailNo() {
		return resultReportEmailNo;
	}

	public void setResultReportEmailNo(String resultReportEmailNo) {
		this.resultReportEmailNo = resultReportEmailNo;
	}

	public String getResultAcceptanceName() {
		return resultAcceptanceName;
	}

	public void setResultAcceptanceName(String resultAcceptanceName) {
		this.resultAcceptanceName = resultAcceptanceName;
	}

	public int getRcCode() {
		return rcCode;
	}

	public void setRcCode(int rcCode) {
		this.rcCode = rcCode;
	}

	public String getSignData() {
		return signData;
	}

	public void setSignData(String signData) {
		this.signData = signData;
	}

	public List<HeartDtailForm> getHeartDtails() {
		return heartDtails;
	}

	public void setHeartDtails(List<HeartDtailForm> heartDtails) {
		this.heartDtails = heartDtails;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}
}
