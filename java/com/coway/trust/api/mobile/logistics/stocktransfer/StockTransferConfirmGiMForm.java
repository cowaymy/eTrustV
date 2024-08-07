package com.coway.trust.api.mobile.logistics.stocktransfer;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferConfirmGiMForm", description = "StockTransferConfirmGiMForm")
public class StockTransferConfirmGiMForm {

	@ApiModelProperty(value = "userId")
	private String userId;

	@ApiModelProperty(value = "요청일(YYYYMMDD)")
	private String requestDate;

	@ApiModelProperty(value = "SMO no")
	private String smoNo;

	@ApiModelProperty(value = "''GI' 고정값")
	private String reqStatus;

	@ApiModelProperty(value = "SMO item no")
	private int smoNoItem;

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "요청수량")
	private int requestQty;

	@ApiModelProperty(value = "부품 이름")
	private String partsName;

	@ApiModelProperty(value = "stockTransferConfirmGiDetail")
	private List<StockTransferConfirmGiDForm> stockTransferConfirmGiDetail;
					
	public List<Map<String, Object>> createMaps(StockTransferConfirmGiMForm stockTransferConfirmGiMForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (stockTransferConfirmGiDetail != null && stockTransferConfirmGiDetail.size() > 0) {
			Map<String, Object> map;
			for (StockTransferConfirmGiDForm dtl : stockTransferConfirmGiDetail) {
				map = BeanConverter.toMap(stockTransferConfirmGiMForm, "stockTransferConfirmGiDetail");
				// heartDtails
				map.put("SerialNo", dtl.getSerialNo());

				list.add(map);
			}
		}
		return list;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRequestDate() {
		return requestDate;
	}

	public void setRequestDate(String requestDate) {
		this.requestDate = requestDate;
	}

	public String getSmoNo() {
		return smoNo;
	}

	public void setSmoNo(String smoNo) {
		this.smoNo = smoNo;
	}

	public String getReqStatus() {
		return reqStatus;
	}

	public void setReqStatus(String reqStatus) {
		this.reqStatus = reqStatus;
	}

	public int getSmoNoItem() {
		return smoNoItem;
	}

	public void setSmoNoItem(int smoNoItem) {
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

	public int getRequestQty() {
		return requestQty;
	}

	public void setRequestQty(int requestQty) {
		this.requestQty = requestQty;
	}

	public String getPartsName() {
		return partsName;
	}

	public void setPartsName(String partsName) {
		this.partsName = partsName;
	}

	public List<StockTransferConfirmGiDForm> getStockTransferConfirmGiDetail() {
		return stockTransferConfirmGiDetail;
	}

	public void setStockTransferConfirmGiDetail(List<StockTransferConfirmGiDForm> stockTransferConfirmGiDetail) {
		this.stockTransferConfirmGiDetail = stockTransferConfirmGiDetail;
	}

}
