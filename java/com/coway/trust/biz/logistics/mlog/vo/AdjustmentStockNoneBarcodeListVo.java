package com.coway.trust.biz.logistics.mlog.vo;

import java.io.Serializable;
import java.util.List;

import com.coway.trust.api.mobile.logistics.audit.NonBarcodeDListDto;

import io.swagger.annotations.ApiModelProperty;

public class AdjustmentStockNoneBarcodeListVo implements Serializable {

	private static final long serialVersionUID = -1031910048859710982L;

	@ApiModelProperty(value = "재고 실사  번호")
	private String invenAdjustNo;
	@ApiModelProperty(value = "재고 실사 상태")
	private String adjustStatus;
	@ApiModelProperty(value = "재고 실사 생성일")
	private String adjustCreateDate;
	@ApiModelProperty(value = "재고 실사 기준일")
	private String adjustBaseDate;
	@ApiModelProperty(value = "재고 실사 location")
	private String adjustLocation;
	@ApiModelProperty(value = "재고 실사 systemQty")
	private int adjustNormalQty;
	@ApiModelProperty(value = "재고 실사 Not Counted")
	private int adjustNotQty;
	@ApiModelProperty(value = "재고 실사  Counted")
	private int adjustQty;

	private List<NonBarcodeDListDto> adjustList;

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

	public String getAdjustLocation() {
		return adjustLocation;
	}

	public void setAdjustLocation(String adjustLocation) {
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

	public List<NonBarcodeDListDto> getAdjustList() {
		return adjustList;
	}

	public void setAdjustList(List<NonBarcodeDListDto> adjustList) {
		this.adjustList = adjustList;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
