package com.coway.trust.api.mobile.logistics;

import java.util.List;

import com.coway.trust.biz.logistics.stockmovement.vo.StrockMovementVoForMobile;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockRequestStatusDto", description = "StockRequestStatusDto")
public class StockRequestStatusDto {

	@ApiModelProperty(value = "SMO no")
	private String smoNo;
	@ApiModelProperty(value = "요청 type(auto / manual)")
	private String reqType;
	@ApiModelProperty(value = "상태")
	private String reqStatus;
	@ApiModelProperty(value = "gi 요청자")
	private String giCustName;
	@ApiModelProperty(value = "gi locationCode")
	private String giLocationCode;
	@ApiModelProperty(value = "gi 날짜")
	private String giDate;
	@ApiModelProperty(value = "gr 날짜")
	private String grDate;
	@ApiModelProperty(value = "부룸 리스트")
	// private String partsList;
	private List<StockRequestStatusDto> partsList;

	@ApiModelProperty(value = "SMO item no")
	private String smoNoItem;
	@ApiModelProperty(value = "부품코드")
	private String partsCode;
	@ApiModelProperty(value = "부품명")
	private String partsName;
	@ApiModelProperty(value = "요청수량")
	private String requestQty;
	@ApiModelProperty(value = "부품 sn")
	private String serialNo;
	@ApiModelProperty(value = "선택 수량")
	private String selectQty;

	public static StockRequestStatusDto create(StrockMovementVoForMobile tmp) {
		// TODO Auto-generated method stub
		StockRequestStatusDto dto = new StockRequestStatusDto();
		dto.setSmoNo(tmp.getSmoNo());
		dto.setReqType(tmp.getReqType());
		dto.setReqStatus(tmp.getReqStatus());
		dto.setGiCustName(tmp.getGiCustName());
		dto.setGiLocationCode(tmp.getGiLocationCode());
		dto.setGiDate(tmp.getGiDate());
		dto.setGrDate(tmp.getGrDate());
		return dto;
	}

	public String getSmoNo() {
		return smoNo;
	}

	public void setSmoNo(String smoNo) {
		this.smoNo = smoNo;
	}

	public String getReqType() {
		return reqType;
	}

	public void setReqType(String reqType) {
		this.reqType = reqType;
	}

	public String getReqStatus() {
		return reqStatus;
	}

	public void setReqStatus(String reqStatus) {
		this.reqStatus = reqStatus;
	}

	public String getGiCustName() {
		return giCustName;
	}

	public void setGiCustName(String giCustName) {
		this.giCustName = giCustName;
	}

	public String getGiLocationCode() {
		return giLocationCode;
	}

	public void setGiLocationCode(String giLocationCode) {
		this.giLocationCode = giLocationCode;
	}

	public String getGiDate() {
		return giDate;
	}

	public void setGiDate(String giDate) {
		this.giDate = giDate;
	}

	public String getGrDate() {
		return grDate;
	}

	public void setGrDate(String grDate) {
		this.grDate = grDate;
	}

	// public String getPartsList() {
	// return partsList;
	// }
	//
	// public void setPartsList(String partsList) {
	// this.partsList = partsList;
	// }
	public List<StockRequestStatusDto> getPartsList() {
		return partsList;
	}

	public void setPartsList(List<StockRequestStatusDto> partsList) {
		this.partsList = partsList;
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
