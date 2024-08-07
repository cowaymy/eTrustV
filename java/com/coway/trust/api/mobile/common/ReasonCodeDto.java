package com.coway.trust.api.mobile.common;

import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ReasonCodeDto", description = "ReasonCodeDto")
public class ReasonCodeDto {

	@ApiModelProperty(value = "Reason 마스터 아이디")
	private int codeMasterId;
	@ApiModelProperty(value = "Reason 마스터 코드")
	private String codeMaster;
	@ApiModelProperty(value = "Reason 마스터 코드 명")
	private String codeMasterName;
	@ApiModelProperty(value = "Reason 마스터 코드 Disable 여부 ( 0 : enable, 1 : disable)")
	private int codeMasterDisab;

	@ApiModelProperty(value = "Reason 코드 아이디")
	private int codeId;
	@ApiModelProperty(value = "Reason 코드")
	private String code;
	@ApiModelProperty(value = "Reason 코드 명")
	private String codeName;
	@ApiModelProperty(value = "사용 여부 [ 1 : 사용, 8 : 미사용]")
	private int stusCodeId;

	public static ReasonCodeDto create(EgovMap egvoMap) {
		ReasonCodeDto dto = new ReasonCodeDto();
		dto.setCodeMasterId(CommonUtils.getInt(egvoMap.get("resnMasterTypeId")));
		dto.setCodeMaster((String) egvoMap.get("resnMasterCode"));
		dto.setCodeMasterName((String) egvoMap.get("resnMasterDesc"));
		dto.setCodeMasterDisab(CommonUtils.getInt(egvoMap.get("disab")));

		dto.setCodeId(CommonUtils.getInt(egvoMap.get("resnId")));
		dto.setCode((String) egvoMap.get("resnCode"));
		dto.setCodeName((String) egvoMap.get("resnDesc"));
		dto.setStusCodeId(CommonUtils.getInt(egvoMap.get("stusCodeId")));
		return dto;
	}

	public int getCodeMasterId() {
		return codeMasterId;
	}

	public void setCodeMasterId(int codeMasterId) {
		this.codeMasterId = codeMasterId;
	}

	public String getCodeMaster() {
		return codeMaster;
	}

	public void setCodeMaster(String codeMaster) {
		this.codeMaster = codeMaster;
	}

	public String getCodeMasterName() {
		return codeMasterName;
	}

	public void setCodeMasterName(String codeMasterName) {
		this.codeMasterName = codeMasterName;
	}

	public int getCodeMasterDisab() {
		return codeMasterDisab;
	}

	public void setCodeMasterDisab(int codeMasterDisab) {
		this.codeMasterDisab = codeMasterDisab;
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

	public String getCodeName() {
		return codeName;
	}

	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}
}
