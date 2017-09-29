package com.coway.trust.api.mobile.logistics;

import com.coway.trust.biz.logistics.mlog.vo.StrockMovementVoForMobile;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockRequestStatusDto2", description = "StockRequestStatusDto2")
public class StockRequestStatusDto2 {

	@ApiModelProperty(value = "SMO item no")
	private String smoNoItem;
	@ApiModelProperty(value = "부품코드")
	private String partsCode;
	@ApiModelProperty(value = "부품명 id")
	private int partsId;
	@ApiModelProperty(value = "부품명")
	private String partsName;
	@ApiModelProperty(value = "요청수량")
	private String requestQty;
	@ApiModelProperty(value = "부품 sn")
	private String serialNo;
	@ApiModelProperty(value = "선택 수량")
	private String selectQty;

	public static StockRequestStatusDto2 create(StrockMovementVoForMobile tmp) {
		// TODO Auto-generated method stub
		StockRequestStatusDto2 dto = new StockRequestStatusDto2();
		dto.setSmoNoItem(tmp.getSmoNoItem());
		dto.setPartsCode(tmp.getPartsCode());
		dto.setPartsId(tmp.getPartsId());
		dto.setPartsName(tmp.getPartsName());
		dto.setRequestQty(tmp.getRequestQty());
		dto.setSerialNo(tmp.getSerialNo());
		dto.setSelectQty(tmp.getSelectQty());
		return dto;
	}

	public String getSmoNoItem() {
		return smoNoItem;
	}

	public void setSmoNoItem(String smoNoItem) {
		this.smoNoItem = smoNoItem;
	}

	public String getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(String partsCode) {
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

	public String getRequestQty() {
		return requestQty;
	}

	public void setRequestQty(String requestQty) {
		this.requestQty = requestQty;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getSelectQty() {
		return selectQty;
	}

	public void setSelectQty(String selectQty) {
		this.selectQty = selectQty;
	}

}
