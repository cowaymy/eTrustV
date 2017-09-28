package com.coway.trust.api.mobile.logistics;

import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "BarcodeListDto", description = "BarcodeListDto")
public class BarcodeListDto {

	@ApiModelProperty(value = "재고 실사  번호")
	private String invenAdjustNo;
	@ApiModelProperty(value = "재고 실사 상태")
	private String adjustStatus;
	@ApiModelProperty(value = "재고 실사 생성일")
	private String adjustCreateDate;
	@ApiModelProperty(value = "재고 실사 기준일")
	private String adjustBaseDate;
	@ApiModelProperty(value = "재고 실사 location")
	private int adjustLocation;
	@ApiModelProperty(value = "재고 실사 systemQty")
	private int adjustNormalQty;
	@ApiModelProperty(value = "재고 실사 Not Counted")
	private int adjustNotQty;
	@ApiModelProperty(value = "재고 실사  Counted")
	private int adjustQty;
	@ApiModelProperty(value = "재고 실사  Item No")
	private int invenAdjustNoItem;
	@ApiModelProperty(value = "재고 실사 Item code")
	private String partsCode;
	@ApiModelProperty(value = "재고 실사 Item Name")
	private String partsName;
	@ApiModelProperty(value = "재고 실사 serialNo")
	private String serialNo;

	public static BarcodeListDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		BarcodeListDto dto = new BarcodeListDto();

		dto.setInvenAdjustNo((String) egvoMap.get("invntryNo"));
		dto.setAdjustStatus((String) egvoMap.get("saveYn"));
		dto.setAdjustCreateDate((String) egvoMap.get("crtDate"));
		dto.setAdjustBaseDate((String) egvoMap.get("baseDt"));
		dto.setAdjustLocation(CommonUtils.getInt(egvoMap.get("locId")));
		dto.setAdjustNormalQty(CommonUtils.getInt(egvoMap.get("sysQty")));
		dto.setAdjustNotQty(CommonUtils.getInt(egvoMap.get("diffQty")));
		dto.setAdjustQty(CommonUtils.getInt(egvoMap.get("cntQty")));
		dto.setInvenAdjustNoItem(CommonUtils.getInt(egvoMap.get("itmId")));
		dto.setPartsCode((String) egvoMap.get("stkCode"));
		dto.setPartsName((String) egvoMap.get("itmNm"));
		dto.setSerialNo((String) egvoMap.get("serialNo"));
		return dto;
	}

	public String getInvenAdjustNo() {
		return invenAdjustNo;
	}

	public void setInvenAdjustNo(String invenAdjustNo) {
		this.invenAdjustNo = invenAdjustNo;
	}

	public String getAdjustStatus() {
		return adjustStatus;
	}

	public void setAdjustStatus(String adjustStatus) {
		this.adjustStatus = adjustStatus;
	}

	public String getAdjustCreateDate() {
		return adjustCreateDate;
	}

	public void setAdjustCreateDate(String adjustCreateDate) {
		this.adjustCreateDate = adjustCreateDate;
	}

	public String getAdjustBaseDate() {
		return adjustBaseDate;
	}

	public void setAdjustBaseDate(String adjustBaseDate) {
		this.adjustBaseDate = adjustBaseDate;
	}

	public int getAdjustLocation() {
		return adjustLocation;
	}

	public void setAdjustLocation(int adjustLocation) {
		this.adjustLocation = adjustLocation;
	}

	public int getAdjustNormalQty() {
		return adjustNormalQty;
	}

	public void setAdjustNormalQty(int adjustNormalQty) {
		this.adjustNormalQty = adjustNormalQty;
	}

	public int getAdjustNotQty() {
		return adjustNotQty;
	}

	public void setAdjustNotQty(int adjustNotQty) {
		this.adjustNotQty = adjustNotQty;
	}

	public int getAdjustQty() {
		return adjustQty;
	}

	public void setAdjustQty(int adjustQty) {
		this.adjustQty = adjustQty;
	}

	public int getInvenAdjustNoItem() {
		return invenAdjustNoItem;
	}

	public void setInvenAdjustNoItem(int invenAdjustNoItem) {
		this.invenAdjustNoItem = invenAdjustNoItem;
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

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

}
