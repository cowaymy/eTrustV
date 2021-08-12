package com.coway.trust.api.mobile.logistics.filterinventorydisplay;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "FilterChangeDListDto", description = "FilterChangeDListDto")
public class FilterNotChangeDListDto {

	@ApiModelProperty(value = "부품코드")
	private int partsCode;
	@ApiModelProperty(value = "부품 id")
	private int partsId;
	@ApiModelProperty(value = "부품명")
	private String partsName;
	@ApiModelProperty(value = "교체 실패 날짜")
	private String failDate;
	@ApiModelProperty(value = "주문번호")
	private String orderNo;
	@ApiModelProperty(value = "고객명")
	private String custName;
	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static FilterNotChangeDListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, FilterNotChangeDListDto.class);
	}

	public int getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(int partsCode) {
		this.partsCode = partsCode;
	}

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

	public String getPartsName() {
		return partsName;
	}

	public void setPartsName(String partsName) {
		this.partsName = partsName;
	}

	public String getFailDate() {
		return failDate;
	}

	public void setFailDate(String failDate) {
		this.failDate = failDate;
	}

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
