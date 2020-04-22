package com.coway.trust.api.mobile.services.careService;

import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/*********************************************************************************************
 * DATE             PIC           VERSION  COMMENT
 * -----------------------------------------------------------------------------
 * 22/04/2020    ONGHC      1.0.0       - Create RelateOrderListDto
 *********************************************************************************************/

@ApiModel(value = "RelateOrderListDto", description = "Relete Order List Dto")
public class RelateOrderListDto {

  @ApiModelProperty(value = "Order No.")
  private String ordNo;

  @ApiModelProperty(value = "Order Status")
  private String ordStat;

  @ApiModelProperty(value = "Order Date")
  private String ordDt;

  @ApiModelProperty(value = "Application Type")
  private String appTyp;

  @ApiModelProperty(value = "Product Category")
  private String prodCat;

  @ApiModelProperty(value = "Product")
  private String prod;

  @ApiModelProperty(value = "Outstanding Amount")
  private String outstdAmt;

  @ApiModelProperty(value = "Outstanding Amount Indicator")
  private int signOutstdAmt;

  @ApiModelProperty(value = "Sales Detail")
  private List<SalesDetailDto> salesDetail = null;

  @SuppressWarnings("unchecked")
  public static RelateOrderListDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, RelateOrderListDto.class);
  }

  public String getOrdNo() {
    return ordNo;
  }

  public void setOrdNo(String ordNo) {
    this.ordNo = ordNo;
  }

  public String getOrdStat() {
    return ordStat;
  }

  public void setOrdStat(String ordStat) {
    this.ordStat = ordStat;
  }

  public String getOrdDt() {
    return ordDt;
  }

  public void setOrdDt(String ordDt) {
    this.ordDt = ordDt;
  }

  public String getAppTyp() {
    return appTyp;
  }

  public void setAppTyp(String appTyp) {
    this.appTyp = appTyp;
  }

  public String getProdCat() {
    return prodCat;
  }

  public void setProdCat(String prodCat) {
    this.prodCat = prodCat;
  }

  public String getProd() {
    return prod;
  }

  public void setProd(String prod) {
    this.prod = prod;
  }

  public String getOutstdAmt() {
    return outstdAmt;
  }

  public void setOutstdAmt(String outstdAmt) {
    this.outstdAmt = outstdAmt;
  }

  public int getSignOutstdAmt() {
    return signOutstdAmt;
  }

  public void setSignOutstdAmt(int signOutstdAmt) {
    this.signOutstdAmt = signOutstdAmt;
  }

  public List<SalesDetailDto> getSalesDetail() {
    return salesDetail;
  }

  public void setSalesDetail(List<SalesDetailDto> salesDetail) {
    this.salesDetail = salesDetail;
  }
}
