package com.coway.trust.api.mobile.services.installation;

import com.coway.trust.util.BeanConverter;
import java.math.BigDecimal;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallationJobDto", description = "공통코드 Dto")
public class InstallationJobDto {
  @ApiModelProperty(value = "SALES ORDER NO")
  private String salesOrderNo;

  @ApiModelProperty(value = "INSTALLATION NO")
  private String serviceNo;

  @ApiModelProperty(value = "CUSTOMER NAME")
  private String custName;

  @ApiModelProperty(value = "AS / HS / INST / PR")
  private String jobType;

  @ApiModelProperty(value = "ACT / COMPLETE / FAIL / CANCEL")
  private int jobStatus;

  @ApiModelProperty(value = "APPOINTMENT DATE")
  private String appointmentDate;

  @ApiModelProperty(value = "APPOINTMENT TIME")
  private String appointmentTime;

  @ApiModelProperty(value = "JOB SESSION")
  private String jobSession;

  @ApiModelProperty(value = "CHECK IN DATE")
  private String checkInDate;

  @ApiModelProperty(value = "CHECK IN TIME")
  private String checkInTime;

  @ApiModelProperty(value = "CHECK IN GPS")
  private String checkInGps;

  @ApiModelProperty(value = "CUSTOMER TYPE")
  private String customerType;

  @ApiModelProperty(value = "CUSTOMER ID")
  private int customerId;

  @ApiModelProperty(value = "SERVICE STATE")
  private String serviceState;

  @ApiModelProperty(value = "YEAR")
  private int planYear;

  @ApiModelProperty(value = "MONTH")
  private int planMonth;

  @ApiModelProperty(value = "GPS")
  private String customerGps;

  @ApiModelProperty(value = "INSTALLATION ADDRESS")
  private String installAddress;

  @ApiModelProperty(value = "POSTCODE")
  private String postcode;

  @ApiModelProperty(value = "MOBILE NO")
  private String handphoneTel;

  @ApiModelProperty(value = "RESIDENT CONTACT NO")
  private String homeTel;

  @ApiModelProperty(value = "OFFICE CONTACT NO")
  private String officeTel;

  @ApiModelProperty(value = "MAILLING ADDRESS")
  private String mailAddress;

  @ApiModelProperty(value = "CUSTOMER VA NO")
  private String customerVaNo;

  @ApiModelProperty(value = "CUSTOMER JOM PAY REFERENCE NO")
  private String customerJomPayRefNo;

  @ApiModelProperty(value = "IMAGE URL")
  private String imageUrl;

  @ApiModelProperty(value = "PRODUCT NAME")
  private String productName;

  @ApiModelProperty(value = "PRODUCT CODE")
  private String productCode;

  @ApiModelProperty(value = "APPLICATION TYPE")
  private String appType;

  @ApiModelProperty(value = "REMARK")
  private String instruction;

  @ApiModelProperty(value = "SALES PROMOTION")
  private String salesPromotion;

  @ApiModelProperty(value = "CONTRACT DURATION")
  private int contractDuration;

  @ApiModelProperty(value = "ORDER MONTHLY RENTAL FEES")
  private String monthlyRentalFees;

  @ApiModelProperty(value = "ORDER REGISRATION FEES")
  private int registrationFees;

  @ApiModelProperty(value = "PAYMENT MODE")
  private String paymentMode;

  @ApiModelProperty(value = "BANK CODE")
  private int bankCode;

  @ApiModelProperty(value = "BANK NAME")
  private String bankName;

  @ApiModelProperty(value = "CARD ACCOUNT NO")
  private String cardAccountNo;

  @ApiModelProperty(value = "OUTSTANDING")
  private String outstanding;

  @ApiModelProperty(value = "EXPIRY DATE")
  private String expiryDate;

  @ApiModelProperty(value = "DSC CODE")
  private String dscCode;

  @ApiModelProperty(value = "PRODUCT SIRIM")
  private String sirimNo;

  @ApiModelProperty(value = "PRODUCT SERIAL")
  private String serialNo;

  @ApiModelProperty(value = "HP NAME")
  private String hpName;

  @ApiModelProperty(value = "HP TEL NUMBER")
  private String hpTel;

