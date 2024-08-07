package com.coway.trust.api.mobile.logistics.filterinventorydisplay;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "FilterChangeDListDto", description = "FilterChangeDListDto")
public class FilterChangeDListDto {

	@ApiModelProperty(value = "부품코드")
	private String partsCode;
	@ApiModelProperty(value = "부품 id")
	private int partsId;
	@ApiModelProperty(value = "부품명")
	private String partsName;
	@ApiModelProperty(value = "교체대상 수량")
	private int tobeChangeQty;
	@ApiModelProperty(value = "보유재고 수량")
	private int onHandStockQty;
	@ApiModelProperty(value = "부족필터 여부")
	private String shortageYN;
	@ApiModelProperty(value = "대체필터 존재 유무")
	private String alternativeYN;
	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static FilterChangeDListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, FilterChangeDListDto.class);
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

	public String getShortageYN() {
		return shortageYN;
	}

	public void setShortageYN(String shortageYN) {
		this.shortageYN = shortageYN;
	}

	public String getAlternativeYN() {
		return alternativeYN;
	}

	public void setAlternativeYN(String alternativeYN) {
		this.alternativeYN = alternativeYN;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
