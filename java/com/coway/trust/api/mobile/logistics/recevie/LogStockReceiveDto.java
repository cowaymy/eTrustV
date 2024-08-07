package com.coway.trust.api.mobile.logistics.recevie;

import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "LogStockReceiveDto", description = "공통코드 Dto")
public class LogStockReceiveDto {

	@ApiModelProperty(value = "SMO no")
	private String smoNo;

	@ApiModelProperty(value = "type(auto / manual)")
	private String reqType;

	@ApiModelProperty(value = "상태")
	private String reqStatus;

	@ApiModelProperty(value = "gi 요청자")
	private String giCustName;

	@ApiModelProperty(value = "gi locationCode")
	private String giLocationCode;

	@ApiModelProperty(value = "gi locationName")
	private String giLocationName;

	@ApiModelProperty(value = "gi 날짜")
	private String giDate;

	@ApiModelProperty(value = "gr 날짜")
	private String grDate;

	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	@ApiModelProperty(value = "시리얼 여부")
	private String serialRequireChkYn;

	@ApiModelProperty(value = "")
	private String fromLocId;

	@ApiModelProperty(value = "")
	private int scanQty;

	@ApiModelProperty(value = "")
	private String toLocId;
	private List<LogStockPartsReceiveDto> partsList = null;

	/*@ApiModelProperty(value = "Scan Qty")
	private int scanQty;*/

	public static LogStockReceiveDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, LogStockReceiveDto.class);
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

	public String getGiLocationName() {
		return giLocationName;
	}

	public void setGiLocationName(String giLocationName) {
		this.giLocationName = giLocationName;
	}

	public List<LogStockPartsReceiveDto> getPartsList() {
		return partsList;
	}

	public void setPartsList(List<LogStockPartsReceiveDto> partsList) {
		this.partsList = partsList;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

	public String getSerialRequireChkYn() {
		return serialRequireChkYn;
	}

	public void setSerialRequireChkYn(String serialRequireChkYn) {
		this.serialRequireChkYn = serialRequireChkYn;
	}

	public String getFromLocId() {
		return fromLocId;
	}

	public void setFromLocId(String fromLocId) {
		this.fromLocId = fromLocId;
	}

	public String getToLocId() {
		return toLocId;
	}

	public void setToLocId(String toLocId) {
		this.toLocId = toLocId;
	}

	public int getScanQty() {
		return scanQty;
	}

	public void setScanQty(int scanQty) {
		this.scanQty = scanQty;
	}

	/*public int getScanQty() {
		return scanQty;
	}

	public void setScanQty(int scanQty) {
		this.scanQty = scanQty;
	}*/

}
