package com.coway.trust.api.mobile.services.heartService;

import java.util.List;
import java.util.Map;

//import com.coway.trust.api.mobile.common.MalfunctionCodeForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "HeartServiceResultForm", description = "공통코드 Form")
public class HeartServiceResultForm {

	private int userId;
	private int salesOrderNo;
	private String serviceNo;
	private String temperatureSetting;
	private String resultRemark;
	private String nextAppointmentDate;
	private String nextAppointmentTime;
	private int ownerCode;
	private String resultCustName;
	private String resultIcMobileNo;
	private String resultReportEmailNo;
	private String resultAcceptanceName;
	private int rcCode;
	private String signData;
	private List<RequestResultDetailForm> filterList =null ;
	





	public static Map<String, Object> createMap(HeartServiceResultForm heartServiceResultForm) {
		Map<String, Object> map = BeanConverter.toMap(heartServiceResultForm);
		return map;

	}

	public List<RequestResultDetailForm> getFilterList() {
		return filterList;
	}

	public void setFilterList(List<RequestResultDetailForm> filterList) {
		this.filterList = filterList;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getSalesOrderNo() {
		return salesOrderNo;
	}

	public void setSalesOrderNo(int salesOrderNo) {
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
	





		
//		Map<String, Object> params = new HashMap<>();
//		params.put("userId", HeartServiceResultForm.getUserId());
//		params.put("salesOrderNo", HeartServiceResultForm.getSalesOrderNo());
//		params.put("serviceNo", HeartServiceResultForm.getServiceNo());
//		params.put("temperatureSetting", HeartServiceResultForm.getTemperatureSetting());
//		params.put("resultRemark", HeartServiceResultForm.getResultRemark());
//		params.put("nextAppointmentDate", HeartServiceResultForm.getNextAppointmentDate());
//		params.put("nextAppointmentTime", HeartServiceResultForm.getNextAppointmentTime());
//		params.put("ownerCode", HeartServiceResultForm.getOwnerCode());
//		params.put("resultCustName", HeartServiceResultForm.getResultCustName());
//		params.put("resultIcMobileNo", HeartServiceResultForm.getResultIcMobileNo());
//		params.put("resultReportEmailNo", HeartServiceResultForm.getResultReportEmailNo());
//		params.put("resultAcceptanceName", HeartServiceResultForm.getResultAcceptanceName());
//		params.put("rcCode", HeartServiceResultForm.getRcCode());
//		params.put("signData", HeartServiceResultForm.getSignData());
//		params.put("filterList", HeartServiceResultForm.getFilterList());
		
//		return params;
	
	
}
