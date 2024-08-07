package com.coway.trust.api.mobile.payment.autodebit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

@ApiModel(value = "AutoDebitApiDto", description = "AutoDebitApiDto")
public class AutoDebitApiDto {
	private List<AutoDebitApiDto> list;
	//Order Result
	private int salesOrdId;
	private String salesOrdNo;
	private int custId;
	private String custName;
	private String custNric;
	private String statusDesc;
	private String userType;
	private Double totalOutstanding;
	private String createdDate;
	private Double monthlyRentalAmount;
	private String custEmail;
	private String custMobile;

	//History Result Additional Info
	private int padId;
	private String padNo;
	private String updatedDate;
	private String remarks;

	//Result
	private int responseCode;

	@SuppressWarnings("unchecked")
	public static AutoDebitApiDto create(EgovMap egovMap) {
		return BeanConverter.toBean(egovMap, AutoDebitApiDto.class);
	}

	public static Map<String, Object> createMap(AutoDebitApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("list", vo.getList());

		params.put("salesOrdId", vo.getSalesOrdId());
		params.put("salesOrdNo", vo.getSalesOrdNo());
		params.put("custId", vo.getCustId());
		params.put("custName", vo.getCustName());
		params.put("statusDesc", vo.getStatusDesc());
		params.put("userType", vo.getUserType());
		params.put("totalOutstanding", vo.getTotalOutstanding());
		params.put("createdDate", vo.getCreatedDate());
		params.put("custNric", vo.getCustNric());
		params.put("montlyRentalAmount", vo.getMonthlyRentalAmount());
		params.put("custEmail", vo.getCustEmail());
		params.put("custMobile", vo.getCustMobile());

		params.put("padId", vo.getPadId());
		params.put("padNo", vo.getPadNo());
		params.put("remarks", vo.getRemarks());
		params.put("updatedDate", vo.getUpdatedDate());
		params.put("responseCode", vo.getResponseCode());
		return params;
	}


	public List<AutoDebitApiDto> getList() {
		return list;
	}

	public void setList(List<AutoDebitApiDto> list) {
		this.list = list;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}


	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getCustNric() {
		return custNric;
	}

	public void setCustNric(String custNric) {
		this.custNric = custNric;
	}

	public String getStatusDesc() {
		return statusDesc;
	}

	public void setStatusDesc(String statusDesc) {
		this.statusDesc = statusDesc;
	}


	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public String getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public int getPadId() {
		return padId;
	}

	public void setPadId(int padId) {
		this.padId = padId;
	}

	public String getPadNo() {
		return padNo;
	}

	public void setPadNo(String padNo) {
		this.padNo = padNo;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getUpdatedDate() {
		return updatedDate;
	}

	public void setUpdatedDate(String updatedDate) {
		this.updatedDate = updatedDate;
	}

	public String getCustEmail() {
		return custEmail;
	}

	public void setCustEmail(String custEmail) {
		this.custEmail = custEmail;
	}

	public String getCustMobile() {
		return custMobile;
	}

	public void setCustMobile(String custMobile) {
		this.custMobile = custMobile;
	}

	public Double getTotalOutstanding() {
		return totalOutstanding;
	}

	public void setTotalOutstanding(Double totalOutstanding) {
		this.totalOutstanding = totalOutstanding;
	}

	public Double getMonthlyRentalAmount() {
		return monthlyRentalAmount;
	}

	public void setMonthlyRentalAmount(Double monthlyRentalAmount) {
		this.monthlyRentalAmount = monthlyRentalAmount;
	}

	public int getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(int responseCode) {
		this.responseCode = responseCode;
	}
}
