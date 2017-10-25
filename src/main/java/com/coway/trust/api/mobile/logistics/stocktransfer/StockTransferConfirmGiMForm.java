package com.coway.trust.api.mobile.logistics.stocktransfer;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferConfirmGIForm", description = "StockTransferConfirmGIForm")
public class StockTransferConfirmGiMForm {

	@ApiModelProperty(value = "userId")
	private String userId;
	@ApiModelProperty(value = "요청일(YYYYMMDD)")
	private String requestDate;

	@ApiModelProperty(value = "SMO no")
	private String smoNo;

	@ApiModelProperty(value = "''GI' 고정값")
	private String reqStatus;

	@ApiModelProperty(value = "InventoryReqTransferDetail")
	private List<StockTransferConfirmGiDForm> stockTransferConfirmGiDetail;

	public List<Map<String, Object>> createMaps(StockTransferConfirmGiMForm stockTransferConfirmGiMForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (stockTransferConfirmGiDetail != null && stockTransferConfirmGiDetail.size() > 0) {
			Map<String, Object> map;
			for (StockTransferConfirmGiDForm dtl : stockTransferConfirmGiDetail) {
				map = BeanConverter.toMap(stockTransferConfirmGiMForm, "stockTransferConfirmGiDetail");
				// heartDtails
				map.put("smoNoItem", dtl.getSmoNoItem());
				map.put("partsCode", dtl.getPartsCode());
				map.put("partsId", dtl.getPartsId());
				map.put("serialNo", dtl.getSerialNo());
				map.put("requestQty", dtl.getRequestQty());
				map.put("partsName", dtl.getPartsName());

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

	public List<StockTransferConfirmGiDForm> getStockTransferConfirmGiDetail() {
		return stockTransferConfirmGiDetail;
	}

	public void setStockTransferConfirmGiDetail(List<StockTransferConfirmGiDForm> stockTransferConfirmGiDetail) {
		this.stockTransferConfirmGiDetail = stockTransferConfirmGiDetail;
	}

}
