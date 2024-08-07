package com.coway.trust.api.mobile.logistics.filterinventorydisplay;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "UserFilterDListDto", description = "UserFilterDListDto")
public class UserFilterDListDto {

	@ApiModelProperty(value = "부품코드")
	private int partsCode;
	@ApiModelProperty(value = "부품 id")
	private int partsId;
	@ApiModelProperty(value = "부품명")
	private String partsName;
	@ApiModelProperty(value = "교체대상 수량")
	private int tobeChangeQty;
	@ApiModelProperty(value = "보유재고 수량")
	private int onHandStockQty;
	@ApiModelProperty(value = "부족필터 수량")
	private int shortageQty;
	@ApiModelProperty(value = "차용 cody/ct 코드 (예_CT123456)")
	private String targetUserId;
	@ApiModelProperty(value = "차용 cody/ct 명")
	private String targetUserName;
	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static UserFilterDListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, UserFilterDListDto.class);
	}

	public int getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(int partsCode) {
		this.partsCode = partsCode;
	}

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

	public String getPartsName() {
		return partsName;
	}

	public void setPartsName(String partsName) {
		this.partsName = partsName;
	}

	public int getTobeChangeQty() {
		return tobeChangeQty;
	}

	public void setTobeChangeQty(int tobeChangeQty) {
		this.tobeChangeQty = tobeChangeQty;
	}

	public int getOnHandStockQty() {
		return onHandStockQty;
	}

	public void setOnHandStockQty(int onHandStockQty) {
		this.onHandStockQty = onHandStockQty;
	}

	public int getShortageQty() {
		return shortageQty;
	}

	public void setShortageQty(int shortageQty) {
		this.shortageQty = shortageQty;
	}

	public String getTargetUserId() {
		return targetUserId;
	}

	public void setTargetUserId(String targetUserId) {
		this.targetUserId = targetUserId;
	}

	public String getTargetUserName() {
		return targetUserName;
	}

	public void setTargetUserName(String targetUserName) {
		this.targetUserName = targetUserName;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
