package com.coway.trust.api.mobile.sales.royaltyCustomerApi;

import com.coway.trust.api.mobile.sales.productInfoListApi.ProductInfoListApiDto;
import com.coway.trust.util.BeanConverter;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import java.math.BigDecimal;



@ApiModel(value = "RoyaltyCustomerListApiDto", description = "RoyaltyCustomerListApiDto")
public class RoyaltyCustomerListApiDto {

	@SuppressWarnings("unchecked")
	public static RoyaltyCustomerListApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, RoyaltyCustomerListApiDto.class);
	}


	private int loyaltyId;
	private int salesOrdId;
	private int salesOrdNo;
	private int hpCode;
	private String custID;
	private String custName;








	public int getLoyaltyId() {
		return loyaltyId;
	}
	public void setLoyaltyId(int loyaltyId) {
		this.loyaltyId = loyaltyId;
	}
	public int getSalesOrdId() {
		return salesOrdId;
	}
	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}
	public int getSalesOrdNo() {
		return salesOrdNo;
	}
	public void setSalesOrdNo(int salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}
	public int getHpCode() {
		return hpCode;
	}
	public void setHpCode(int hpCode) {
		this.hpCode = hpCode;
	}
	public String getCustID() {
		return custID;
	}
	public void setCustID(String custID) {
		this.custID = custID;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}















}
