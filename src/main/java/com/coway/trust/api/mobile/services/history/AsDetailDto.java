package com.coway.trust.api.mobile.services.history;

import java.util.List;

import com.coway.trust.api.mobile.logistics.stocktransfer.StockTransferReqStatusMListDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AsDetailDto", description = "공통코드 Dto")
public class AsDetailDto {

	private String salesOrdNo;

	private String memCode;

	private String stusCodeId;

	private String waterSrcType;

	private String codeName;


	public static AsDetailDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, AsDetailDto.class);
	}


	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public String getMemCode() {
		return memCode;
	}

	public String getStusCodeId() {
		return stusCodeId;
	}

	public String getWaterSrcType() {
		return waterSrcType;
	}

	public String getCodeName() {
		return codeName;
	}

	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}


	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}

	public void setStusCodeId(String stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public void setWaterSrcType(String waterSrcType) {
		this.waterSrcType = waterSrcType;
	}
}
