package com.coway.trust.api.mobile.common;

import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "MalfunctionCodeDto", description = "MalfunctionCodeDto")
public class MalfunctionCodeDto {

	@ApiModelProperty(value = "타입 아이디")
	private int typeId;
	@ApiModelProperty(value = "타입 코드")
	private String typeCode;
	@ApiModelProperty(value = "타입 설명")
	private String desc;
	@ApiModelProperty(value = "사용 여부 [ 1 : 사용, 8 : 미사용]")
	private int stusCodeId;
	@ApiModelProperty(value = "prodCat")
	private String prodCat;



	public static MalfunctionCodeDto create(EgovMap egvoMap) {
		MalfunctionCodeDto dto = new MalfunctionCodeDto();
		dto.setTypeId(CommonUtils.getInt(egvoMap.get("errTypeId")));
		dto.setTypeCode((String) egvoMap.get("errTypeCode"));
		dto.setDesc((String) egvoMap.get("errTypeName"));
		dto.setStusCodeId(CommonUtils.getInt(egvoMap.get("stusCodeId")));
		dto.setProdCat((String) egvoMap.get("prodCat"));
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

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public String getProdCat() {
		return prodCat;
	}

	public void setProdCat(String prodCat) {
		this.prodCat = prodCat;
	}
}