  @ApiModelProperty(value = "SM NAME")
  private String smName;

  @ApiModelProperty(value = "SM TEL NUMBER")
  private String smTel;

  @ApiModelProperty(value = "HM NAME")
  private String hmName;

  @ApiModelProperty(value = "HM TEL NUMBER")
  private String hmTel;

  @ApiModelProperty(value = "BILL AMOUNT")
  private String billAmount;

  @ApiModelProperty(value = "PAID AMOUNT")
  private String paidAmount;

  @ApiModelProperty(value = "ADJUSTMENT AMOUNT")
  private String adjustmentAmount;

  @ApiModelProperty(value = "FILE IMAGE URL 1")
  private String fileImg1Url;

  @ApiModelProperty(value = "FILE IMAGE URL 2")
  private String fileImg2Url;

  @ApiModelProperty(value = "FILE IMAGE URL 3")
  private String fileImg3Url;

  @ApiModelProperty(value = "RESULT REMARK")
  private String resultRemark;

  @ApiModelProperty(value = "OWNER CODE")
  private String ownerCode;

  @ApiModelProperty(value = "OWNER CODE NAME")
  private String ownerCodeNm;

  @ApiModelProperty(value = "REUSLT CUSTOMER NAME")
  private String resultCustName;

  @ApiModelProperty(value = "RESULT MOBILE NO")
  private String resultIcMobileNo;

  @ApiModelProperty(value = "RESULT EMAIL ADDRESS")
  private String resultReportEmailNo;

  @ApiModelProperty(value = "RESULT ACCEPTANCE NAME")
  private String resultAcceptanceName;

  @ApiModelProperty(value = "RC CODE")
  private int rcCode;

  @ApiModelProperty(value = "FAIL REASON CODE")
  private int failReasonCode;

  @ApiModelProperty(value = "FAIL REASON NAME")
  private String failReasonName;

  @ApiModelProperty(value = "SETTLED BY")
  private String settledBy;

  @ApiModelProperty(value = "SETTLED DATE")
  private String settledDate;

  @ApiModelProperty(value = "SETTLED TIME")
  private String settledTime;

  @ApiModelProperty(value = "LAST PAYMENT DATE")
  private String lastPaymentDate;

  @ApiModelProperty(value = "NEXT CALL LOG DATE")
  private String nextCallDate;

  @ApiModelProperty(value = "NEXT CALL LOG TIME")
  private String nextCallTime;

  @ApiModelProperty(value = "AS EXCHANGE INDICATOR")
  private String asExchangeYN;

  @ApiModelProperty(value = "BEFORE PRODUCT CODE")
  private String beforeProductCode;

  @ApiModelProperty(value = "BEFORE PRODUCT SERIAL NO")
  private String beforeProductSerialNo;

  @ApiModelProperty(value = "IS FRAME INDICATOR")
  private String fraYn;

  @ApiModelProperty(value = "FRAME ORDER NO")
  private String fraOrdNo;

  @ApiModelProperty(value = "FRAME PRODUCT CODE")
  private String fraProductCode;

  @ApiModelProperty(value = "FRAME PRODUCT NAME")
  private String fraProductName;

  @ApiModelProperty(value = "PSI")
  private String psi;

  @ApiModelProperty(value = "LPM")
  private String lpm;

  @ApiModelProperty(value = "PRODUCT CATEGORY")
  private String prodcat;

  @ApiModelProperty(value = "WATER SOURCE TYPE")
  private String waterSrcType;

  @ApiModelProperty(value = "SERIAL CHEKC INDICATOR")
  private String serialChk;

  @ApiModelProperty(value = "SALES PROMOTION CODE")
  private String salesPromotionCde;

  @ApiModelProperty(value = "VOLTAGE")
  private String voltage;

  @ApiModelProperty(value = "TDS")
  private String tds;

  @ApiModelProperty(value = "ROOM TEMP.")
  private String roomTemp;

  @ApiModelProperty(value = "WATER SOURCE TEMP.")
  private String waterSrcTemp;

  @ApiModelProperty(value = "USED ADAPTOR")
  private String adptUsed;

  @ApiModelProperty(value = "INSTALLATION CHECK LIST")
  private String instChkLst;

