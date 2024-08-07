package com.coway.trust.api.mobile.sales.registerCustomer;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "RegCustomerForm", description = "공통코드 Form")
public class RegCustomerForm {
	
	@ApiModelProperty(value = "custName [default : '' 전체] 예) test name ", example = "test name")
	private String custName;
	
	@ApiModelProperty(value = "nricCompanyNo [default : '' 전체] 예) 900101 ", example = "900101")
	private String nricCompanyNo;
	
	@ApiModelProperty(value = "customerType [default : '' 전체] 예) 964 ", example = "964")
	private int customerType;
	
	@ApiModelProperty(value = "custInitials [default : '' 전체] 예) 115 ", example = "115")
	private int custInitials;
	
	@ApiModelProperty(value = "custBirthDay [default : '' 전체] 예) DD/MM/YYYY ", example = "11/09/1986")
	private String custBirthDay;
	
	@ApiModelProperty(value = "custGender [default : '' 전체] 예) F ", example = "F")
	private String custGender;
	
	@ApiModelProperty(value = "custRace [default : '' 전체] 예) 10 ", example = "10")
	private int custRace;
	
	@ApiModelProperty(value = "loginUserName [default : '' 전체] 예) IVYLIM ", example = "IVYLIM")
	private String loginUserName;
	
	public static Map<String, Object> createMap(RegCustomerForm custForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("custName", custForm.getCustName());
		params.put("nricCompanyNo", custForm.getNricCompanyNo());
		params.put("customerType", custForm.getCustomerType());
		params.put("custInitials", custForm.getCustInitials());
		params.put("custBirthDay", custForm.getCustBirthDay());
		params.put("custGender", custForm.getCustGender());
		params.put("custRace", custForm.getCustRace());
		params.put("loginUserName", custForm.getLoginUserName());
		
		return params;
	}

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getNricCompanyNo() {
		return nricCompanyNo;
	}

	public void setNricCompanyNo(String nricCompanyNo) {
		this.nricCompanyNo = nricCompanyNo;
	}

	public int getCustomerType() {
		return customerType;
	}

	public void setCustomerType(int customerType) {
		this.customerType = customerType;
	}

	public int getCustInitials() {
		return custInitials;
	}

	public void setCustInitials(int custInitials) {
		this.custInitials = custInitials;
	}

	public String getCustBirthDay() {
		return custBirthDay;
	}

	public void setCustBirthDay(String custBirthDay) {
		this.custBirthDay = custBirthDay;
	}

	public String getCustGender() {
		return custGender;
	}

	public void setCustGender(String custGender) {
		this.custGender = custGender;
	}

	public int getCustRace() {
		return custRace;
	}

	public void setCustRace(int custRace) {
		this.custRace = custRace;
	}

	public String getLoginUserName() {
		return loginUserName;
	}

	public void setLoginUserName(String loginUserName) {
		this.loginUserName = loginUserName;
	}
	
	
}
