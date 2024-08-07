package com.coway.trust.api.mobile.logistics.alternativefilter;

import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AlternativeFilterListDto", description = "공통코드 Dto")
public class AlternativeFilterMListDto {

	@ApiModelProperty(value = "제품코드")
	private String productCode;

	@ApiModelProperty(value = "제품 id")
	private int productId;

	@ApiModelProperty(value = "필터 id")
	private int filterPartsId;

	@ApiModelProperty(value = "필터 코드")
	private String filterCode;

	@ApiModelProperty(value = "필터 명")
	private String filterName;

	@ApiModelProperty(value = "필터그룹코드(AA 등)")
	private String filterGroupCode;

	@ApiModelProperty(value = "필터구분코드(MAIN)")
	private String divisionCode;

	public static AlternativeFilterMListDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, AlternativeFilterMListDto.class);
	}

	public int getFilterPartsId() {
		return filterPartsId;
	}

	public void setFilterPartsId(int filterPartsId) {
		this.filterPartsId = filterPartsId;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getFilterCode() {
		return filterCode;
	}

	public void setFilterCode(String filterCode) {
		this.filterCode = filterCode;
	}

	public String getFilterName() {
		return filterName;
	}

	public void setFilterName(String filterName) {
		this.filterName = filterName;
	}

	public String getFilterGroupCode() {
		return filterGroupCode;
	}

	public void setFilterGroupCode(String filterGroupCode) {
		this.filterGroupCode = filterGroupCode;
	}

	public String getDivisionCode() {
		return divisionCode;
	}

	public void setDivisionCode(String divisionCode) {
		this.divisionCode = divisionCode;
	}

}
