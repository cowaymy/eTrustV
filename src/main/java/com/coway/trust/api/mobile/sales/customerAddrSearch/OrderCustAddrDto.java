package com.coway.trust.api.mobile.sales.customerAddrSearch;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderCustAddrDto", description = "공통코드 Dto")
public class OrderCustAddrDto {
	
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
	
	@ApiModelProperty(value = "custAddId")
	private int custAddId;
	
	@ApiModelProperty(value = "areaId")
	private String areaId;
	
	@ApiModelProperty(value = "street")
	private String street;
	
	@ApiModelProperty(value = "addrDtl")
	private String addrDtl;
	
	@ApiModelProperty(value = "mainYn")
	private String mainYn;

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

	public int getCustAddId() {
		return custAddId;
	}

	public void setCustAddId(int custAddId) {
		this.custAddId = custAddId;
	}

	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
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

	public String getMainYn() {
		return mainYn;
	}

	public void setMainYn(String mainYn) {
		this.mainYn = mainYn;
	}

	public static OrderCustAddrDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, OrderCustAddrDto.class);
	}
}
