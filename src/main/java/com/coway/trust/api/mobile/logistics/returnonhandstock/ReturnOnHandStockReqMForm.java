package com.coway.trust.api.mobile.logistics.returnonhandstock;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ReturnOnHandStockReqMForm", description = "ReturnOnHandStockReqMForm")
public class ReturnOnHandStockReqMForm {

	@ApiModelProperty(value = "userId")
	private String userId;

	@ApiModelProperty(value = "요청일(YYYYMMDD)")
	private String requestDate;

	@ApiModelProperty(value = "이동유형(UM93)")
	private String smType;

	@ApiModelProperty(value = "요청 RDC or CD/CT")
	private String targetLocation;

	@ApiModelProperty(value = "InventoryReqTransferDetail")
	private List<ReturnOnHandStockReqDForm> inventoryReqTransferDetail;

	public List<Map<String, Object>> createMaps(ReturnOnHandStockReqMForm inventoryReqTransferMForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (inventoryReqTransferDetail != null && inventoryReqTransferDetail.size() > 0) {
			Map<String, Object> map;
			for (ReturnOnHandStockReqDForm dtl : inventoryReqTransferDetail) {
				map = BeanConverter.toMap(inventoryReqTransferMForm, "inventoryReqTransferDetail");
				// heartDtails
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

	public List<ReturnOnHandStockReqDForm> getInventoryReqTransferDetail() {
		return inventoryReqTransferDetail;
	}

	public void setInventoryReqTransferDetail(List<ReturnOnHandStockReqDForm> inventoryReqTransferDetail) {
		this.inventoryReqTransferDetail = inventoryReqTransferDetail;
	}

	public String getTargetLocation() {
		return targetLocation;
	}

	public void setTargetLocation(String targetLocation) {
		this.targetLocation = targetLocation;
	}

	public String getSmType() {
		return smType;
	}

	public void setSmType(String smType) {
		this.smType = smType;
	}

}
