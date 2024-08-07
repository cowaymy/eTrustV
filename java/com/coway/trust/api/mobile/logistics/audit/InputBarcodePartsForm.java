package com.coway.trust.api.mobile.logistics.audit;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InputBarcodePartsForm", description = "InputBarcodePartsForm")
public class InputBarcodePartsForm {

	@ApiModelProperty(value = "userId")
	private String userId;

	@ApiModelProperty(value = "실사 번호")
	private String invenAdjustNo;

	@ApiModelProperty(value = "실사일자(YYYYMMDD)")
	private String countedDate;

	@ApiModelProperty(value = "부품코드")
	private String partsCode;

	@ApiModelProperty(value = "부품 id")
	private int partsId;

	@ApiModelProperty(value = "실사 item 번호")
	private int invenAdjustNoItem;

	@ApiModelProperty(value = "실사 수량")
	private int countedQty;

	@ApiModelProperty(value = "serialList")
	private List<InputBarcodeListForm> inputBarcodeListForm;

	public List<Map<String, Object>> createMaps(InputBarcodePartsForm InputBarcodePartsForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (inputBarcodeListForm != null && inputBarcodeListForm.size() > 0) {
			Map<String, Object> map;
			for (InputBarcodeListForm obj : inputBarcodeListForm) {
				map = BeanConverter.toMap(InputBarcodePartsForm, "InputBarcodePartsForm");
				// heartDtails
				map.put("serialNo", obj.getSerialNo());
				// map.put("invenAdjustNoItem", obj.getInvenAdjustNoItem());
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

	public int getInvenAdjustNoItem() {
		return invenAdjustNoItem;
	}

	public void setInvenAdjustNoItem(int invenAdjustNoItem) {
		this.invenAdjustNoItem = invenAdjustNoItem;
	}

	public int getCountedQty() {
		return countedQty;
	}

	public void setCountedQty(int countedQty) {
		this.countedQty = countedQty;
	}

	public List<InputBarcodeListForm> getInputBarcodeListForm() {
		return inputBarcodeListForm;
	}

	public void setInputBarcodeListForm(List<InputBarcodeListForm> inputBarcodeListForm) {
		this.inputBarcodeListForm = inputBarcodeListForm;
	}

}
