package com.coway.trust.api.mobile.sales.orderCostCalc;

import java.math.BigDecimal;

import com.coway.trust.api.mobile.sales.orderProductList.OrderProductDto;
import com.coway.trust.util.BeanConverter;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderCostCalcDto", description = "공통코드 Dto")
public class OrderCostCalcDto {
	
	@ApiModelProperty(value = "normalPriceRpfAmt")
	private BigDecimal normalPriceRpfAmt;
	
	@ApiModelProperty(value = "finalPriceRpfAmt")
	private BigDecimal finalPriceRpfAmt;
	
	@ApiModelProperty(value = "normalRentalFeeAmt")
	private BigDecimal normalRentalFeeAmt;
	
	@ApiModelProperty(value = "finalRentalFeeAmt")
	private BigDecimal finalRentalFeeAmt;

	@ApiModelProperty(value = "totalPv")
	private BigDecimal totalPv;

	@ApiModelProperty(value = "totalPvGst")
	private BigDecimal totalPvGst;

	public BigDecimal getNormalPriceRpfAmt() {
		return normalPriceRpfAmt;
	}

	public void setNormalPriceRpfAmt(BigDecimal normalPriceRpfAmt) {
		this.normalPriceRpfAmt = normalPriceRpfAmt;
	}

	public BigDecimal getFinalPriceRpfAmt() {
		return finalPriceRpfAmt;
	}

	public void setFinalPriceRpfAmt(BigDecimal finalPriceRpfAmt) {
		this.finalPriceRpfAmt = finalPriceRpfAmt;
	}

	public BigDecimal getNormalRentalFeeAmt() {
		return normalRentalFeeAmt;
	}

	public void setNormalRentalFeeAmt(BigDecimal normalRentalFeeAmt) {
		this.normalRentalFeeAmt = normalRentalFeeAmt;
	}

	public BigDecimal getFinalRentalFeeAmt() {
		return finalRentalFeeAmt;
	}

	public void setFinalRentalFeeAmt(BigDecimal finalRentalFeeAmt) {
		this.finalRentalFeeAmt = finalRentalFeeAmt;
	}
		
	public BigDecimal getTotalPv() {
		return totalPv;
	}

	public void setTotalPv(BigDecimal totalPv) {
		this.totalPv = totalPv;
	}

	public BigDecimal getTotalPvGst() {
		return totalPvGst;
	}

	public void setTotalPvGst(BigDecimal totalPvGst) {
		this.totalPvGst = totalPvGst;
	}

	public static OrderCostCalcDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, OrderCostCalcDto.class);
	}
}
