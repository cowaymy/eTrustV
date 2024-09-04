package com.coway.trust.api.mobile.services.dtInstallation;

import java.math.BigDecimal;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallationJobDto", description = "공통코드 Dto")
public class DtInstallationJobDto {
  @ApiModelProperty(value = "주문번호")
  private String salesOrderNo;

  @ApiModelProperty(value = "EX_BS00000 / AS00000")
  private String serviceNo;

  @ApiModelProperty(value = "고객명")
  private String custName;

  @ApiModelProperty(value = "AS / HS / INST / PR 구분값")
  private String jobType;

  @ApiModelProperty(value = "ACT / COMPLETE / FAIL / CANCLE 구분")
  private int jobStatus;

  @ApiModelProperty(value = "작업 예정날짜(YYYYMMDD)")
  private String appointmentDate;

  private String appointmentTime;

  @ApiModelProperty(value = "오전/오후/저녁")
  private String jobSession;

  @ApiModelProperty(value = "체크인 날짜(YYYYMMDD)")
  private String checkInDate;

  @ApiModelProperty(value = "체크인 시간(HHMM)")
  private String checkInTime;

  @ApiModelProperty(value = "체크인 GPS 값 (위도/경도값)")
  private String checkInGps;

  @ApiModelProperty(value = "일반/법인 고객 구분")
  private String customerType;

  @ApiModelProperty(value = "고객 id_170911 추가 (묶음 결과등록시 필요)")
  private int customerId;

  @ApiModelProperty(value = "작업 영역(State)_170906 추가")
  private String serviceState;

  @ApiModelProperty(value = "작업예정일(년)_170908 추가")
  private int planYear;

  @ApiModelProperty(value = "작업예정일(월)_170908 추가")
  private int planMonth;

  @ApiModelProperty(value = "고객 GPS 값 (위도/경도값)")
  private String customerGps;

  @ApiModelProperty(value = "설치주소(Magic Address 체계?)")
  private String installAddress;

  @ApiModelProperty(value = "우편번호")
  private String postcode;

  @ApiModelProperty(value = "핸드폰 번호")
  private String handphoneTel;

  @ApiModelProperty(value = "집전화 번호")
  private String homeTel;

  @ApiModelProperty(value = "회사 번호")
  private String officeTel;

  @ApiModelProperty(value = "메일 주소")
  private String mailAddress;

  @ApiModelProperty(value = "고객 VA 번호_170914 추가")
  private String customerVaNo;

  @ApiModelProperty(value = "고객 JomPay Reference 번호_170914 추가")
  private String customerJomPayRefNo;

  @ApiModelProperty(value = "제품 사진 url")
  private String imageUrl;

  @ApiModelProperty(value = "제품명")
  private String productName;

  @ApiModelProperty(value = "제품코드")
  private String productCode;

  @ApiModelProperty(value = "application Type (Rental…)")
  private String appType;

  @ApiModelProperty(value = "")
  private String instruction;

  @ApiModelProperty(value = "")
  private String salesPromotion;

  @ApiModelProperty(value = "")
  private int contractDuration;

  @ApiModelProperty(value = "")
  private String monthlyRentalFees;

  @ApiModelProperty(value = "")
  private int registrationFees;

  @ApiModelProperty(value = "결제 방식")
  private String paymentMode;

  @ApiModelProperty(value = "결제 은행")
  private int bankCode;

  @ApiModelProperty(value = "결제 은행명")
  private String bankName;

  @ApiModelProperty(value = "결제 정보")
  private String cardAccountNo;

  @ApiModelProperty(value = "outstanding 정보")
  private String outstanding;

  @ApiModelProperty(value = "유효기간 만료일 - YYYYMMDD")
  private String expiryDate;

  @ApiModelProperty(value = "")
  private String dscCode;

  @ApiModelProperty(value = "sirim 코드")
  private String sirimNo;

  @ApiModelProperty(value = "serial 코드")
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

  @ApiModelProperty(value = "")
  private String billAmount;

  @ApiModelProperty(value = "")
  private String paidAmount;

  @ApiModelProperty(value = "")
  private String adjustmentAmount;

