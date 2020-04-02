package com.coway.trust.api.mobile.payment.mobileTicket;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "MobileTicketDto", description = "MobileTicket Dto")
public class MobileTicketDto {

  @ApiModelProperty(value = "mobTicketNo")
  private int mobTicketNo;

  @ApiModelProperty(value = "salesOrdNo")
  private String salesOrdNo;

  @ApiModelProperty(value = "ticketTypeName")
  private String ticketTypeName;

  @ApiModelProperty(value = "custName")
  private String custName;

  @ApiModelProperty(value = "ticketStusName")
  private String ticketStusName;

  @ApiModelProperty(value = "crtDt")
  private String crtDt;

  @ApiModelProperty(value = "cancelYn")
  private String cancelYn;

  @ApiModelProperty(value = "ticketTypeId")
  private int ticketTypeId;

  @ApiModelProperty(value = "custBillNoOld")
  private String custBillNoOld;

  @ApiModelProperty(value = "custBillNoNw")
  private String custBillNoNw;

  @ApiModelProperty(value = "payMode")
  private int payMode;

  @ApiModelProperty(value = "payModeName")
  private String payModeName;

  @ApiModelProperty(value = "payAmt")
  private Double payAmt;

  @ApiModelProperty(value = "invcType")
  private int invcType;

  @ApiModelProperty(value = "email")
  private String email;

  @ApiModelProperty(value = "addEmail")
  private String addEmail;

  @ApiModelProperty(value = "reqInvc")
  private String reqInvc;

  @ApiModelProperty(value = "discRate")
  private int discRate;

  @ApiModelProperty(value = "invcAdvPrd")
  private int invcAdvPrd;

  @ApiModelProperty(value = "worNo")
  private String worNo;

  @ApiModelProperty(value = "ordNoOld")
  private String ordNoOld;

  @ApiModelProperty(value = "ordNoNw")
  private String ordNoNw;

  @ApiModelProperty(value = "curAmt")
  private Double curAmt;

  @ApiModelProperty(value = "rem")
  private String rem;

  public String getOrdNoOld() {
    return ordNoOld;
  }

  public void setOrdNoOld(String ordNoOld) {
    this.ordNoOld = ordNoOld;
  }

  public String getOrdNoNw() {
    return ordNoNw;
  }

  public void setOrdNoNw(String ordNoNw) {
    this.ordNoNw = ordNoNw;
  }

  public Double getCurAmt() {
    return curAmt;
  }

  public void setCurAmt(Double curAmt) {
    this.curAmt = curAmt;
  }

  public String getWorNo() {
    return worNo;
  }

  public void setWorNo(String worNo) {
    this.worNo = worNo;
  }

  public int getInvcAdvPrd() {
    return invcAdvPrd;
  }

  public void setInvcAdvPrd(int invcAdvPrd) {
    this.invcAdvPrd = invcAdvPrd;
  }

  public int getInvcType() {
    return invcType;
  }

  public void setInvcType(int invcType) {
    this.invcType = invcType;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getAddEmail() {
    return addEmail;
  }

  public void setAddEmail(String addEmail) {
    this.addEmail = addEmail;
  }

  public String getReqInvc() {
    return reqInvc;
  }

  public void setReqInvc(String reqInvc) {
    this.reqInvc = reqInvc;
  }

  public int getDiscRate() {
    return discRate;
  }

  public void setDiscRate(int discRate) {
    this.discRate = discRate;
  }

  public Double getPayAmt() {
    return payAmt;
  }

  public void setPayAmt(Double payAmt) {
    this.payAmt = payAmt;
  }

  public int getPayMode() {
    return payMode;
  }

  public void setPayMode(int payMode) {
    this.payMode = payMode;
  }

  public String getPayModeName() {
    return payModeName;
  }

  public void setPayModeName(String payModeName) {
    this.payModeName = payModeName;
  }

  public int getMobTicketNo() {
    return mobTicketNo;
  }

  public void setMobTicketNo(int mobTicketNo) {
    this.mobTicketNo = mobTicketNo;
  }

  public String getSalesOrdNo() {
    return salesOrdNo;
  }

  public void setSalesOrdNo(String salesOrdNo) {
    this.salesOrdNo = salesOrdNo;
  }

  public String getTicketTypeName() {
    return ticketTypeName;
  }

  public void setTicketTypeName(String ticketTypeName) {
    this.ticketTypeName = ticketTypeName;
  }

  public String getCustName() {
    return custName;
  }

  public void setCustName(String custName) {
    this.custName = custName;
  }

  public String getTicketStusName() {
    return ticketStusName;
  }

  public void setTicketStusName(String ticketStusName) {
    this.ticketStusName = ticketStusName;
  }

  public String getCrtDt() {
    return crtDt;
  }

  public void setCrtDt(String crtDt) {
    this.crtDt = crtDt;
  }

  public String getCancelYn() {
    return cancelYn;
  }

  public void setCancelYn(String cancelYn) {
    this.cancelYn = cancelYn;
  }

  public int getTicketTypeId() {
    return ticketTypeId;
  }

  public void setTicketTypeId(int ticketTypeId) {
    this.ticketTypeId = ticketTypeId;
  }

  public String getCustBillNoOld() {
    return custBillNoOld;
  }

  public void setCustBillNoOld(String custBillNoOld) {
    this.custBillNoOld = custBillNoOld;
  }

  public String getCustBillNoNw() {
    return custBillNoNw;
  }

  public void setCustBillNoNw(String custBillNoNw) {
    this.custBillNoNw = custBillNoNw;
  }

  public static MobileTicketDto create(EgovMap egvoMap) {
    // TODO Auto-generated method stub
    return BeanConverter.toBean(egvoMap, MobileTicketDto.class);
  }

  public String getRem() {
    return rem;
  }

  public void setRem(String rem) {
    this.rem = rem;
  }

}
