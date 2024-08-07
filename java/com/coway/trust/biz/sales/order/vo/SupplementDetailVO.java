package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class SupplementDetailVO implements Serializable {
  private static final long serialVersionUID = 1L;

  private int supItmId;

  private int supRefId;

  private int supStkId;

  private int supItmQty;

  private BigDecimal supItmUntprc;

  private BigDecimal supItmAmt;

  private BigDecimal supItmTax;

  private BigDecimal supTotAmt;

  private String delFlg;

  private int crtUsrId;

  private Date crtDt;

  private int updUsrId;

  private Date updDt;

  public int getSupItmId() {
    return supItmId;
  }

  public void setSupItmId(int supItmId) {
    this.supItmId = supItmId;
  }

  public int getSupRefId() {
    return supRefId;
  }

  public void setSupRefId(int supRefId) {
    this.supRefId = supRefId;
  }

  public int getSupStkId() {
    return supStkId;
  }

  public void setSupStkId(int supStkId) {
    this.supStkId = supStkId;
  }

  public int getSupItmQty() {
    return supItmQty;
  }

  public void setSupItmQty(int supItmQty) {
    this.supItmQty = supItmQty;
  }

  public BigDecimal getSupItmUntprc() {
    return supItmUntprc;
  }

  public void setSupItmUntprc(BigDecimal supItmUntprc) {
    this.supItmUntprc = supItmUntprc;
  }

  public BigDecimal getSupItmAmt() {
    return supItmAmt;
  }

  public void setSupItmAmt(BigDecimal supItmAmt) {
    this.supItmAmt = supItmAmt;
  }

  public BigDecimal getSupItmTax() {
    return supItmTax;
  }

  public void setSupItmTax(BigDecimal supItmTax) {
    this.supItmTax = supItmTax;
  }

  public BigDecimal getSupTotAmt() {
    return supTotAmt;
  }

  public void setSupTotAmt(BigDecimal supTotAmt) {
    this.supTotAmt = supTotAmt;
  }

  public String getDelFlg() {
    return delFlg;
  }

  public void setDelFlg(String delFlg) {
    this.delFlg = delFlg;
  }

  public int getCrtUsrId() {
    return crtUsrId;
  }

  public void setCrtUsrId(int crtUsrId) {
    this.crtUsrId = crtUsrId;
  }

  public Date getCrtDt() {
    return crtDt;
  }

  public void setCrtDt(Date crtDt) {
    this.crtDt = crtDt;
  }

  public int getUpdUsrId() {
    return updUsrId;
  }

  public void setUpdUsrId(int updUsrId) {
    this.updUsrId = updUsrId;
  }

  public Date getUpdDt() {
    return updDt;
  }

  public void setUpdDt(Date updDt) {
    this.updDt = updDt;
  }


}
