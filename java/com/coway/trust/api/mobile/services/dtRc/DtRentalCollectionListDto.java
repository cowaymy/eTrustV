package com.coway.trust.api.mobile.services.dtRc;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "DtRentalCollectionListDto", description = "공통코드 Dto")
public class DtRentalCollectionListDto {

	@ApiModelProperty(value = "")
	private String memCode;

	@ApiModelProperty(value = "")
	private String rcPrct;

	@ApiModelProperty(value = "")
	private String adRatio;

	public String getMemCode() {
		return memCode;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}

	public String getRcPrct() {
		return rcPrct;
	}

	public void setRcPrct(String rcPrct) {
		this.rcPrct = rcPrct;
	}

	public String getAdRatio() {
		return adRatio;
	}

	public void setAdRatio(String adRatio) {
		this.adRatio = adRatio;
	}

	public static DtRentalCollectionListDto create(EgovMap egvoMap) {
		 return BeanConverter.toBean(egvoMap, DtRentalCollectionListDto.class);
	}



}
