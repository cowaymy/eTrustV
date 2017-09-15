package com.coway.trust.api.mobile.common;

import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "DefectMasterDto", description = "DefectMasterDto")
public class DefectMasterDto {

	@ApiModelProperty(value = "타입 아이디")
	private int typeId;
	@ApiModelProperty(value = "타입 코드")
	private String typeCode;
	@ApiModelProperty(value = "타입 설명")
	private String typeDesc;
	@ApiModelProperty(value = "코드 Disable 여부 ( 0 : enable, 1 : disable)")
	private int codeDisab;

	public static DefectMasterDto create(EgovMap egvoMap) {
		DefectMasterDto dto = new DefectMasterDto();
		dto.setTypeId(CommonUtils.getInt(egvoMap.get("defeCtMasterTypeId")));
		dto.setTypeCode((String) egvoMap.get("defeCtMasterCode"));
		dto.setTypeDesc((String) egvoMap.get("defeCtMasterDesc"));
		dto.setCodeDisab(CommonUtils.getInt(egvoMap.get("disab")));
		return dto;
	}

	public int getTypeId() {
		return typeId;
	}

	public void setTypeId(int typeId) {
		this.typeId = typeId;
	}

	public String getTypeCode() {
		return typeCode;
	}

	public void setTypeCode(String typeCode) {
		this.typeCode = typeCode;
	}

	public String getTypeDesc() {
		return typeDesc;
	}

	public void setTypeDesc(String typeDesc) {
		this.typeDesc = typeDesc;
	}

	public int getCodeDisab() {
		return codeDisab;
	}

	public void setCodeDisab(int codeDisab) {
		this.codeDisab = codeDisab;
	}
}