  @ApiModelProperty(value = "INSTALLATION AGREEMENT CHECK LIST")
  private String instNoteChk;

  @ApiModelProperty(value = "BOOSTER PUMP")
  private String boosterPump;

  @ApiModelProperty(value = "AFTER PSI")
  private String aftPsi;

  @ApiModelProperty(value = "AFTER LPM")
  private String aftLpm;

  @ApiModelProperty(value = "TURBITY LEVEL")
  private String turbLvl;

  @ApiModelProperty(value = "CHECK SMS INDICAOTR")
  private String chkSms;

  @ApiModelProperty(value = "SEND INDICATOR")
  private String checkSend;

  @ApiModelProperty(value = "CUSTOMER MOBILE NO")
  private String custMobileNo;

  @ApiModelProperty(value = "LATITUDE")
  private BigDecimal latitude;

  @ApiModelProperty(value = "LONGTIDU")
  private BigDecimal longitude;

  @ApiModelProperty(value = "NTU")
  private BigDecimal ntu;

  @ApiModelProperty(value = "IS JOM TUKAR INDICATOR")
  private String isJomTukar;

  @ApiModelProperty(value = "IS COMPETITOR PRODUCT INDICATOR")
  private String isComptProd;

  @ApiModelProperty(value = "COMPETITOR BRAND")
  private String comptBrnd;

  @ApiModelProperty(value = "SERVICE TYPE")
  private String srvTyp;

  @ApiModelProperty(value = "PARTNER CODE")
  private String partnerCode;

  @ApiModelProperty(value = "PARTNER NAME")
  private String partnerCodeName;

  @ApiModelProperty(value = "FRAME SERIAL CHECK INDICATOR")
  private String fraSerialChk;

  @ApiModelProperty(value = "FRAME SERIAL NO")
  private String selFraSerialNo;

  @ApiModelProperty(value = "REAL AS EXCHANGE INDICATOR")
  private String realAsExchangeYn;

  @ApiModelProperty(value = "REAL BEFORE PRODUCT CODE")
  private String realBeforeProductCode;

  @ApiModelProperty(value = "REAL BEFORE PRODUCT NAME")
  private String realBeforeProductName;

  @ApiModelProperty(value = "REAL BEFORE PRODUCT SERIAL NO")
  private String realBeforeProductSerialNo;

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

  public String getCustName() {
    return custName;
  }

  public void setCustName( String custName ) {
    this.custName = custName;
  }

  public String getJobType() {
    return jobType;
  }

  public void setJobType( String jobType ) {
    this.jobType = jobType;
  }

  public int getJobStatus() {
    return jobStatus;
  }

  public void setJobStatus( int jobStatus ) {
    this.jobStatus = jobStatus;
  }

  public String getAppointmentDate() {
    return appointmentDate;
  }

  public void setAppointmentDate( String appointmentDate ) {
    this.appointmentDate = appointmentDate;
  }

  public String getAppointmentTime() {
    return appointmentTime;
  }

  public void setAppointmentTime( String appointmentTime ) {
    this.appointmentTime = appointmentTime;
  }

  public String getJobSession() {
    return jobSession;
  }

  public void setJobSession( String jobSession ) {
    this.jobSession = jobSession;
  }

  public String getCheckInDate() {
    return checkInDate;
  }

  public void setCheckInDate( String checkInDate ) {
    this.checkInDate = checkInDate;
  }

  public String getCheckInTime() {
    return checkInTime;
  }

  public void setCheckInTime( String checkInTime ) {
    this.checkInTime = checkInTime;
  }

  public String getCheckInGps() {
    return checkInGps;
  }

  public void setCheckInGps( String checkInGps ) {
    this.checkInGps = checkInGps;
  }

  public String getCustomerType() {
    return customerType;
  }

  public void setCustomerType( String customerType ) {
    this.customerType = customerType;
  }

  public int getCustomerId() {
    return customerId;
  }

  public void setCustomerId( int customerId ) {
    this.customerId = customerId;
  }

  public String getServiceState() {
    return serviceState;
  }

  public void setServiceState( String serviceState ) {
    this.serviceState = serviceState;
  }

