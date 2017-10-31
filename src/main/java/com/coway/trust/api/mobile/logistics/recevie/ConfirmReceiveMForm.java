package com.coway.trust.api.mobile.logistics.recevie;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ConfirmReceiveMForm", description = "ConfirmReceiveMForm")
public class ConfirmReceiveMForm {

	@ApiModelProperty(value = "userId")
	private String userId;

	@ApiModelProperty(value = "요청일(YYYYMMDD)")
	private String requestDate;

	@ApiModelProperty(value = "SMO no")
	private String smoNo;

	@ApiModelProperty(value = "''GR' 고정값")
	private String reqStatus;

	@ApiModelProperty(value = "confirmReceiveDetail")
	private List<ConfirmReceiveDForm> confirmReceiveDetail;

	public List<Map<String, Object>> createMaps(ConfirmReceiveMForm confirmReceiveMForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (confirmReceiveDetail != null && confirmReceiveDetail.size() > 0) {
			Map<String, Object> map;
			for (ConfirmReceiveDForm dtl : confirmReceiveDetail) {
				map = BeanConverter.toMap(confirmReceiveMForm, "confirmReceiveDetail");
				// heartDtails
				map.put("smoNoItem", dtl.getSmoNoItem());
				map.put("partsCode", dtl.getPartsCode());
				map.put("partsId", dtl.getPartsId());
				map.put("serialNo", dtl.getSerialNo());

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

	public List<ConfirmReceiveDForm> getConfirmReceiveDetail() {
		return confirmReceiveDetail;
	}

	public void setConfirmReceiveDetail(List<ConfirmReceiveDForm> confirmReceiveDetail) {
		this.confirmReceiveDetail = confirmReceiveDetail;
	}

}
