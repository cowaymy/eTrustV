package com.coway.trust.api.mobile.services.as;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.api.mobile.logistics.audit.InputBarcodeListForm;
import com.coway.trust.api.mobile.services.installation.InstallationResultForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceResultForm", description = "AfterServiceResultForm")
public class AfterServiceResultForm {

	
	@ApiModelProperty(value = "사용자 ID (예_CT123456)")
	private String userId;

	@ApiModelProperty(value = "주문번호")
	private String salesOrderNo;

	@ApiModelProperty(value = "EX_BS00000 / AS00000")
	private String serviceNo;

	@ApiModelProperty(value = "0/60/120")
	private String labourCharge;

	@ApiModelProperty(value = "")
	private String defectId;

	@ApiModelProperty(value = "")
	private String defectPartId;

	@ApiModelProperty(value = "")
	private String defectDetailReasonId;

	@ApiModelProperty(value = "")
	private String solutionReasonId;

	@ApiModelProperty(value = "")
	private String defectTypeId;

	@ApiModelProperty(value = "")
	private String inHouseRepairRemark;

	@ApiModelProperty(value = "")
	private String inHouseRepairReplacementYN;

	@ApiModelProperty(value = "")
	private String inHouseRepairPromisedDate;

	@ApiModelProperty(value = "")
	private String inHouseRepairProductGroupCode;

	@ApiModelProperty(value = "")
	private String inHouseRepairProductCode;

	@ApiModelProperty(value = "")
	private String inHouseRepairSerialNo;

	@ApiModelProperty(value = "결과 등록 메모")
	private String resultRemark;

	@ApiModelProperty(value = "결과 등록시, Owner Code")
	private String ownerCode;

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

	@ApiModelProperty(value = "partList")
	private List<AfterServiceResultDetailForm>  partList;
	

	
	
	
public List<Map<String, Object>> createMaps(AfterServiceResultForm afterServiceResultForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (partList != null && partList.size() > 0) {
			Map<String, Object> map;
			for (AfterServiceResultDetailForm dtl : partList) {
				map = BeanConverter.toMap(afterServiceResultForm, "signData", "partList");
				map.put("signData", Base64.decodeBase64(afterServiceResultForm.getSignData()));

				// as Dtails
				map.put("filterCode", dtl.getFilterCode());
				map.put("chargesFoc", dtl.getChargesFoc());
				map.put("exchangeId", dtl.getExchangeId());
				map.put("salesPrice", dtl.getSalesPrice());
				map.put("filterChangeQty", dtl.getFilterChangeQty());
				map.put("partsType", dtl.getPartsType());
				map.put("filterBarcdSerialNo", dtl.getFilterBarcdSerialNo());

				list.add(map);
			}

		}
		return list;
	}
	
			
			
//public static List<Map<String, Object>>  createMap1(AfterServiceResultForm afterServiceResultForm) {
//
//		List<Map<String, Object>> list = new ArrayList<>();
//		Map<String, Object> map;
//	
////		map = BeanConverter.toMap(afterServiceResultForm, "partList");
//		map = BeanConverter.toMap(afterServiceResultForm);
//		list.add(map);
//		
//	return list;
//}

	

public  List<Map<String, Object>>  createMaps1(AfterServiceResultForm afterServiceResultForm) {

		List<Map<String, Object>> list = new ArrayList<>();
	
		if (partList != null && partList.size() > 0) {
			Map<String, Object> map;
			for (AfterServiceResultDetailForm obj : partList) {
				map = BeanConverter.toMap(afterServiceResultForm, "AfterServiceResultForm");	
//				map.put("serialNo", obj.getSerialNo());
				list.add(map);
			}
		}
		
	return list;
}


//	public List<Map<String, Object>> createMaps(AfterServiceResultForm afterServiceResultForm) {
//
//    	List<Map<String, Object>> list = new ArrayList<>();
//
//		Map<String, Object> params = new HashMap<>();				
//			params.put("userId",afterServiceResultForm.getUserId());
//			params.put("salesOrderNo",afterServiceResultForm.getSalesOrderNo());
//			params.put("serviceNo",afterServiceResultForm.getServiceNo());
//			params.put("labourCharge",afterServiceResultForm.getLabourCharge());
//			params.put("defectId",afterServiceResultForm.getDefectPartId());
//			params.put("defectPartId",afterServiceResultForm.getDefectPartId());
//			params.put("defectDetailReasonId",afterServiceResultForm.getDefectDetailReasonId());
//			params.put("solutionReasonId",afterServiceResultForm.getSolutionReasonId());
//			params.put("defectTypeId",afterServiceResultForm.getDefectTypeId());
//			params.put("inHouseRepairRemark",afterServiceResultForm.getInHouseRepairRemark());
//			params.put("inHouseRepairReplacementYN",afterServiceResultForm.getInHouseRepairReplacementYN());
//			params.put("inHouseRepairPromisedDate",afterServiceResultForm.getInHouseRepairPromisedDate());
//			params.put("inHouseRepairProductGroupCode",afterServiceResultForm.getInHouseRepairProductGroupCode());
//			params.put("inHouseRepairProductCode",afterServiceResultForm.getInHouseRepairProductCode());
//			params.put("inHouseRepairSerialNo",afterServiceResultForm.getInHouseRepairSerialNo());
//			params.put("resultRemark",afterServiceResultForm.getResultRemark());
//			params.put("ownerCode",afterServiceResultForm.getOwnerCode());
//			params.put("resultCustName",afterServiceResultForm.getResultCustName());
//			params.put("resultIcMobileNo",afterServiceResultForm.getResultIcMobileNo());
//			params.put("resultReportEmailNo",afterServiceResultForm.getResultReportEmailNo());
//			params.put("resultAcceptanceName",afterServiceResultForm.getResultAcceptanceName());
//			params.put("signData",afterServiceResultForm.getSignData());
//			params.put("transactionId",afterServiceResultForm.getTransactionId());
//            	
//			list.add(params);
//			
//    	return list;
//	
//	}
//	
	
	
	
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