  public int getPlanYear() {
    return planYear;
  }

  public void setPlanYear( int planYear ) {
    this.planYear = planYear;
  }

  public int getPlanMonth() {
    return planMonth;
  }

  public void setPlanMonth( int planMonth ) {
    this.planMonth = planMonth;
  }

  public String getCustomerGps() {
    return customerGps;
  }

  public void setCustomerGps( String customerGps ) {
    this.customerGps = customerGps;
  }

  public String getInstallAddress() {
    return installAddress;
  }

  public void setInstallAddress( String installAddress ) {
    this.installAddress = installAddress;
  }

  public String getPostcode() {
    return postcode;
  }

  public void setPostcode( String postcode ) {
    this.postcode = postcode;
  }

  public String getHandphoneTel() {
    return handphoneTel;
  }

  public void setHandphoneTel( String handphoneTel ) {
    this.handphoneTel = handphoneTel;
  }

  public String getHomeTel() {
    return homeTel;
  }

  public void setHomeTel( String homeTel ) {
    this.homeTel = homeTel;
  }

  public String getOfficeTel() {
    return officeTel;
  }

  public void setOfficeTel( String officeTel ) {
    this.officeTel = officeTel;
  }

  public String getMailAddress() {
    return mailAddress;
  }

  public void setMailAddress( String mailAddress ) {
    this.mailAddress = mailAddress;
  }

  public String getCustomerVaNo() {
    return customerVaNo;
  }

  public void setCustomerVaNo( String customerVaNo ) {
    this.customerVaNo = customerVaNo;
  }

  public String getCustomerJomPayRefNo() {
    return customerJomPayRefNo;
  }

  public void setCustomerJomPayRefNo( String customerJomPayRefNo ) {
    this.customerJomPayRefNo = customerJomPayRefNo;
  }

  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl( String imageUrl ) {
    this.imageUrl = imageUrl;
  }

  public String getProductName() {
    return productName;
  }

  public void setProductName( String productName ) {
    this.productName = productName;
  }

  public String getProductCode() {
    return productCode;
  }

  public void setProductCode( String productCode ) {
    this.productCode = productCode;
  }

  public String getAppType() {
    return appType;
  }

  public void setAppType( String appType ) {
    this.appType = appType;
  }

  public String getInstruction() {
    return instruction;
  }

  public void setInstruction( String instruction ) {
    this.instruction = instruction;
  }

  public String getSalesPromotion() {
    return salesPromotion;
  }

  public void setSalesPromotion( String salesPromotion ) {
    this.salesPromotion = salesPromotion;
  }

  public int getContractDuration() {
    return contractDuration;
  }

  public void setContractDuration( int contractDuration ) {
    this.contractDuration = contractDuration;
  }

  public String getMonthlyRentalFees() {
    return monthlyRentalFees;
  }

  public void setMonthlyRentalFees( String monthlyRentalFees ) {
    this.monthlyRentalFees = monthlyRentalFees;
  }

  public int getRegistrationFees() {
    return registrationFees;
  }

  public void setRegistrationFees( int registrationFees ) {
    this.registrationFees = registrationFees;
  }

  public String getPaymentMode() {
    return paymentMode;
  }

  public void setPaymentMode( String paymentMode ) {
    this.paymentMode = paymentMode;
  }

  public int getBankCode() {
    return bankCode;
  }

  public void setBankCode( int bankCode ) {
    this.bankCode = bankCode;
  }

  public String getBankName() {
    return bankName;
  }

  public void setBankName( String bankName ) {
    this.bankName = bankName;
  }

  public String getCardAccountNo() {
    return cardAccountNo;
  }

  public void setCardAccountNo( String cardAccountNo ) {
    this.cardAccountNo = cardAccountNo;
  }

  public String getOutstanding() {
    return outstanding;
  }

  public void setOutstanding( String outstanding ) {
    this.outstanding = outstanding;
  }

  public String getExpiryDate() {
    return expiryDate;
  }

  public void setExpiryDate( String expiryDate ) {
    this.expiryDate = expiryDate;
  }

  public String getDscCode() {
    return dscCode;
  }

  public void setDscCode( String dscCode ) {
    this.dscCode = dscCode;
  }

