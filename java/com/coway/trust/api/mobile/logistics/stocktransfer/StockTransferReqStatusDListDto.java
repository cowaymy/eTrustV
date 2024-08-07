package com.coway.trust.api.mobile.logistics.stocktransfer;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockTransferReqStatusDListDto", description = "StockTransferReqStatusDListDto")
public class StockTransferReqStatusDListDto {

  @ApiModelProperty(value = "SMO item no")
  private int smoNoItem;

  @ApiModelProperty(value = "부품코드")
  private String partsCode;

  @ApiModelProperty(value = "부품명")
  private String partsName;

  @ApiModelProperty(value = "부품 id")
  private int partsId;

  @ApiModelProperty(value = "부품 타입(필터(62) / 부품(63) / MISC(64))")
  private int partsType;

  @ApiModelProperty(value = "요청수량")
  private int requestQty;

  @ApiModelProperty(value = "부품 sn")
  private String serialNo;

  @ApiModelProperty(value = "바코드 대상 여부(Y 또는 공백)")
  private String barcodeChkYn;

  public static StockTransferReqStatusDListDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, StockTransferReqStatusDListDto.class);
  }

  public int getSmoNoItem() {
    return smoNoItem;
  }

  public void setSmoNoItem(int smoNoItem) {
    this.smoNoItem = smoNoItem;
  }

  public int getRequestQty() {
    return requestQty;
  }

  public void setRequestQty(int requestQty) {
    this.requestQty = requestQty;
  }

  public String getPartsCode() {
    return partsCode;
  }

  public void setPartsCode(String partsCode) {
    this.partsCode = partsCode;
  }

  public String getPartsName() {
    return partsName;
  }

  public void setPartsName(String partsName) {
    this.partsName = partsName;
  }

  public String getSerialNo() {
    return serialNo;
  }

  public void setSerialNo(String serialNo) {
    this.serialNo = serialNo;
  }

  public int getPartsId() {
    return partsId;
  }

  public void setPartsId(int partsId) {
    this.partsId = partsId;
  }

  public int getPartsType() {
    return partsType;
  }

  public void setPartsType(int partsType) {
    this.partsType = partsType;
  }

  public String getBarcodeChkYn() {
    return barcodeChkYn;
  }

  public void setBarcodeChkYn(String barcodeChkYn) {
    this.barcodeChkYn = barcodeChkYn;
  }
}
