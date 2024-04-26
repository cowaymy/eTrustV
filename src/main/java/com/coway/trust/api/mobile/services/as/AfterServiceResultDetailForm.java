package com.coway.trust.api.mobile.services.as;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceResultDetailForm", description = "AfterServiceResultDetailForm")
public class AfterServiceResultDetailForm {


	@ApiModelProperty(value = "필터 코드")
	private String filterCode;

	@ApiModelProperty(value = "foc??")
	private int chargesFoc;

	@ApiModelProperty(value = "chgid??")
	private int exchangeId;

	@ApiModelProperty(value = "filter price")
	private double salesPrice;

	@ApiModelProperty(value = "필터 교체 수량")
	private int filterChangeQty;

	@ApiModelProperty(value = "filter / sparepart / msc(Miscellaneous) 구분")
	private int partsType;

	@ApiModelProperty(value = "교체 필터 바코드")
	private String filterBarcdSerialNo;

	@ApiModelProperty(value = "기존 필터 바코드")
	private String retSmoSerialNo;

	private String isSmo;
	private String isSerialReplace;
	private String psRemark;

	private String resultNo; // INS or ASR
	private int resultSoId;
	private int insAccPartId;
	private String remark;
	private int crtUserId;

	public String getResultNo() {
		return resultNo;
	}

	public int getResultSoId() {
		return resultSoId;
	}

	public int getInsAccPartId() {
		return insAccPartId;
	}

	public String getRemark() {
		return remark;
	}

	public int getCrtUserId() {
		return crtUserId;
	}

	public void setResultNo(String resultNo) {
		this.resultNo = resultNo;
	}

	public void setResultSoId(int resultSoId) {
		this.resultSoId = resultSoId;
	}

	public void setInsAccPartId(int insAccPartId) {
		this.insAccPartId = insAccPartId;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}

	public String getFilterCode() {
		return filterCode;
	}

	public void setFilterCode(String filterCode) {
		this.filterCode = filterCode;
	}

	public int getChargesFoc() {
		return chargesFoc;
	}

	public void setChargesFoc(int chargesFoc) {
		this.chargesFoc = chargesFoc;
	}

	public int getExchangeId() {
		return exchangeId;
	}

	public void setExchangeId(int exchangeId) {
		this.exchangeId = exchangeId;
	}

	public double getSalesPrice() {
		return salesPrice;
	}

	public void setSalesPrice(double salesPrice) {
		this.salesPrice = salesPrice;
	}

	public int getFilterChangeQty() {
		return filterChangeQty;
	}

	public void setFilterChangeQty(int filterChangeQty) {
		this.filterChangeQty = filterChangeQty;
	}

	public int getPartsType() {
		return partsType;
	}

	public void setPartsType(int partsType) {
		this.partsType = partsType;
	}

	public String getFilterBarcdSerialNo() {
		return filterBarcdSerialNo;
	}

	public void setFilterBarcdSerialNo(String filterBarcdSerialNo) {
		this.filterBarcdSerialNo = filterBarcdSerialNo;
	}

	public String getRetSmoSerialNo() {
		return retSmoSerialNo;
	}

	public void setRetSmoSerialNo(String retSmoSerialNo) {
		this.retSmoSerialNo = retSmoSerialNo;
	}

	public String getIsSmo() {
		return isSmo;
	}

	public void setIsSmo(String isSmo) {
		this.isSmo = isSmo;
	}

	public String getIsSerialReplace() {
		return isSerialReplace;
	}

	public void setIsSerialReplace(String isSerialReplace) {
		this.isSerialReplace = isSerialReplace;
	}

	public String getPsRemark() {
		return psRemark;
	}

	public void setPsRemark(String psRemark) {
		this.psRemark = psRemark;
	}

	public static List<Map<String, Object>>  createMaps(List<AfterServiceResultDetailForm> afterServiceResultDetailForms) {

		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> map;

//		map = BeanConverter.toMap(afterServiceResultForm, "partList");

		for(AfterServiceResultDetailForm form : afterServiceResultDetailForms){
			map = BeanConverter.toMap(form);
			list.add(map);
		}

		return list;
	}










}
