package com.coway.trust.api.mobile.logistics.stocktransfer;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.recevie.LogStockReceiveDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferSMOCntRespForm", description = "StockTransferSMOCntRespForm")
public class StockTransferSMOCntRespForm {

	@ApiModelProperty(value = "toRecCnt", example = "1")
	private String toRecCnt;

	@ApiModelProperty(value = "toMoveOutcnt", example = "1")
	private String toMoveOutCnt;

	public static StockTransferSMOCntRespForm create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockTransferSMOCntRespForm.class);
	}

	public static Map<String, Object> createMap(StockTransferSMOCntRespForm stockTransferRejectSMOReqForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("toRecCnt", stockTransferRejectSMOReqForm.getToRecCnt());
		params.put("toMoveOutCnt", stockTransferRejectSMOReqForm.getToMoveOutCnt());
		return params;
	}

	public String getToRecCnt() {
		return toRecCnt;
	}

	public void setToRecCnt(String toRecCnt) {
		this.toRecCnt = toRecCnt;
	}

	public String getToMoveOutCnt() {
		return toMoveOutCnt;
	}

	public void setToMoveOutCnt(String toMoveOutCnt) {
		this.toMoveOutCnt = toMoveOutCnt;
	}


}