  public String getSirimNo() {
    return sirimNo;
  }

  public void setSirimNo( String sirimNo ) {
    this.sirimNo = sirimNo;
  }

  public String getSerialNo() {
    return serialNo;
  }

  public void setSerialNo( String serialNo ) {
    this.serialNo = serialNo;
  }

  public String getHpName() {
    return hpName;
  }

  public void setHpName( String hpName ) {
    this.hpName = hpName;
  }

  public String getHpTel() {
    return hpTel;
  }

  public void setHpTel( String hpTel ) {
    this.hpTel = hpTel;
  }

  public String getSmName() {
    return smName;
  }

  public void setSmName( String smName ) {
    this.smName = smName;
  }

  public String getSmTel() {
    return smTel;
  }

  public void setSmTel( String smTel ) {
    this.smTel = smTel;
  }

  public String getHmName() {
    return hmName;
  }

  public void setHmName( String hmName ) {
    this.hmName = hmName;
  }

  public String getHmTel() {
    return hmTel;
  }

  public void setHmTel( String hmTel ) {
    this.hmTel = hmTel;
  }

  public String getBillAmount() {
    return billAmount;
  }

  public void setBillAmount( String billAmount ) {
    this.billAmount = billAmount;
  }

  public String getPaidAmount() {
    return paidAmount;
  }

  public void setPaidAmount( String paidAmount ) {
    this.paidAmount = paidAmount;
  }

  public String getAdjustmentAmount() {
    return adjustmentAmount;
  }

  public void setAdjustmentAmount( String adjustmentAmount ) {
    this.adjustmentAmount = adjustmentAmount;
  }

  public String getFileImg1Url() {
    return fileImg1Url;
  }

  public void setFileImg1Url( String fileImg1Url ) {
    this.fileImg1Url = fileImg1Url;
  }

  public String getFileImg2Url() {
    return fileImg2Url;
  }

  public void setFileImg2Url( String fileImg2Url ) {
    this.fileImg2Url = fileImg2Url;
  }

  public String getFileImg3Url() {
    return fileImg3Url;
  }

  public void setFileImg3Url( String fileImg3Url ) {
    this.fileImg3Url = fileImg3Url;
  }

  public String getResultRemark() {
    return resultRemark;
  }

  public void setResultRemark( String resultRemark ) {
    this.resultRemark = resultRemark;
  }

  public String getOwnerCode() {
    return ownerCode;
  }

  public void setOwnerCode( String ownerCode ) {
    this.ownerCode = ownerCode;
  }

  public String getOwnerCodeNm() {
    return ownerCodeNm;
  }

  public void setOwnerCodeNm( String ownerCodeNm ) {
    this.ownerCodeNm = ownerCodeNm;
  }

  public String getResultCustName() {
    return resultCustName;
  }

  public void setResultCustName( String resultCustName ) {
    this.resultCustName = resultCustName;
  }

  public String getResultIcMobileNo() {
    return resultIcMobileNo;
  }

  public void setResultIcMobileNo( String resultIcMobileNo ) {
    this.resultIcMobileNo = resultIcMobileNo;
  }

  public String getResultReportEmailNo() {
    return resultReportEmailNo;
  }

  public void setResultReportEmailNo( String resultReportEmailNo ) {
    this.resultReportEmailNo = resultReportEmailNo;
  }

  public String getResultAcceptanceName() {
    return resultAcceptanceName;
  }

  public void setResultAcceptanceName( String resultAcceptanceName ) {
    this.resultAcceptanceName = resultAcceptanceName;
  }

  public int getRcCode() {
    return rcCode;
  }

  public void setRcCode( int rcCode ) {
    this.rcCode = rcCode;
  }

  public int getFailReasonCode() {
    return failReasonCode;
  }

  public void setFailReasonCode( int failReasonCode ) {
    this.failReasonCode = failReasonCode;
  }

  public String getFailReasonName() {
    return failReasonName;
  }

  public void setFailReasonName( String failReasonName ) {
    this.failReasonName = failReasonName;
  }

  public String getSettledBy() {
    return settledBy;
  }

  public void setSettledBy( String settledBy ) {
    this.settledBy = settledBy;
  }

