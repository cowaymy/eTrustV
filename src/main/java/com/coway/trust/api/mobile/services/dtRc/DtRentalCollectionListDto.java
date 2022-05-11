package com.coway.trust.api.mobile.services.dtRc;

import com.coway.trust.api.mobile.services.installation.InstallationJobDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "DtRentalCollectionListDto", description = "공통코드 Dto")
public class DtRentalCollectionListDto {

	@ApiModelProperty(value = "")
	private String MEM_CODE;

	@ApiModelProperty(value = "")
	private String RC_PRCT;

	public String getMemCode() {
		return MEM_CODE;
	}

	public void setMemCode(String MEM_CODE) {
		this.MEM_CODE = MEM_CODE;
	}

	public String getRcPrct() {
		return RC_PRCT;
	}

	public void setRcPrct(String RC_PRCT) {
		this.RC_PRCT = RC_PRCT;
	}

	public static DtRentalCollectionListDto create(EgovMap egvoMap) {
		 return BeanConverter.toBean(egvoMap, DtRentalCollectionListDto.class);
	}



}
