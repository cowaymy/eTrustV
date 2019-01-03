package com.coway.trust.biz.sales.customer;

import java.io.Serializable;

public class CustomerBVO implements Serializable {

  private static final long serialVersionUID = -333885247013017692L;

  private int getCustAccIdSeq;
  private String accNo;
  private String encAccNo;
  private String accOwner;
  private int accTypeId;
  private int accBankId;
  private String accBankBrnch;
  private String accRem;
  private int accStusId;
  private int accUpdUserId;
  private String accNric;
  private int accIdOld;
  private int soId;
  private int accIdcm;
  private int hlbbId;
  private int accCrtUserId;
  private int getCustId;
  private int ddtChnlCde;

  public int getGetCustAccIdSeq() {
    return getCustAccIdSeq;
  }

  public void setGetCustAccIdSeq(int getCustAccIdSeq) {
    this.getCustAccIdSeq = getCustAccIdSeq;
  }

  public String getAccNo() {
    return accNo;
  }

  public void setAccNo(String accNo) {
    this.accNo = accNo;
  }

  public String getEncAccNo() {
    return encAccNo;
  }

  public void setEncAccNo(String encAccNo) {
    this.encAccNo = encAccNo;
  }

  public String getAccOwner() {
    return accOwner;
  }

  public void setAccOwner(String accOwner) {
    this.accOwner = accOwner;
  }

  public int getAccTypeId() {
    return accTypeId;
  }

  public void setAccTypeId(int accTypeId) {
    this.accTypeId = accTypeId;
  }

  public int getAccBankId() {
    return accBankId;
  }

  public void setAccBankId(int accBankId) {
    this.accBankId = accBankId;
  }

  public String getAccBankBrnch() {
    return accBankBrnch;
  }

  public void setAccBankBrnch(String accBankBrnch) {
    this.accBankBrnch = accBankBrnch;
  }

  public String getAccRem() {
    return accRem;
  }

  public void setAccRem(String accRem) {
    this.accRem = accRem;
  }

  public int getAccStusId() {
    return accStusId;
  }

  public void setAccStusId(int accStusId) {
    this.accStusId = accStusId;
  }

  public int getAccUpdUserId() {
    return accUpdUserId;
  }

  public void setAccUpdUserId(int accUpdUserId) {
    this.accUpdUserId = accUpdUserId;
  }

  public String getAccNric() {
    return accNric;
  }

  public void setAccNric(String accNric) {
    this.accNric = accNric;
  }

  public int getAccCrtUserId() {
    return accCrtUserId;
  }

  public void setAccCrtUserId(int accCrtUserId) {
    this.accCrtUserId = accCrtUserId;
  }

  public int getGetCustId() {
    return getCustId;
  }

  public void setGetCustId(int getCustId) {
    this.getCustId = getCustId;
  }

  public int getAccIdOld() {
    return accIdOld;
  }

  public void setAccIdOld(int accIdOld) {
    this.accIdOld = accIdOld;
  }

  public int getSoId() {
    return soId;
  }

  public void setSoId(int soId) {
    this.soId = soId;
  }

  public int getAccIdcm() {
    return accIdcm;
  }

  public void setAccIdcm(int accIdcm) {
    this.accIdcm = accIdcm;
  }

  public int getHlbbId() {
    return hlbbId;
  }

  public void setHlbbId(int hlbbId) {
    this.hlbbId = hlbbId;
  }

  public int getDdtChnlCde() {
    return ddtChnlCde;
  }

  public void setDdtChnlCde(int ddtChnlCde) {
    this.ddtChnlCde = ddtChnlCde;
  }

}