  public String getSettledDate() {
    return settledDate;
  }

  public void setSettledDate( String settledDate ) {
    this.settledDate = settledDate;
  }

  public String getSettledTime() {
    return settledTime;
  }

  public void setSettledTime( String settledTime ) {
    this.settledTime = settledTime;
  }

  public String getLastPaymentDate() {
    return lastPaymentDate;
  }

  public void setLastPaymentDate( String lastPaymentDate ) {
    this.lastPaymentDate = lastPaymentDate;
  }

  public String getNextCallDate() {
    return nextCallDate;
  }

  public void setNextCallDate( String nextCallDate ) {
    this.nextCallDate = nextCallDate;
  }

  public String getNextCallTime() {
    return nextCallTime;
  }

  public void setNextCallTime( String nextCallTime ) {
    this.nextCallTime = nextCallTime;
  }

  public String getAsExchangeYN() {
    return asExchangeYN;
  }

  public void setAsExchangeYN( String asExchangeYN ) {
    this.asExchangeYN = asExchangeYN;
  }

  public String getBeforeProductCode() {
    return beforeProductCode;
  }

  public void setBeforeProductCode( String beforeProductCode ) {
    this.beforeProductCode = beforeProductCode;
  }

  public String getBeforeProductSerialNo() {
    return beforeProductSerialNo;
  }

  public void setBeforeProductSerialNo( String beforeProductSerialNo ) {
    this.beforeProductSerialNo = beforeProductSerialNo;
  }

  public String getFraYn() {
    return fraYn;
  }

  public void setFraYn( String fraYn ) {
    this.fraYn = fraYn;
  }

  public String getFraOrdNo() {
    return fraOrdNo;
  }

  public void setFraOrdNo( String fraOrdNo ) {
    this.fraOrdNo = fraOrdNo;
  }

  public String getFraProductCode() {
    return fraProductCode;
  }

  public void setFraProductCode( String fraProductCode ) {
    this.fraProductCode = fraProductCode;
  }

  public String getFraProductName() {
    return fraProductName;
  }

  public void setFraProductName( String fraProductName ) {
    this.fraProductName = fraProductName;
  }

  public String getPsi() {
    return psi;
  }

  public void setPsi( String psi ) {
    this.psi = psi;
  }

  public String getLpm() {
    return lpm;
  }

  public void setLpm( String lpm ) {
    this.lpm = lpm;
  }

  public String getProdcat() {
    return prodcat;
  }

  public void setProdcat( String prodcat ) {
    this.prodcat = prodcat;
  }

  public String getWaterSrcType() {
    return waterSrcType;
  }

  public void setWaterSrcType( String waterSrcType ) {
    this.waterSrcType = waterSrcType;
  }

  public String getSerialChk() {
    return serialChk;
  }

  public void setSerialChk( String serialChk ) {
    this.serialChk = serialChk;
  }

  public String getSalesPromotionCde() {
    return salesPromotionCde;
  }

  public void setSalesPromotionCde( String salesPromotionCde ) {
    this.salesPromotionCde = salesPromotionCde;
  }

  public String getVoltage() {
    return voltage;
  }

  public void setVoltage( String voltage ) {
    this.voltage = voltage;
  }

  public String getTds() {
    return tds;
  }

  public void setTds( String tds ) {
    this.tds = tds;
  }

  public String getRoomTemp() {
    return roomTemp;
  }

  public void setRoomTemp( String roomTemp ) {
    this.roomTemp = roomTemp;
  }

  public String getWaterSrcTemp() {
    return waterSrcTemp;
  }

  public void setWaterSrcTemp( String waterSrcTemp ) {
    this.waterSrcTemp = waterSrcTemp;
  }

  public String getAdptUsed() {
    return adptUsed;
  }

  public void setAdptUsed( String adptUsed ) {
    this.adptUsed = adptUsed;
  }

  public String getInstChkLst() {
    return instChkLst;
  }

  public void setInstChkLst( String instChkLst ) {
    this.instChkLst = instChkLst;
  }

  public String getInstNoteChk() {
    return instNoteChk;
  }

  public void setInstNoteChk( String instNoteChk ) {
    this.instNoteChk = instNoteChk;
  }

