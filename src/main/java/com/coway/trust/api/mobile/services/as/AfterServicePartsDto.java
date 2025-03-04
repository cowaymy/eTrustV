package com.coway.trust.api.mobile.services.as;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModelProperty;

public class AfterServicePartsDto {
  @ApiModelProperty(value = "SALES ORDER NO")
  private String salesOrderNo;

  @ApiModelProperty(value = "AS NO")
  private String serviceNo;

  @ApiModelProperty(value = "PRODUCT CODE")
  private String productCode;

  @ApiModelProperty(value = "PART CODE")
  private String partCode;

  @ApiModelProperty(value = "PART ID")
  private String partId;

  @ApiModelProperty(value = "PART NAME")
  private String partName;

  @ApiModelProperty(value = "QUANTITY")
  private Integer quanity;

  @ApiModelProperty(value = "CHANGE QUANTITY")
  private String chgQty;

  @ApiModelProperty(value = "CHARGES/FOC")
  private String chargesFoc;

  @ApiModelProperty(value = "EXCHANGE ID")
  private String exChgid;

  @ApiModelProperty(value = "FILTER PRICE")
  private String salesPrice;

  @ApiModelProperty(value = "CHANGE INDICATOR")
  private String chgYN;

  @ApiModelProperty(value = "LAST CHANGE DATE")
  private String lastChgDate;

  @ApiModelProperty(value = "LAST CHANGE TIME")
  private String lastChgTime;

  @ApiModelProperty(value = "LAST CHANGE DATE ORIGIN")
  private String lastChgDateOrigin;

  @ApiModelProperty(value = "LAST CHANGE TIME ORIGIN")
  private String lastChgTimeOrigin;

  @ApiModelProperty(value = "PART TYPE")
  private String partType;

  @ApiModelProperty(value = "PART PERIOD")
  private String partsPeriod;

  @ApiModelProperty(value = "CHARGE INDICATOR")
  private String chargeYN;

  @ApiModelProperty(value = "FILTER BARCODE CHECK INDICATOR")
  private String filterBarcdChkYn;

  @ApiModelProperty(value = "SMO INDICATOR")
  private String isSmo;

  @ApiModelProperty(value = "IS RERIAL REPLACEMENT INDICATOR")
  private String isSerialReplace;

  @ApiModelProperty(value = "PS REMARK")
  private String psRemark;

  @ApiModelProperty(value = "OLD FILTER BARCODE SERIAL")
  private String filterBarcdSerialNoOld;

  @ApiModelProperty(value = "NEW FILTER BARCODE SERIAL")
  private String filterBarcdSerialNo;

  @ApiModelProperty(value = "FILTER SERIAL UNMATCH REASON")
  private String filterSerialUnmatchReason;

  @ApiModelProperty(value = "OLD SYSTEM FILTER BARCIDE SERIAL")
  private String sysFilterBarcdSerialNoOld;

  @ApiModelProperty(value = "IS FILL FILTER INFO. INDICATOR")
  private String isFillFilterInfo;

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

  public String getFilterBarcdChkYn() {
    return filterBarcdChkYn;
  }

  public void setFilterBarcdChkYn( String filterBarcdChkYn ) {
    this.filterBarcdChkYn = filterBarcdChkYn;
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

  public String getFilterBarcdSerialNoOld() {
    return filterBarcdSerialNoOld;
  }

  public void setFilterBarcdSerialNoOld( String filterBarcdSerialNoOld ) {
    this.filterBarcdSerialNoOld = filterBarcdSerialNoOld;
  }

  public String getFilterBarcdSerialNo() {
    return filterBarcdSerialNo;
  }

  public void setFilterBarcdSerialNo( String filterBarcdSerialNo ) {
    this.filterBarcdSerialNo = filterBarcdSerialNo;
  }

  public String getFilterSerialUnmatchReason() {
    return filterSerialUnmatchReason;
  }

  public void setFilterSerialUnmatchReason( String filterSerialUnmatchReason ) {
    this.filterSerialUnmatchReason = filterSerialUnmatchReason;
  }

  public String getSysFilterBarcdSerialNoOld() {
    return sysFilterBarcdSerialNoOld;
  }

  public void setSysFilterBarcdSerialNoOld( String sysFilterBarcdSerialNoOld ) {
    this.sysFilterBarcdSerialNoOld = sysFilterBarcdSerialNoOld;
  }

  public String getIsFillFilterInfo() {
    return isFillFilterInfo;
  }

  public void setIsFillFilterInfo( String isFillFilterInfo ) {
    this.isFillFilterInfo = isFillFilterInfo;
  }

  @SuppressWarnings("unchecked")
  public static AfterServicePartsDto create( EgovMap egovMap ) {
    return BeanConverter.toBean( egovMap, AfterServicePartsDto.class );
  }
}
