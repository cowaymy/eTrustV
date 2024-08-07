package com.coway.trust.api.mobile.logistics.stocktransfer;

import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferReqStatusMListDto", description = "공통코드 Dto")
public class StockTransferReqStatusMListDto {

	@ApiModelProperty(value = "SMO no")
	private String smoNo;

	@ApiModelProperty(value = "type(auto / manual)")
	private String reqType;

	@ApiModelProperty(value = "상태")
	private String reqStatus;

	@ApiModelProperty(value = "요청자")
	private String requestorName;

	@ApiModelProperty(value = "요청일 (YYYYMMDD)")
	private String reqDate;

	@ApiModelProperty(value = "Location ID")
	private String rdcCode;

	@ApiModelProperty(value = "From Loc Id")
	private String fromLocId;

	@ApiModelProperty(value = "To Loc Id")
	private String toLocId;

	/*@ApiModelProperty(value = "Scan Qty")
	private int scanQty;*/

	public List<StockTransferReqStatusDListDto> getPartsList() {
		return partsList;
	}

	public void setPartsList(List<StockTransferReqStatusDListDto> partsList) {
		this.partsList = partsList;
	}

	private List<StockTransferReqStatusDListDto> partsList = null;

	public static StockTransferReqStatusMListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockTransferReqStatusMListDto.class);
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

	public String getRequestorName() {
		return requestorName;
	}

	public void setRequestorName(String requestorName) {
		this.requestorName = requestorName;
	}

	public String getReqDate() {
		return reqDate;
	}

	public void setReqDate(String reqDate) {
		this.reqDate = reqDate;
	}

	public String getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(String rdcCode) {
		this.rdcCode = rdcCode;
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

	/*public int getScanQty() {
		return scanQty;
	}

	public void setScanQty(int scanQty) {
		this.scanQty = scanQty;
	}*/

}
