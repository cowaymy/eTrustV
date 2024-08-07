package com.coway.trust.api.mobile.common;

import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "DefectDetailDto", description = "DefectDetailDto")
public class DefectDetailDto {

	@ApiModelProperty(value = "타입 아이디")
	private int typeId;
	@ApiModelProperty(value = "defect 아이디")
	private int defectId;
	@ApiModelProperty(value = "defect 코드")
	private String defectCode;
	@ApiModelProperty(value = "defectId 설명")
	private String defectDesc;
	@ApiModelProperty(value = "prodCat")
	private String prodCat;

	public static DefectDetailDto create(EgovMap egvoMap) {
		DefectDetailDto dto = new DefectDetailDto();
		dto.setTypeId(CommonUtils.getInt(egvoMap.get("resnTypeId")));
		dto.setDefectId(CommonUtils.getInt(egvoMap.get("resnId")));
		dto.setDefectCode((String) egvoMap.get("resnCode"));
		dto.setDefectDesc((String) egvoMap.get("resnDesc"));
		if (egvoMap.get("prodCat") != null) {
			dto.setProdCat((String) egvoMap.get("prodCat"));
		}
		return dto;
	}

	public int getTypeId() {
		return typeId;
	}

	public void setTypeId(int typeId) {
		this.typeId = typeId;
	}

	public int getDefectId() {
		return defectId;
	}

	public void setDefectId(int defectId) {
		this.defectId = defectId;
	}

	public String getDefectCode() {
		return defectCode;
	}

	public void setDefectCode(String defectCode) {
		this.defectCode = defectCode;
	}

	public String getDefectDesc() {
		return defectDesc;
	}

	public void setDefectDesc(String defectDesc) {
		this.defectDesc = defectDesc;
	}

	public String getProdCat() {
		return prodCat;
	}

	public void setProdCat(String prodCat) {
		this.prodCat = prodCat;
	}
}
