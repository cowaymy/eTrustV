package com.coway.trust.api.mobile.logistics.audit;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockAuditResultDto", description = "StockAuditResultDto")
public class StockAuditResultDto {

	@ApiModelProperty(value = "실사 번호")
	private String invenAdjustNo;

	@ApiModelProperty(value = "실사 상태")
	private String adjustStatus;

	@ApiModelProperty(value = "실사 생성 날짜")
	private String adjustCreateDate;

	@ApiModelProperty(value = "실사 기준 일자 ")
	private String adjustBaseDate;

	@ApiModelProperty(value = "실사 위치 ")
	private String adjustLocation;

	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static StockAuditResultDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockAuditResultDto.class);
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

	public String getAdjustLocation() {
		return adjustLocation;
	}

	public void setAdjustLocation(String adjustLocation) {
		this.adjustLocation = adjustLocation;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
