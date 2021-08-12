package com.coway.trust.api.mobile.common;

import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "MalfunctionReasonDto", description = "MalfunctionReasonDto")
public class MalfunctionReasonDto {

	@ApiModelProperty(value = "reason 아이디")
	private int reasonId;
	@ApiModelProperty(value = "타입 아이디")
	private int typeId;
	@ApiModelProperty(value = "reason 코드")
	private String reasonCode;
	@ApiModelProperty(value = "reason 설명")
	private String reasonDesc;
	@ApiModelProperty(value = "사용 여부 [ 1 : 사용, 8 : 미사용]")
	private int stusCodeId;

	public static MalfunctionReasonDto create(EgovMap egvoMap) {
		MalfunctionReasonDto dto = new MalfunctionReasonDto();
		dto.setReasonId(CommonUtils.getInt(egvoMap.get("errId")));
		dto.setTypeId(CommonUtils.getInt(egvoMap.get("errTypeId")));
		dto.setReasonCode((String) egvoMap.get("errCode"));
		dto.setReasonDesc((String) egvoMap.get("errName"));
		dto.setStusCodeId(CommonUtils.getInt(egvoMap.get("stusCodeId")));
		return dto;
	}

	public int getReasonId() {
		return reasonId;
	}

	public void setReasonId(int reasonId) {
		this.reasonId = reasonId;
	}

	public int getTypeId() {
		return typeId;
	}

	public void setTypeId(int typeId) {
		this.typeId = typeId;
	}

	public String getReasonCode() {
		return reasonCode;
	}

	public void setReasonCode(String reasonCode) {
		this.reasonCode = reasonCode;
	}

	public String getReasonDesc() {
		return reasonDesc;
	}

	public void setReasonDesc(String reasonDesc) {
		this.reasonDesc = reasonDesc;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}
}
