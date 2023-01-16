package com.coway.trust.api.mobile.services.sales;

import com.coway.trust.api.mobile.logistics.ctcodylist.DisplayCt_CodyListDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

public class RentalServiceCustomerDto {
	@ApiModelProperty(value = "고객명")
	private String custName;

	@ApiModelProperty(value = "주문번호")
	private String salesOrderNo;

	@ApiModelProperty(value = "결제수단")
	private String paymentMode;

	@ApiModelProperty(value = "타겟금액")
	private int targetAmount;

	@ApiModelProperty(value = "실적금액")
	private int amount;

	private int paymentModeId;

	private String deductDt;

	private String status;

	private String monthType;


	public int getPaymentModeId() {
		return paymentModeId;
	}

	public void setPaymentModeId(int paymentModeId) {
		this.paymentModeId = paymentModeId;
	}

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getSalesOrderNo() {
		return salesOrderNo;
	}

	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}

	public String getPaymentMode() {
		return paymentMode;
	}

	public void setPaymentMode(String paymentMode) {
		this.paymentMode = paymentMode;
	}

	public int getTargetAmount() {
		return targetAmount;
	}

	public void setTargetAmount(int targetAmount) {
		this.targetAmount = targetAmount;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
	}

	public String getDeductDt() {
		return deductDt;
	}

	public void setDeductDt(String deductDt) {
		this.deductDt = deductDt;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getMonthType() {
		return monthType;
	}

	public void setMonthType(String monthType) {
		this.monthType = monthType;
	}

	public static RentalServiceCustomerDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, RentalServiceCustomerDto.class);
	}


}
