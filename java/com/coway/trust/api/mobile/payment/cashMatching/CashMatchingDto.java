package com.coway.trust.api.mobile.payment.cashMatching;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : CashMatchingDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 19.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "CashMatchingDto", description = "CashMatching Dto")
public class CashMatchingDto {

	@ApiModelProperty(value = "mobPayNo")
	private int mobPayNo;

	@ApiModelProperty(value = "salesOrdNo")
	private String salesOrdNo;

	@ApiModelProperty(value = "payAmt")
	private Double payAmt;

	@ApiModelProperty(value = "salesDt")
	private String salesDt;

	@ApiModelProperty(value = "name")
	private String name;

	@ApiModelProperty(value = "payMode")
	private String payMode;

	@ApiModelProperty(value = "stus")
	private String stus;


	public int getMobPayNo() {
		return mobPayNo;
	}

	public void setMobPayNo(int mobPayNo) {
		this.mobPayNo = mobPayNo;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public Double getPayAmt() {
		return payAmt;
	}

	public void setPayAmt(Double payAmt) {
		this.payAmt = payAmt;
	}

	public String getSalesDt() {
		return salesDt;
	}

	public void setSalesDt(String salesDt) {
		this.salesDt = salesDt;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPayMode() {
		return payMode;
	}

	public void setPayMode(String payMode) {
		this.payMode = payMode;
	}

	public String getStus() {
		return stus;
	}

	public void setStus(String stus) {
		this.stus = stus;
	}

	public static CashMatchingDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, CashMatchingDto.class);
	}
}
