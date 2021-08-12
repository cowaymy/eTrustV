package com.coway.trust.api.mobile.sales.orderAddrSearch;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderAddressDto", description = "공통코드 Dto")
public class OrderAddressDto {
	
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
	
	@ApiModelProperty(value = "areaId")
	private String areaId;

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

	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}

	public static OrderAddressDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, OrderAddressDto.class);
	}

	
}
