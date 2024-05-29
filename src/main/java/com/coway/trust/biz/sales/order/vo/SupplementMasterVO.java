package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


@JsonIgnoreProperties(ignoreUnknown = true)
public class SupplementMasterVO implements Serializable{
  private static final long serialVersionUID = 1L;

  private int supRefId;

  private String supRefNo;

  private String supSubmSof;

  private Date supRefDt;

  private int supRefStus;

  private int supRefStg;

  private int supRefDelStus;

  private Date supRefDelDt;

  private String supRefPclTrkno;

  private String supRefRtnCsigno;

  private int custId;

  private int custCntcId;

  private int custDelAddrId;

  private int custBillAddrId;

  private int flAttId;

  private int memId;

  private int memBrnchId;

  private int supApplTyp;

  private int supTtlAmt;

  private int pvYear;

  private int pvMonth;

  private int totPv;

  private String supRefRmk;

  private String delFlg;

  private int crtUsrId;

  private Date crtDt;

  private int updUsrId;

  private Date updDt;

  public int getSupRefId() {
    return supRefId;
  }

  public void setSupRefId(int supRefId) {
    this.supRefId = supRefId;
  }

  public String getSupRefNo() {
    return supRefNo;
  }

  public void setSupRefNo(String supRefNo) {
    this.supRefNo = supRefNo;
  }

  public String getSupSubmSof() {
    return supSubmSof;
  }

  public void setSupSubmSof(String supSubmSof) {
    this.supSubmSof = supSubmSof;
  }

  public Date getSupRefDt() {
    return supRefDt;
  }

  public void setSupRefDt(Date supRefDt) {
    this.supRefDt = supRefDt;
  }

  public int getSupRefStus() {
    return supRefStus;
  }

  public void setSupRefStus(int supRefStus) {
    this.supRefStus = supRefStus;
  }

  public int getSupRefStg() {
    return supRefStg;
  }

  public void setSupRefStg(int supRefStg) {
    this.supRefStg = supRefStg;
  }

  public int getSupRefDelStus() {
    return supRefDelStus;
  }

  public void setSupRefDelStus(int supRefDelStus) {
    this.supRefDelStus = supRefDelStus;
  }

  public Date getSupRefDelDt() {
    return supRefDelDt;
  }

  public void setSupRefDelDt(Date supRefDelDt) {
    this.supRefDelDt = supRefDelDt;
  }

  public String getSupRefPclTrkno() {
    return supRefPclTrkno;
  }

  public void setSupRefPclTrkno(String supRefPclTrkno) {
    this.supRefPclTrkno = supRefPclTrkno;
  }

  public String getSupRefRtnCsigno() {
    return supRefRtnCsigno;
  }

  public void setSupRefRtnCsigno(String supRefRtnCsigno) {
    this.supRefRtnCsigno = supRefRtnCsigno;
  }

  public int getCustId() {
    return custId;
  }

  public void setCustId(int custId) {
    this.custId = custId;
  }

  public int getCustCntcId() {
    return custCntcId;
  }

  public void setCustCntcId(int custCntcId) {
    this.custCntcId = custCntcId;
  }

  public int getCustDelAddrId() {
    return custDelAddrId;
  }

  public void setCustDelAddrId(int custDelAddrId) {
    this.custDelAddrId = custDelAddrId;
  }

  public int getCustBillAddrId() {
    return custBillAddrId;
  }

  public void setCustBillAddrId(int custBillAddrId) {
    this.custBillAddrId = custBillAddrId;
  }

  public int getFlAttId() {
    return flAttId;
  }

  public void setFlAttId(int flAttId) {
    this.flAttId = flAttId;
  }

  public int getMemId() {
    return memId;
  }

  public void setMemId(int memId) {
    this.memId = memId;
  }

  public int getMemBrnchId() {
    return memBrnchId;
  }

  public void setMemBrnchId(int memBrnchId) {
    this.memBrnchId = memBrnchId;
  }

  public int getSupApplTyp() {
    return supApplTyp;
  }

  public void setSupApplTyp(int supApplTyp) {
    this.supApplTyp = supApplTyp;
  }

  public int getSupTtlAmt() {
    return supTtlAmt;
  }

  public void setSupTtlAmt(int supTtlAmt) {
    this.supTtlAmt = supTtlAmt;
  }

  public int getPvYear() {
    return pvYear;
  }

  public void setPvYear(int pvYear) {
    this.pvYear = pvYear;
  }

  public int getPvMonth() {
    return pvMonth;
  }

  public void setPvMonth(int pvMonth) {
    this.pvMonth = pvMonth;
  }

  public int getTotPv() {
    return totPv;
  }

  public void setTotPv(int totPv) {
    this.totPv = totPv;
  }

  public String getSupRefRmk() {
    return supRefRmk;
  }

  public void setSupRefRmk(String supRefRmk) {
    this.supRefRmk = supRefRmk;
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
