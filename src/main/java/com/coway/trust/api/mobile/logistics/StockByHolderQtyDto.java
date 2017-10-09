package com.coway.trust.api.mobile.logistics;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockByHolderQtyDto", description = "공통코드 Dto")
public class StockByHolderQtyDto {

	@ApiModelProperty(value = "user Avail Qty")
	private int byUserAvailQty;

	@ApiModelProperty(value = "user In-Transit Qty")
	private int byUserInTransitQty;

	@ApiModelProperty(value = "rdc Avail Qty")
	private int byRdcAvailQty;

	@ApiModelProperty(value = "rdc In-Transit Qty")
	private int byRdcInTransitQty;

	@ApiModelProperty(value = "cdc Avail Qty")
	private int byCdcAvailQty;

	@ApiModelProperty(value = "cdc In-Transit Qty")
	private int byCdcInTransitQty;

	public static StockByHolderQtyDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockByHolderQtyDto.class);
	}

	public int getByUserAvailQty() {
		return byUserAvailQty;
	}

	public void setByUserAvailQty(int byUserAvailQty) {
		this.byUserAvailQty = byUserAvailQty;
	}

	public int getByUserInTransitQty() {
		return byUserInTransitQty;
	}

	public void setByUserInTransitQty(int byUserInTransitQty) {
		this.byUserInTransitQty = byUserInTransitQty;
	}

	public int getByRdcAvailQty() {
		return byRdcAvailQty;
	}

	public void setByRdcAvailQty(int byRdcAvailQty) {
		this.byRdcAvailQty = byRdcAvailQty;
	}

	public int getByRdcInTransitQty() {
		return byRdcInTransitQty;
	}

	public void setByRdcInTransitQty(int byRdcInTransitQty) {
		this.byRdcInTransitQty = byRdcInTransitQty;
	}

	public int getByCdcAvailQty() {
		return byCdcAvailQty;
	}

	public void setByCdcAvailQty(int byCdcAvailQty) {
		this.byCdcAvailQty = byCdcAvailQty;
	}

	public int getByCdcInTransitQty() {
		return byCdcInTransitQty;
	}

	public void setByCdcInTransitQty(int byCdcInTransitQty) {
		this.byCdcInTransitQty = byCdcInTransitQty;
	}

}
