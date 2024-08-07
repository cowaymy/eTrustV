package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * The persistent class for the SAL0213M database table.
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class PreBookingOrderVO implements Serializable {
	private static final long serialVersionUID = 1L;

  private int preBookOrdId;

  private String preBookOrdNo;

  private String preBookDt;

  private int custId;

  private String custContactNumber;

  private String custVerifyStus;

  private int salesOrdIdOld;

  private String salesOrdNoOld;

  private String memCode;

  private int stkId;

  private String rem;

  private int stusId;

  private int crtUserId;

  private String crtDt;

  private int updUserId;

  private String updDt;

  private int discWaive;

  private int receivingMarketingMsgStatus;

  private int preBookPeriod;

  private String area;

  private String postCode;

  public int getPreBookOrdId() {
    return preBookOrdId;
  }

  public void setPreBookOrdId(int preBookOrdId) {
    this.preBookOrdId = preBookOrdId;
  }

  public String getPreBookOrdNo() {
    return preBookOrdNo;
  }

  public void setPreBookOrdNo(String preBookOrdNo) {
    this.preBookOrdNo = preBookOrdNo;
  }

  public String getPreBookDt() {
    return preBookDt;
  }

  public void setPreBookDt(String preBookDt) {
    this.preBookDt = preBookDt;
  }

  public int getCustId() {
    return custId;
  }

  public void setCustId(int custId) {
    this.custId = custId;
  }

  public String getCustVerifyStus() {
    return custVerifyStus;
  }

  public void setCustVerifyStus(String custVerifyStus) {
    this.custVerifyStus = custVerifyStus;
  }

  public int getSalesOrdIdOld() {
    return salesOrdIdOld;
  }

  public void setSalesOrdIdOld(int salesOrdIdOld) {
    this.salesOrdIdOld = salesOrdIdOld;
  }

  public String getMemCode() {
    return memCode;
  }

  public void setMemCode(String memCode) {
    this.memCode = memCode;
  }

  public int getStkId() {
    return stkId;
  }

  public void setStkId(int stkId) {
    this.stkId = stkId;
  }

  public String getRem() {
    return rem;
  }

  public void setRem(String rem) {
    this.rem = rem;
  }

  public int getStusId() {
    return stusId;
  }

  public void setStusId(int stusId) {
    this.stusId = stusId;
  }

  public int getCrtUserId() {
    return crtUserId;
  }

  public void setCrtUserId(int crtUserId) {
    this.crtUserId = crtUserId;
  }

  public String getCrtDt() {
    return crtDt;
  }

  public void setCrtDt(String crtDt) {
    this.crtDt = crtDt;
  }

  public int getUpdUserId() {
    return updUserId;
  }

  public void setUpdUserId(int updUserId) {
    this.updUserId = updUserId;
  }

  public String getUpdDt() {
    return updDt;
  }

  public void setUpdDt(String updDt) {
    this.updDt = updDt;
  }

  public int getDiscWaive() {
    return discWaive;
  }

  public void setDiscWaive(int discWaive) {
    this.discWaive = discWaive;
  }

  public int getReceivingMarketingMsgStatus() {
    return receivingMarketingMsgStatus;
  }

  public void setReceivingMarketingMsgStatus(int receivingMarketingMsgStatus) {
    this.receivingMarketingMsgStatus = receivingMarketingMsgStatus;
  }

  public String getSalesOrdNoOld() {
    return salesOrdNoOld;
  }

  public void setSalesOrdNoOld(String salesOrdNoOld) {
    this.salesOrdNoOld = salesOrdNoOld;
  }

  public String getCustContactNumber() {
    return custContactNumber;
  }

  public void setCustContactNumber(String custContactNumber) {
    this.custContactNumber = custContactNumber;
  }

  public int getPreBookPeriod() {
    return preBookPeriod;
  }

  public void setPreBookPeriod(int preBookPeriod) {
    this.preBookPeriod = preBookPeriod;
  }

  public String getArea() {
    return area;
  }

  public void setArea(String area) {
    this.area = area;
  }

  public String getPostCode() {
    return postCode;
  }

  public void setPostCode(String postCode) {
    this.postCode = postCode;
  }
}