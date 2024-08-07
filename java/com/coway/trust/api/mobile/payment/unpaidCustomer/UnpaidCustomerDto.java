package com.coway.trust.api.mobile.payment.unpaidCustomer;

import java.math.BigDecimal;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "PaymentDto", description = "Payment Dto")
public class UnpaidCustomerDto {

    @ApiModelProperty(value = "salesOrdNo")
    private String salesOrdNo;

    @ApiModelProperty(value = "memCode")
    private String memCode;

    @ApiModelProperty(value = "outAmt")
    private BigDecimal outAmt;

    @ApiModelProperty(value = "custId")
    private int custId;

    @ApiModelProperty(value = "custName")
    private String custName;

    @ApiModelProperty(value = "rentDocTypeName")
    private String rentDocTypeName;

    @ApiModelProperty(value = "rentDocTypeId")
    private int rentDocTypeId;

    @ApiModelProperty(value = "rentDtTm")
    private String rentDtTm;


	public String getRentDtTm() {
		return rentDtTm;
	}

	public void setRentDtTm(String rentDtTm) {
		this.rentDtTm = rentDtTm;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getMemCode() {
		return memCode;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}

	public BigDecimal getOutAmt() {
		return outAmt;
	}

	public void setOutAmt(BigDecimal outAmt) {
		this.outAmt = outAmt;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getRentDocTypeName() {
		return rentDocTypeName;
	}

	public void setRentDocTypeName(String rentDocTypeName) {
		this.rentDocTypeName = rentDocTypeName;
	}

	public int getRentDocTypeId() {
		return rentDocTypeId;
	}

	public void setRentDocTypeId(int rentDocTypeId) {
		this.rentDocTypeId = rentDocTypeId;
	}

	public static UnpaidCustomerDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, UnpaidCustomerDto.class);
	}

}
