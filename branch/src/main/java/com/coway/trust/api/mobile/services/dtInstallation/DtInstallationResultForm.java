package com.coway.trust.api.mobile.services.dtInstallation;

import java.util.ArrayList;
import org.apache.commons.codec.binary.Base64;
import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.services.as.AfterServiceResultDetailForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class DtInstallationResultForm {

	@ApiModelProperty(value = "사용자 ID (예_CT123456)")
	private String userId;

	@ApiModelProperty(value = "주문번호")
	private int salesOrderNo;

	@ApiModelProperty(value = "EX_BS00000 / AS00000")
	private String serviceNo;

	@ApiModelProperty(value = "sirim 코드")
	private String sirimNo;

	@ApiModelProperty(value = "serial 코드")
	private String serialNo;

	@ApiModelProperty(value = "before INST 교체여부")
	private String asExchangeYN;

	@ApiModelProperty(value = "before INST 교체제품 SN")
	private String beforeProductSerialNo;

	@ApiModelProperty(value = "결과 등록 메모")
	private String resultRemark;

	@ApiModelProperty(value = "결과 등록시, Owner Code")
	private int ownerCode;

	@ApiModelProperty(value = "결과 등록시, Cust Name")
	private String resultCustName;

	@ApiModelProperty(value = "결과 등록시, NrIc 또는 Mobile No")
	private String resultIcMobileNo;

	@ApiModelProperty(value = "결과 등록시, Email_No")
	private String resultReportEmailNo;

	@ApiModelProperty(value = "결과 등록시, Acceptance Name")
	private String resultAcceptanceName;

	@ApiModelProperty(value = "base64 Data")
	private String signData;

	@ApiModelProperty(value = "Transaction ID 값(체계 : USER_ID + SALES_ORDER_NO + SERVICE_NO + 현재시간_YYYYMMDDHHMMSS)")
	private String transactionId;

	
	private String signRegDate;
	
	private String signRegTime;
	
	
	private String checkInDate;
	private String checkInTime;
	private String checkInGps;
	
	
	public String getCheckInDate() {
		return checkInDate;
	}

	public void setCheckInDate(String checkInDate) {
		this.checkInDate = checkInDate;
	}

	public String getCheckInTime() {
		return checkInTime;
	}

	public void setCheckInTime(String checkInTime) {
		this.checkInTime = checkInTime;
	}

	public String getCheckInGps() {
		return checkInGps;
	}

	public void setCheckInGps(String checkInGps) {
		this.checkInGps = checkInGps;
	}
	
	
	public String getSignRegDate() {
		return signRegDate;
	}

	public void setSignRegDate(String signRegDate) {
		this.signRegDate = signRegDate;
	}

	public String getSignRegTime() {
		return signRegTime;
	}

	public void setSignRegTime(String signRegTime) {
		this.signRegTime = signRegTime;
	}


	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
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

	public String getSirimNo() {
		return sirimNo;
	}

	public void setSirimNo(String sirimNo) {
		this.sirimNo = sirimNo;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getAsExchangeYN() {
		return asExchangeYN;
	}

	public void setAsExchangeYN(String asExchangeYN) {
		this.asExchangeYN = asExchangeYN;
	}

	public String getBeforeProductSerialNo() {
		return beforeProductSerialNo;
	}

	public void setBeforeProductSerialNo(String beforeProductSerialNo) {
		this.beforeProductSerialNo = beforeProductSerialNo;
	}

	public String getResultRemark() {
		return resultRemark;
	}

	public void setResultRemark(String resultRemark) {
		this.resultRemark = resultRemark;
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

	public String getSignData() {
		return signData;
	}

	public void setSignData(String signData) {
		this.signData = signData;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}
	
	
	

	
	
	
//	public static Map<String, Object> createMaps(InstallationResultForm installationResultForm) {
//		Map<String, Object> params = new HashMap<>();
//		params.put("userId", installationResultForm.getUserId());
//		params.put("salesOrderNo", installationResultForm.getSalesOrderNo());
//		params.put("serviceNo", installationResultForm.getServiceNo());
//		params.put("sirimNo", installationResultForm.getSirimNo());
//		params.put("serialNo", installationResultForm.getSerialNo());
//		params.put("asExchangeYN", installationResultForm.getAsExchangeYN());
//		params.put("beforeProductSerialNo", installationResultForm.getBeforeProductSerialNo());
//		params.put("resultRemark", installationResultForm.getResultRemark());
//		params.put("ownerCode", installationResultForm.getOwnerCode());
//		params.put("resultCustName", installationResultForm.getResultCustName());
//		params.put("resultIcMobileNo", installationResultForm.getResultIcMobileNo());
//		params.put("resultReportEmailNo", installationResultForm.getResultReportEmailNo());
//		params.put("resultAcceptanceName", installationResultForm.getResultAcceptanceName());
//
//		params.put("signData", Base64.decodeBase64(installationResultForm.getSignData()));
//		
//		params.put("transactionId", installationResultForm.getTransactionId());
//		
//		return params;
//	}


	
	public List<Map<String, Object>> createMaps(DtInstallationResultForm installationResultForm) {
		
		List<Map<String, Object>> list = new ArrayList<>();
			Map<String, Object> map;
			
//			for(InstallationResultForm form : installationResultForm){
////				map = BeanConverter.toMap(installationResultForm, "signData");
////				map.put("signData", Base64.decodeBase64(installationResultForm.getSignData()));
//				
//				list.add(map);
//			}
				map = BeanConverter.toMap(installationResultForm, "signData");
				map.put("signData", Base64.decodeBase64(installationResultForm.getSignData()));

				// install Result
				
				map.put("userId", installationResultForm.getUserId());
				map.put("salesOrderNo", installationResultForm.getSalesOrderNo());
				map.put("serviceNo", installationResultForm.getServiceNo());
				map.put("sirimNo", installationResultForm.getSirimNo());
				map.put("serialNo", installationResultForm.getSerialNo());
				map.put("asExchangeYN", installationResultForm.getAsExchangeYN());
				map.put("beforeProductSerialNo", installationResultForm.getBeforeProductSerialNo());
				map.put("resultRemark", installationResultForm.getResultRemark());
				map.put("ownerCode", installationResultForm.getOwnerCode());
				map.put("resultCustName", installationResultForm.getResultCustName());
				map.put("resultIcMobileNo", installationResultForm.getResultIcMobileNo());
				map.put("resultReportEmailNo", installationResultForm.getResultReportEmailNo());
				map.put("resultAcceptanceName", installationResultForm.getResultAcceptanceName());
				map.put("signData", Base64.decodeBase64(installationResultForm.getSignData()));
				map.put("transactionId", installationResultForm.getTransactionId());				
				map.put("signRegDate", installationResultForm.getSignRegDate());
				map.put("signRegTime", installationResultForm.getSignRegTime());				

				list.add(map);
				
				return list;
	}
	
	
	
	
	
	

	
}
