package com.coway.trust.api.mobile.logistics.alternativefilter;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AlternativeFilterListDto", description = "공통코드 Dto")
public class AlternativeFilterDListDto {
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

  @ApiModelProperty(value = "필터구분코드(Alternative)")
  private String divisionCode;

  private int partType;

  private int salesPrice;

  private String quantity;

  @SuppressWarnings("unchecked")
  public static AlternativeFilterDListDto create( EgovMap egvoMap ) {
    return BeanConverter.toBean( egvoMap, AlternativeFilterDListDto.class );
  }

  public int getFilterPartsId() {
    return filterPartsId;
  }

  public void setFilterPartsId( int filterPartsId ) {
    this.filterPartsId = filterPartsId;
  }

  public String getProductCode() {
    return productCode;
  }

  public void setProductCode( String productCode ) {
    this.productCode = productCode;
  }

  public int getProductId() {
    return productId;
  }

  public void setProductId( int productId ) {
    this.productId = productId;
  }

  public String getFilterCode() {
    return filterCode;
  }

  public void setFilterCode( String filterCode ) {
    this.filterCode = filterCode;
  }

  public String getFilterName() {
    return filterName;
  }

  public void setFilterName( String filterName ) {
    this.filterName = filterName;
  }

  public String getFilterGroupCode() {
    return filterGroupCode;
  }

  public void setFilterGroupCode( String filterGroupCode ) {
    this.filterGroupCode = filterGroupCode;
  }

  public String getDivisionCode() {
    return divisionCode;
  }

  public void setDivisionCode( String divisionCode ) {
    this.divisionCode = divisionCode;
  }

  public int getPartType() {
    return partType;
  }

  public void setPartType( int partType ) {
    this.partType = partType;
  }

  public int getSalesPrice() {
    return salesPrice;
  }

  public void setSalesPrice( int salesPrice ) {
    this.salesPrice = salesPrice;
  }

  public String getQuantity() {
    return quantity;
  }

  public void setQuantity( String quantity ) {
    this.quantity = quantity;
  }
}
