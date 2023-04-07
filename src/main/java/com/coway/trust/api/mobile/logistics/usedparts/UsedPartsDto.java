package com.coway.trust.api.mobile.logistics.usedparts;

import java.text.DecimalFormat;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "UsedPartsDto", description = "UsedPartsDto")
public class UsedPartsDto {

  @ApiModelProperty(value = "부품코드")
  String partsCode;

  @ApiModelProperty(value = "부품 id")
  int partsId;

  @ApiModelProperty(value = "부품명")
  String partsName;

  @ApiModelProperty(value = "고객명")
  String custName;

  @ApiModelProperty(value = "수량")
  int usedQty;

  @ApiModelProperty(value = "통화")
  String currency;

  @ApiModelProperty(value = "Old Serial No")
  String serialNo;

  @ApiModelProperty(value = "New Installed Serial No")
  String newSerial;

  @ApiModelProperty(value = "HS Service No")
  String serviceNo;

  @ApiModelProperty(value = "Sales Order No")
  String salesOrdNo;

  public static UsedPartsDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, UsedPartsDto.class);
  }

  public String getPartsCode() {
    return partsCode;
  }

  public void setPartsCode(String partsCode) {
    this.partsCode = partsCode;
  }

  public int getPartsId() {
    return partsId;
  }

  public void setPartsId(int partsId) {
    this.partsId = partsId;
  }

  public String getPartsName() {
    return partsName;
  }

  public void setPartsName(String partsName) {
    this.partsName = partsName;
  }

  public String getCustName() {
    return custName;
  }

  public void setCustName(String custName) {
    this.custName = custName;
  }

  public int getUsedQty() {
    return usedQty;
  }

  public void setUsedQty(int usedQty) {
    this.usedQty = usedQty;
  }

  public String getCurrency() {
    return currency;
  }

  public void setCurrency(String currency) {
    this.currency = currency;
  }

  public String getSerialNo() {
    return serialNo;
  }

  public void setSerialNo(String serialNo) {
    this.serialNo = serialNo;
  }

  public String getNewSerial() {
    return newSerial;
  }

  public void setNewSerial(String newSerial) {
    this.newSerial = newSerial;
  }

  public String getServiceNo() {
    return serviceNo;
  }

  public void setServiceNo(String serviceNo) {
    this.serviceNo = serviceNo;
  }

  public String getSalesOrdNo() {
    return salesOrdNo;
  }

  public void setSalesOrdNo(String salesOrdNo) {
    this.salesOrdNo = salesOrdNo;
  }
}