  @ApiModelProperty(value = "설치시 등록한 이미지 정보_1")
  private String fileImg1Url;

  @ApiModelProperty(value = "설치시 등록한 이미지 정보_2")
  private String fileImg2Url;

  @ApiModelProperty(value = "설치시 등록한 이미지 정보_3")
  private String fileImg3Url;

  @ApiModelProperty(value = "")
  private String resultRemark;

  @ApiModelProperty(value = "서명한사람 코드(owner / father…)")
  private String ownerCode;

  @ApiModelProperty(value = "별도의 코드로 관리안하면 필요없음.")
  private String ownerCodeNm;

  @ApiModelProperty(value = "고객명")
  private String resultCustName;

  @ApiModelProperty(value = "nric 번호")
  private String resultIcMobileNo;

  @ApiModelProperty(value = "고객메일주소")
  private String resultReportEmailNo;

  @ApiModelProperty(value = "신규 요건(default : 고객명)")
  private String resultAcceptanceName;

  @ApiModelProperty(value = "")
  private int rcCode;

  @ApiModelProperty(value = "실패 사유 코드")
  private int failReasonCode;

  @ApiModelProperty(value = "실패 사유명")
  private String failReasonName;

  @ApiModelProperty(value = "설치자")
  private String settledBy;

  @ApiModelProperty(value = "설치날짜(YYYYMMDD)")
  private String settledDate;

  @ApiModelProperty(value = "설치시간(HHMM)")
  private String settledTime;

  @ApiModelProperty(value = "")
  private String lastPaymentDate;

  @ApiModelProperty(value = "YYYYMMDD")
  private String nextCallDate;

  @ApiModelProperty(value = "HHMM")
  private String nextCallTime;

  @ApiModelProperty(value = "Product Exchange 대상 여부")
  private String asExchangeYN;

  @ApiModelProperty(value = "Product Exchange 대상일 경우, 교체대상 제품코드")
  private String beforeProductCode;

  @ApiModelProperty(value = "Product Exchange 대상일 경우, 교체대상 제품 SN")
  private String beforeProductSerialNo;

  @ApiModelProperty(value = "fraYn")
  private String fraYn;

  @ApiModelProperty(value = "fraOrdNo")
  private String fraOrdNo;

  @ApiModelProperty(value = "fraProductCode")
  private String fraProductCode;

  @ApiModelProperty(value = "fraProductName")
  private String fraProductName;

  private String serialChk;

  private BigDecimal latitude;

  private BigDecimal longitude;

  private int partnerCode;

  private String memCode;

  private String srvTyp;

  private String dispComm;
  
  private String prodCat;

  public int getPartnerCode() {
    return partnerCode;
  }

  public String getMemCode() {
    return memCode;
  }

  public void setPartnerCode( int partnerCode ) {
    this.partnerCode = partnerCode;
  }

  public void setMemCode( String memCode ) {
    this.memCode = memCode;
  }

  public String getSerialChk() {
    return serialChk;
  }

  public void setSerialChk( String serialChk ) {
    this.serialChk = serialChk;
  }

  private String fraSerialChk;

  public String getFraSerialChk() {
    return fraSerialChk;
  }

  public void setFraSerialChk( String fraSerialChk ) {
    this.fraSerialChk = fraSerialChk;
  }

  private String selFraSerialNo;

  public String getSelFraSerialNo() {
    return selFraSerialNo;
  }

  public void setSelFraSerialNo( String selFraSerialNo ) {
    this.selFraSerialNo = selFraSerialNo;
  }

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

  public String getSrvTyp() {
    return srvTyp;
  }

  public void setSrvTyp( String srvTyp ) {
    this.srvTyp = srvTyp;
  }

  public String getDispComm() {
    return dispComm;
  }

  public void setDispComm( String dispComm ) {
    this.dispComm = dispComm;
  }

  public String getProdCat() {
    return prodCat;
  }

  public void setProdCat( String prodCat ) {
    this.prodCat = prodCat;
  }

  public static DtInstallationJobDto create( EgovMap egvoMap ) {
    return BeanConverter.toBean( egvoMap, DtInstallationJobDto.class );
  }
}