	public String getLabourCharge() {
		return labourCharge;
	}

	public void setLabourCharge(String labourCharge) {
		this.labourCharge = labourCharge;
	}

	public String getDefectId() {
		return defectId;
	}

	public void setDefectId(String defectId) {
		this.defectId = defectId;
	}

	public String getDefectPartId() {
		return defectPartId;
	}

	public void setDefectPartId(String defectPartId) {
		this.defectPartId = defectPartId;
	}

	public String getDefectDetailReasonId() {
		return defectDetailReasonId;
	}

	public void setDefectDetailReasonId(String defectDetailReasonId) {
		this.defectDetailReasonId = defectDetailReasonId;
	}

	public String getSolutionReasonId() {
		return solutionReasonId;
	}

	public void setSolutionReasonId(String solutionReasonId) {
		this.solutionReasonId = solutionReasonId;
	}

	public String getDefectTypeId() {
		return defectTypeId;
	}

	public void setDefectTypeId(String defectTypeId) {
		this.defectTypeId = defectTypeId;
	}

	public String getInHouseRepairRemark() {
		return inHouseRepairRemark;
	}

	public void setInHouseRepairRemark(String inHouseRepairRemark) {
		this.inHouseRepairRemark = inHouseRepairRemark;
	}

	public String getInHouseRepairReplacementYN() {
		return inHouseRepairReplacementYN;
	}

	public void setInHouseRepairReplacementYN(String inHouseRepairReplacementYN) {
		this.inHouseRepairReplacementYN = inHouseRepairReplacementYN;
	}

	public String getInHouseRepairPromisedDate() {
		return inHouseRepairPromisedDate;
	}

	public void setInHouseRepairPromisedDate(String inHouseRepairPromisedDate) {
		this.inHouseRepairPromisedDate = inHouseRepairPromisedDate;
	}

	public String getInHouseRepairProductGroupCode() {
		return inHouseRepairProductGroupCode;
	}

	public void setInHouseRepairProductGroupCode(String inHouseRepairProductGroupCode) {
		this.inHouseRepairProductGroupCode = inHouseRepairProductGroupCode;
	}

	public String getInHouseRepairProductCode() {
		return inHouseRepairProductCode;
	}

	public void setInHouseRepairProductCode(String inHouseRepairProductCode) {
		this.inHouseRepairProductCode = inHouseRepairProductCode;
	}

	public String getInHouseRepairSerialNo() {
		return inHouseRepairSerialNo;
	}

	public void setInHouseRepairSerialNo(String inHouseRepairSerialNo) {
		this.inHouseRepairSerialNo = inHouseRepairSerialNo;
	}

	public String getResultRemark() {
		return resultRemark;
	}

	public void setResultRemark(String resultRemark) {
		this.resultRemark = resultRemark;
	}

	public String getOwnerCode() {
		return ownerCode;
	}

	public void setOwnerCode(String ownerCode) {
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

	public List<AfterServiceResultDetailForm> getPartList() {
		return partList;
	}

	public void setPartList(List<AfterServiceResultDetailForm> partList) {
		this.partList = partList;
	}



	
	

	
}
