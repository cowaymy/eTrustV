package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "BankAllForm", description = "BankAllForm")
public class BankAllForm {
	private static final int ALL = 99;

	@ApiModelProperty(value = "사용 여부(default : " + ALL + ") [ 1 : 사용, 8 : 미사용, " + ALL + " : 전체 ]")
	private int stusCodeId = ALL;

	public static Map<String, Object> createMap(BankAllForm bankAllForm) {
		Map<String, Object> map = BeanConverter.toMap(bankAllForm);
		return map;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}
}
