package com.coway.trust.api.mobile.logistics.hiCare;

import java.text.DecimalFormat;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HiCareInventoryDto", description = "HiCareInventoryDto")
public class HiCareInventoryDto {

	@ApiModelProperty(value = "부품코드")
	String serialNo;

	@ApiModelProperty(value = "부품코드")
	String model;

	@ApiModelProperty(value = "부품코드")
	String status;

	@ApiModelProperty(value = "부품코드")
	String condition;

	@ApiModelProperty(value = "부품코드")
	String filterSn;

	@ApiModelProperty(value = "부품코드")
	String filterChgPeriod;

	@ApiModelProperty(value = "부품코드")
	String filterChgDt;

	@ApiModelProperty(value = "부품코드")
	String filterNextChgPeriod;

	@ApiModelProperty(value = "부품코드")
	String redFlag;

	public String getSerialNo() {
		return serialNo;
	}

	public String getModel() {
		return model;
	}

	public String getStatus() {
		return status;
	}

	public String getCondition() {
		return condition;
	}

	public String getFilterSn() {
		return filterSn;
	}

	public String getFilterChgPeriod() {
		return filterChgPeriod;
	}

	public String getFilterChgDt() {
		return filterChgDt;
	}

	public String getFilterNextChgPeriod() {
		return filterNextChgPeriod;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public void setModel(String model) {
		this.model = model;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public void setCondition(String condition) {
		this.condition = condition;
	}

	public void setFilterSn(String filterSn) {
		this.filterSn = filterSn;
	}

	public void setFilterChgPeriod(String filterChgPeriod) {
		this.filterChgPeriod = filterChgPeriod;
	}

	public void setFilterChgDt(String filterChgDt) {
		this.filterChgDt = filterChgDt;
	}

	public void setFilterNextChgPeriod(String filterNextChgPeriod) {
		this.filterNextChgPeriod = filterNextChgPeriod;
	}

	public String getRedFlag() {
		return redFlag;
	}

	public void setRedFlag(String redFlag) {
		this.redFlag = redFlag;
	}

	public static HiCareInventoryDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, HiCareInventoryDto.class);
	}

}
