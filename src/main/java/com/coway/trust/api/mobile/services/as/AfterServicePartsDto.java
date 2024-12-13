package com.coway.trust.api.mobile.services.as;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModelProperty;

public class AfterServicePartsDto {
  @ApiModelProperty(value = "주문번호")
  private String salesOrderNo;

  @ApiModelProperty(value = "EX_BS00000 / AS00000")
  private String serviceNo;

  @ApiModelProperty(value = "제품코드")
  private String productCode;

  @ApiModelProperty(value = "필터코드")
  private String partCode;

  @ApiModelProperty(value = "part id 값")
  private String partId;

  @ApiModelProperty(value = "필터명")
  private String partName;

  @ApiModelProperty(value = "필요수량")
  private Integer quanity;

  @ApiModelProperty(value = "교체수량")
  private String chgQty;

  @ApiModelProperty(value = "foc??")
  private String chargesFoc;

  @ApiModelProperty(value = "chgid??")
  private String exChgid;

  @ApiModelProperty(value = "filter price")
  private String salesPrice;

  @ApiModelProperty(value = "교체여부")
  private String chgYN;

  @ApiModelProperty(value = "마지막교체일_날짜(YYYYMMDD)")
  private String lastChgDate;

  @ApiModelProperty(value = "마지막교체일_시간(HHMMSS)")
  private String lastChgTime;

  @ApiModelProperty(value = "마지막교체일_날짜(YYYYMMDD)")
  private String lastChgDateOrigin;

  @ApiModelProperty(value = "마지막교체일_시간(HHMMSS)")
  private String lastChgTimeOrigin;

  @ApiModelProperty(value = "filter / sparepart / msc(Miscellaneous) 구분")
  private String partType;

  @ApiModelProperty(value = "필터교체 주기")
  private String partsPeriod;

  @ApiModelProperty(value = "모바일 전용 필드 (API 와 무관함)")
  private String chargeYN;

  @ApiModelProperty(value = "Filter Barcode Check")
  private String filterBarcdChkYn;

  private String isSmo;

  private String isSerialReplace;

  private String psRemark;

  private String sysFilterBarcdSerailNoOld;

  private String filterBarcdSerailNo;

  private String filterSerailUnmatchReason;

  private String filterBarcdSerailNoOld;

  public String getFilterBarcdChkYn() {
    return filterBarcdChkYn;
  }

  public void setFilterBarcdChkYn( String filterBarcdChkYN ) {
    this.filterBarcdChkYn = filterBarcdChkYN;
  }

  public String getIsSmo() {
    return isSmo;
  }

  public void setIsSmo( String isSmo ) {
    this.isSmo = isSmo;
  }

  public String getIsSerialReplace() {
    return isSerialReplace;
  }

  public void setIsSerialReplace( String isSerialReplace ) {
    this.isSerialReplace = isSerialReplace;
  }

  public String getPsRemark() {
    return psRemark;
  }

  public void setPsRemark( String psRemark ) {
    this.psRemark = psRemark;
  }

  public String getSalesOrderNo() {
    return salesOrderNo;
  }

  public void setSalesOrderNo( String salesOrderNo ) {
    this.salesOrderNo = salesOrderNo;
  }

  public String getServiceNo() {
    return serviceNo;
  }

  public void setServiceNo( String serviceNo ) {
    this.serviceNo = serviceNo;
  }

  public String getProductCode() {
    return productCode;
  }

  public void setProductCode( String productCode ) {
    this.productCode = productCode;
  }

  public String getPartCode() {
    return partCode;
  }

  public void setPartCode( String partCode ) {
    this.partCode = partCode;
  }

  public String getPartId() {
    return partId;
  }

  public void setPartId( String partId ) {
    this.partId = partId;
  }

  public String getPartName() {
    return partName;
  }

  public void setPartName( String partName ) {
    this.partName = partName;
  }

  public Integer getQuanity() {
    return quanity;
  }

  public void setQuanity( Integer quanity ) {
    this.quanity = quanity;
  }

  public String getChgQty() {
    return chgQty;
  }

  public void setChgQty( String chgQty ) {
    this.chgQty = chgQty;
  }

  public String getChargesFoc() {
    return chargesFoc;
  }

  public void setChargesFoc( String chargesFoc ) {
    this.chargesFoc = chargesFoc;
  }

  public String getExChgid() {
    return exChgid;
  }

  public void setExChgid( String exChgid ) {
    this.exChgid = exChgid;
  }

  public String getSalesPrice() {
    return salesPrice;
  }

  public void setSalesPrice( String salesPrice ) {
    this.salesPrice = salesPrice;
  }

  public String getChgYN() {
    return chgYN;
  }

  public void setChgYN( String chgYN ) {
    this.chgYN = chgYN;
  }

  public String getLastChgDate() {
    return lastChgDate;
  }

  public void setLastChgDate( String lastChgDate ) {
    this.lastChgDate = lastChgDate;
  }

  public String getLastChgTime() {
    return lastChgTime;
  }

  public void setLastChgTime( String lastChgTime ) {
    this.lastChgTime = lastChgTime;
  }

  public String getLastChgDateOrigin() {
    return lastChgDateOrigin;
  }

  public void setLastChgDateOrigin( String lastChgDateOrigin ) {
    this.lastChgDateOrigin = lastChgDateOrigin;
  }

  public String getLastChgTimeOrigin() {
    return lastChgTimeOrigin;
  }

  public void setLastChgTimeOrigin( String lastChgTimeOrigin ) {
    this.lastChgTimeOrigin = lastChgTimeOrigin;
  }

  public String getPartType() {
    return partType;
  }

  public void setPartType( String partType ) {
    this.partType = partType;
  }

  public String getPartsPeriod() {
    return partsPeriod;
  }

  public void setPartsPeriod( String partsPeriod ) {
    this.partsPeriod = partsPeriod;
  }

  public String getChargeYN() {
    return chargeYN;
  }

  public void setChargeYN( String chargeYN ) {
    this.chargeYN = chargeYN;
  }

  public String getSysFilterBarcdSerailNoOld() {
    return sysFilterBarcdSerailNoOld;
  }

  public void setSysFilterBarcdSerailNoOld( String sysFilterBarcdSerailNoOld ) {
    this.sysFilterBarcdSerailNoOld = sysFilterBarcdSerailNoOld;
  }

  public String getFilterBarcdSerailNo() {
    return filterBarcdSerailNo;
  }

  public void setFilterBarcdSerailNo( String filterBarcdSerailNo ) {
    this.filterBarcdSerailNo = filterBarcdSerailNo;
  }

  public String getFilterSerailUnmatchReason() {
    return filterSerailUnmatchReason;
  }

  public void setFilterSerailUnmatchReason( String filterSerailUnmatchReason ) {
    this.filterSerailUnmatchReason = filterSerailUnmatchReason;
  }

  public String getFilterBarcdSerailNoOld() {
    return filterBarcdSerailNoOld;
  }

  public void setFilterBarcdSerailNoOld( String filterBarcdSerailNoOld ) {
    this.filterBarcdSerailNoOld = filterBarcdSerailNoOld;
  }

  public static AfterServicePartsDto create( EgovMap egovMap ) {
    return BeanConverter.toBean( egovMap, AfterServicePartsDto.class );
  }
}