  public String getBoosterPump() {
    return boosterPump;
  }

  public void setBoosterPump( String boosterPump ) {
    this.boosterPump = boosterPump;
  }

  public String getAftPsi() {
    return aftPsi;
  }

  public void setAftPsi( String aftPsi ) {
    this.aftPsi = aftPsi;
  }

  public String getAftLpm() {
    return aftLpm;
  }

  public void setAftLpm( String aftLpm ) {
    this.aftLpm = aftLpm;
  }

  public String getTurbLvl() {
    return turbLvl;
  }

  public void setTurbLvl( String turbLvl ) {
    this.turbLvl = turbLvl;
  }

  public String getChkSms() {
    return chkSms;
  }

  public void setChkSms( String chkSms ) {
    this.chkSms = chkSms;
  }

  public String getCheckSend() {
    return checkSend;
  }

  public void setCheckSend( String checkSend ) {
    this.checkSend = checkSend;
  }

  public String getCustMobileNo() {
    return custMobileNo;
  }

  public void setCustMobileNo( String custMobileNo ) {
    this.custMobileNo = custMobileNo;
  }

  public BigDecimal getLatitude() {
    return latitude;
  }

  public void setLatitude( BigDecimal latitude ) {
    this.latitude = latitude;
  }

  public BigDecimal getLongitude() {
    return longitude;
  }

  public void setLongitude( BigDecimal longitude ) {
    this.longitude = longitude;
  }

  public BigDecimal getNtu() {
    return ntu;
  }

  public void setNtu( BigDecimal ntu ) {
    this.ntu = ntu;
  }

  public String getIsJomTukar() {
    return isJomTukar;
  }

  public void setIsJomTukar( String isJomTukar ) {
    this.isJomTukar = isJomTukar;
  }

  public String getIsComptProd() {
    return isComptProd;
  }

  public void setIsComptProd( String isComptProd ) {
    this.isComptProd = isComptProd;
  }

  public String getComptBrnd() {
    return comptBrnd;
  }

  public void setComptBrnd( String comptBrnd ) {
    this.comptBrnd = comptBrnd;
  }

  public String getSrvTyp() {
    return srvTyp;
  }

  public void setSrvTyp( String srvTyp ) {
    this.srvTyp = srvTyp;
  }

  public String getPartnerCode() {
    return partnerCode;
  }

  public void setPartnerCode( String partnerCode ) {
    this.partnerCode = partnerCode;
  }

  public String getPartnerCodeName() {
    return partnerCodeName;
  }

  public void setPartnerCodeName( String partnerCodeName ) {
    this.partnerCodeName = partnerCodeName;
  }

  public String getFraSerialChk() {
    return fraSerialChk;
  }

  public void setFraSerialChk( String fraSerialChk ) {
    this.fraSerialChk = fraSerialChk;
  }

  public String getSelFraSerialNo() {
    return selFraSerialNo;
  }

  public void setSelFraSerialNo( String selFraSerialNo ) {
    this.selFraSerialNo = selFraSerialNo;
  }

  public String getRealAsExchangeYn() {
    return realAsExchangeYn;
  }

  public void setRealAsExchangeYn( String realAsExchangeYn ) {
    this.realAsExchangeYn = realAsExchangeYn;
  }

  public String getRealBeforeProductCode() {
    return realBeforeProductCode;
  }

  public void setRealBeforeProductCode( String realBeforeProductCode ) {
    this.realBeforeProductCode = realBeforeProductCode;
  }

  public String getRealBeforeProductName() {
    return realBeforeProductName;
  }

  public void setRealBeforeProductName( String realBeforeProductName ) {
    this.realBeforeProductName = realBeforeProductName;
  }

  public String getRealBeforeProductSerialNo() {
    return realBeforeProductSerialNo;
  }

  public void setRealBeforeProductSerialNo( String realBeforeProductSerialNo ) {
    this.realBeforeProductSerialNo = realBeforeProductSerialNo;
  }

  @SuppressWarnings("unchecked")
  public static InstallationJobDto create( EgovMap egvoMap ) {
    return BeanConverter.toBean( egvoMap, InstallationJobDto.class );
  }
}
