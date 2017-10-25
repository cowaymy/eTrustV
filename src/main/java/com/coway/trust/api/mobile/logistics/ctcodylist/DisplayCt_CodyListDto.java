package com.coway.trust.api.mobile.logistics.ctcodylist;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "logisticsCodeAllDto", description = "공통코드 Dto")
public class DisplayCt_CodyListDto {

	@ApiModelProperty(value = "브랜치에 속한 CT/CODY 명")
	private String ctCodyName;
	@ApiModelProperty(value = "브랜치에 속한 CT/CODY ID ")
	private String ctCodyId;
	@ApiModelProperty(value = "Location ID")
	private int rdcCode;

	public static DisplayCt_CodyListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, DisplayCt_CodyListDto.class);
	}

	public String getCtCodyName() {
		return ctCodyName;
	}

	public void setCtCodyName(String ctCodyName) {
		this.ctCodyName = ctCodyName;
	}

	public String getCtCodyId() {
		return ctCodyId;
	}

	public void setCtCodyId(String ctCodyId) {
		this.ctCodyId = ctCodyId;
	}

	public int getRdcCode() {
		return rdcCode;
	}

	public void setRdcCode(int rdcCode) {
		this.rdcCode = rdcCode;
	}

}
