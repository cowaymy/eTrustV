package com.coway.trust.api.mobile.logistics.itembank;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ItemBankLocationListDto", description = "ItemBankLocationListDto")
public class ItemBankLocationListDto {

	@ApiModelProperty(value = "location Code")
	private String locationCode;

	@ApiModelProperty(value = "location name")
	private String locationName;

	@ApiModelProperty(value = "rdc/cdc/user locInfo")
	private String locationType;

	public static ItemBankLocationListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ItemBankLocationListDto.class);
	}

	public String getLocationCode() {
		return locationCode;
	}

	public void setLocationCode(String locationCode) {
		this.locationCode = locationCode;
	}

	public String getLocationName() {
		return locationName;
	}

	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}

	public String getLocationType() {
		return locationType;
	}

	public void setLocationType(String locationType) {
		this.locationType = locationType;
	}

}
