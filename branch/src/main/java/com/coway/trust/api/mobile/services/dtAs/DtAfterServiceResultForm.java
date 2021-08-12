package com.coway.trust.api.mobile.services.dtAs;

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
public class DtAfterServiceResultForm {


	@ApiModelProperty(value = "사용자 ID (예_CT123456)")
	private String userId;

	@ApiModelProperty(value = "주문번호")
	private String salesOrderNo;

	@ApiModelProperty(value = "EX_BS00000 / AS00000")
	private String serviceNo;

	@ApiModelProperty(value = "0/60/120")
	private int labourCharge;

	@ApiModelProperty(value = "")
	private int defectId;

	@ApiModelProperty(value = "")
	private int defectPartId;

	@ApiModelProperty(value = "")
	private int defectDetailReasonId;

	@ApiModelProperty(value = "")
	private int solutionReasonId;

	@ApiModelProperty(value = "")
	private int defectTypeId;

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

	private String signRegDate;
	private String signRegTime;




	@ApiModelProperty(value = "Transaction ID 값(체계 : USER_ID + SALES_ORDER_NO + SERVICE_NO + 현재시간_YYYYMMDDHHMMSS)")
	private String transactionId;


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


	@ApiModelProperty(value = "partList")
	private List<DtAfterServiceResultDetailForm>  partList;


public List<Map<String, Object>> createMaps(DtAfterServiceResultForm afterServiceResultForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (partList != null && partList.size() > 0) {
			Map<String, Object> map;
			for (DtAfterServiceResultDetailForm dtl : partList) {
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



public static List<Map<String, Object>>  createMaps1(DtAfterServiceResultForm afterServiceResultForm) {

		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> map;
		map = BeanConverter.toMap(afterServiceResultForm, "signData");
		map.put("signData", Base64.decodeBase64(afterServiceResultForm.getSignData()));
		list.add(map);

	return list;
}

//
//
//
//public  List<Map<String, Object>>  createMaps1(AfterServiceResultForm afterServiceResultForm) {
//
//		List<Map<String, Object>> list = new ArrayList<>();
//
//		if (partList != null && partList.size() > 0) {
//			Map<String, Object> map;
//			map = BeanConverter.toMap(afterServiceResultForm, "signData");
//			map.put("signData", Base64.decodeBase64(afterServiceResultForm.getSignData()));
//
//			for (AfterServiceResultDetailForm obj : partList) {
////				map = BeanConverter.toMap(afterServiceResultForm, "AfterServiceResultForm");
////				map.put("serialNo", obj.getSerialNo());
//				// as Dtails
//				map.put("filterCode", obj.getFilterCode());
//				map.put("chargesFoc", obj.getChargesFoc());
//				map.put("exchangeId", obj.getExchangeId());
//				map.put("salesPrice", obj.getSalesPrice());
//				map.put("filterChangeQty", obj.getFilterChangeQty());
//				map.put("partsType", obj.getPartsType());
//				map.put("filterBarcdSerialNo", obj.getFilterBarcdSerialNo());
//
//				list.add(map);
//			}
//		}
//
//	return list;
//}


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

	public int getLabourCharge() {
		return labourCharge;
	}

	public void setLabourCharge(int labourCharge) {
		this.labourCharge = labourCharge;
	}

	public int getDefectId() {
		return defectId;
	}

	public void setDefectId(int defectId) {
		this.defectId = defectId;
	}

	public int getDefectPartId() {
		return defectPartId;
	}

	public void setDefectPartId(int defectPartId) {
		this.defectPartId = defectPartId;
	}

	public int getDefectDetailReasonId() {
		return defectDetailReasonId;
	}

	public void setDefectDetailReasonId(int defectDetailReasonId) {
		this.defectDetailReasonId = defectDetailReasonId;
	}

	public int getSolutionReasonId() {
		return solutionReasonId;
	}

	public void setSolutionReasonId(int solutionReasonId) {
		this.solutionReasonId = solutionReasonId;
	}

	public int getDefectTypeId() {
		return defectTypeId;
	}

	public void setDefectTypeId(int defectTypeId) {
		this.defectTypeId = defectTypeId;
	}

	public String getInHouseRepairRemark() {
		return inHouseRepairRemark;
	}

	public void setInHouseRepairRemark(String inHouseRepairRemark) {
		this.inHouseRepairRemark = inHouseRepairRemark;
	}



	public String getInHouseRepairPromisedDate() {
		return inHouseRepairPromisedDate;
	}

	public void setInHouseRepairPromisedDate(String inHouseRepairPromisedDate) {
		this.inHouseRepairPromisedDate = inHouseRepairPromisedDate;
	}






	public String getInHouseRepairReplacementYN() {
		return inHouseRepairReplacementYN;
	}



	public void setInHouseRepairReplacementYN(String inHouseRepairReplacementYN) {
		this.inHouseRepairReplacementYN = inHouseRepairReplacementYN;
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

	public List<DtAfterServiceResultDetailForm> getPartList() {
		return partList;
	}

	public void setPartList(List<DtAfterServiceResultDetailForm> partList) {
		this.partList = partList;
	}







}
