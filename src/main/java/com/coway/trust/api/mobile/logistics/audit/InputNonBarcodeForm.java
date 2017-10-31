package com.coway.trust.api.mobile.logistics.audit;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InputNonBarcodeForm", description = "InputNonBarcodeForm")
public class InputNonBarcodeForm {

	@ApiModelProperty(value = "userId")
	private String userId;

	@ApiModelProperty(value = "실사 번호")
	private String invenAdjustNo;

	@ApiModelProperty(value = "실사일자(YYYYMMDD)")
	private String countedDate;

	@ApiModelProperty(value = "partsList")
	private List<InputNonBarcodePartsForm> inputNonBarcodePartsForm;

	public List<Map<String, Object>> createMaps(InputNonBarcodeForm InputNonBarcodeForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (inputNonBarcodePartsForm != null && inputNonBarcodePartsForm.size() > 0) {
			Map<String, Object> map;
			for (InputNonBarcodePartsForm obj : inputNonBarcodePartsForm) {
				map = BeanConverter.toMap(InputNonBarcodeForm, "InputNonBarcodeForm");
				// heartDtails
				map.put("partsCode", obj.getPartsCode());
				map.put("partsId", obj.getPartsId());
				map.put("countedQty", obj.getCountedQty());
				map.put("invenAdjustNo", obj.getInvenAdjustNo());
				map.put("invenAdjustNoItem", obj.getInvenAdjustNoItem());
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

	public String getInvenAdjustNo() {
		return invenAdjustNo;
	}

	public void setInvenAdjustNo(String invenAdjustNo) {
		this.invenAdjustNo = invenAdjustNo;
	}

	public String getCountedDate() {
		return countedDate;
	}

	public void setCountedDate(String countedDate) {
		this.countedDate = countedDate;
	}

	public List<InputNonBarcodePartsForm> getInputNonBarcodePartsForm() {
		return inputNonBarcodePartsForm;
	}

	public void setInputNonBarcodePartsForm(List<InputNonBarcodePartsForm> inputNonBarcodePartsForm) {
		this.inputNonBarcodePartsForm = inputNonBarcodePartsForm;
	}

}
