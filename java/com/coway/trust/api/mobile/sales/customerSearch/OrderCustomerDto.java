package com.coway.trust.api.mobile.sales.customerSearch;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderCustomerDto", description = "공통코드 Dto")
public class OrderCustomerDto {

	@ApiModelProperty(value = "custExistYN")
	private String custExistYN;
	
	@ApiModelProperty(value = "custName")
	private String custName;
	
	@ApiModelProperty(value = "nricCompanyNo")
	private String nricCompanyNo;
	
	@ApiModelProperty(value = "customerType")
	private int customerType;
	
	@ApiModelProperty(value = "custBirthDay")
	private String custBirthDay;
	
	@ApiModelProperty(value = "custGender")
	private String custGender;
	
	@ApiModelProperty(value = "custAddrId")
	private int custAddrId;
	
	@ApiModelProperty(value = "customerId")
	private int customerId;
	
	@ApiModelProperty(value = "areaId")
	private String areaId;
	
	@ApiModelProperty(value = "country")
	private String country;
	
	@ApiModelProperty(value = "state")
	private String state;
	
	@ApiModelProperty(value = "city")
	private String city;
	
	@ApiModelProperty(value = "postCode")
	private String postCode;
	
	@ApiModelProperty(value = "area")
	private String area;
	
	@ApiModelProperty(value = "street")
	private String street;
	
	@ApiModelProperty(value = "addrDtl")
	private String addrDtl;

	public String getCustExistYN() {
		return custExistYN;
	}

	public void setCustExistYN(String custExistYN) {
		this.custExistYN = custExistYN;
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

	public int getCustAddrId() {
		return custAddrId;
	}

	public void setCustAddrId(int custAddrId) {
		this.custAddrId = custAddrId;
	}

	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}

	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getPostCode() {
		return postCode;
	}

	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getAddrDtl() {
		return addrDtl;
	}

	public void setAddrDtl(String addrDtl) {
		this.addrDtl = addrDtl;
	}
	
	public static OrderCustomerDto create(EgovMap egvoMap){
		return BeanConverter.toBean(egvoMap, OrderCustomerDto.class);
	}
	
}
