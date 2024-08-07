package com.coway.trust.api.mobile.logistics.stockbyholder;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockByHolderListDto", description = "공통코드 Dto")
public class StockByHolderListDto {

	@ApiModelProperty(value = "Ct_CodyName")
	private String ctCodyName;

	@ApiModelProperty(value = "Ct_CodyId")
	private String ctCodyId;

	@ApiModelProperty(value = "CT/CODY 별 예정 수량")
	private int stockQty;

	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static StockByHolderListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockByHolderListDto.class);
	}

	public String getCtCodyName() {
		return ctCodyName;
	}

	public void setCtCodyName(String ctCodyName) {
		this.ctCodyName = ctCodyName;
	}

	public String getCtCodyId() {
		return ctCodyId;
	}

	public void setCtCodyId(String ctCodyId) {
		this.ctCodyId = ctCodyId;
	}

	public int getStockQty() {
		return stockQty;
	}

	public void setStockQty(int stockQty) {
		this.stockQty = stockQty;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
