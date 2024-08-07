package com.coway.trust.api.mobile.common;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "BankAllDto", description = "BankAllDto")
public class BankAllDto {

	@ApiModelProperty(value = "BANK 아이디")
	private int bankId;
	@ApiModelProperty(value = "BANK 코드")
	private String bankCode;
	@ApiModelProperty(value = "BANK 명")
	private String bankName;
	@ApiModelProperty(value = "사용 여부 [ 1 : 사용, 8 : 미사용]")
	private int stusCodeId;

	public static BankAllDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, BankAllDto.class);
	}

	public int getBankId() {
		return bankId;
	}

	public void setBankId(int bankId) {
		this.bankId = bankId;
	}

	public String getBankCode() {
		return bankCode;
	}

	public void setBankCode(String bankCode) {
		this.bankCode = bankCode;
	}

	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}
}
