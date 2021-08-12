package com.coway.trust.api.mobile.common;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "CommonCodeDto", description = "공통코드 Dto")
public class CommonCodeDto {

	@ApiModelProperty(value = "코드 아이디")
	private int codeId;
	@ApiModelProperty(value = "코드 명")
	private String code;
	@ApiModelProperty(value = "코드 DESC")
	private String codeDesc;
	@ApiModelProperty(value = "코드 Disable 여부 ( 0 : enable, 1 : disable)")
	private int codeDisab;

	public static CommonCodeDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, CommonCodeDto.class);
	}

	public int getCodeId() {
		return codeId;
	}

	public void setCodeId(int codeId) {
		this.codeId = codeId;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getCodeDesc() {
		return codeDesc;
	}

	public void setCodeDesc(String codeDesc) {
		this.codeDesc = codeDesc;
	}

	public int getCodeDisab() {
		return codeDisab;
	}

	public void setCodeDisab(int codeDisab) {
		this.codeDisab = codeDisab;
	}

}
