package com.coway.trust.api.mobile.services.productRetrun;

import com.coway.trust.util.BeanConverter;
import java.math.BigDecimal;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ProductRetrunJobDto", description = "공통코드 Dto")
public class ProductRetrunJobDto {
  @ApiModelProperty(value = "SALES ORDER NO")
  private String salesOrderNo;

  @ApiModelProperty(value = "PRODUCT RETURN NO")
  private String serviceNo;

  @ApiModelProperty(value = "CUSTOMER NAME")
  private String custName;

  @ApiModelProperty(value = "AS / HS / INST / PR TYPE")
  private String jobType;

  @ApiModelProperty(value = "ACT / COMPLETE / FAIL / CANCLE STATUS")
  private String jobStatus;

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
  private String customerId;

  @ApiModelProperty(value = "SERIVCE STATE")
  private String serviceState;

  @ApiModelProperty(value = "YEAR")
  private String planYear;

  @ApiModelProperty(value = "MONTH")
  private String planMonth;

  @ApiModelProperty(value = "CUSTOMER GPS")
  private String customerGps;

  @ApiModelProperty(value = "INSTALL ADDRESS")
  private String installAddress;

  @ApiModelProperty(value = "POST CODE")
  private String postcode;

  @ApiModelProperty(value = "MOBILE NUMBER")
  private String handphoneTel;

  @ApiModelProperty(value = "RESIDENT CONTACT NO")
  private String homeTel;

  @ApiModelProperty(value = "OFFICE CONTACT NO")
  private String officeTel;

  @ApiModelProperty(value = "EMAIL ADDRESS")
  private String mailAddress;

  @ApiModelProperty(value = "VA ACCOUNT")
  private String customerVaNo;

  @ApiModelProperty(value = "CUSTOMER JOM PAY REF NO")
  private String customerJomPayRefNo;

  @ApiModelProperty(value = "IMAGE URL")
  private String imageUrl;

  @ApiModelProperty(value = "PRODUCT NAME")
  private String productName;

  @ApiModelProperty(value = "PRODUCT CODE")
  private String productCode;

  @ApiModelProperty(value = "APPLICATION TYPE")
  private String appType;

  @ApiModelProperty(value = "INSTRUCTION")
  private String instruction;

  @ApiModelProperty(value = "INSTALLATION INSTRUCTION")
  private String instructionIns;

  @ApiModelProperty(value = "INSTALLATION DATE")
  private String installationDate;

  @ApiModelProperty(value = "INSTALLED BY")
  private String installedBy;

  @ApiModelProperty(value = "PREVIOUS OUTSTANDING")
  private String prevOutstanding;

  @ApiModelProperty(value = "PENALTY CHARGES")
  private String penaltyCharges;

  @ApiModelProperty(value = "UNBILLED AMOUNT")
  private String unbilledAmount;

  @ApiModelProperty(value = "OUTSTANDING")
  private String outstanding;

  @ApiModelProperty(value = "DSC CODE")
  private String dscCode;

  @ApiModelProperty(value = "SIRIM NO")
  private String sirimNo;

  @ApiModelProperty(value = "SERIAL NO")
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

  @ApiModelProperty(value = "CANCELLATION CODE")
  private String ccCode;

  @ApiModelProperty(value = "RESULT CODE")
  private String resultCode;

  @ApiModelProperty(value = "REMARK")
  private String resultRemark;

  @ApiModelProperty(value = "OWNER CODE")
  private String ownerCode;

  @ApiModelProperty(value = "OWNER CODE NAME")
  private String ownerCodeNm;

  @ApiModelProperty(value = "RESULT CUSTOMER NAME")
  private String resultCustName;

  @ApiModelProperty(value = "RESULT MOBILE NO")
  private String resultIcMobileNo;

  @ApiModelProperty(value = "RESULT EMAIL NO")
  private String resultReportEmailNo;

  @ApiModelProperty(value = "RESULT ACCEPTANCE NAME")
  private String resultAcceptanceName;

  @ApiModelProperty(value = "RENTAL COLLECTION CODE")
  private String rcCode;

  @ApiModelProperty(value = "FAIL REASON CODE")
  private String failReasonCode;

  @ApiModelProperty(value = "FAIL REASON NAME")
  private String failReasonName;

  @ApiModelProperty(value = "SETTLE BY")
  private String settledBy;

  @ApiModelProperty(value = "SATTLE DATE")
  private String settledDate;

  @ApiModelProperty(value = "SATTLE TIME")
  private String settledTime;

  @ApiModelProperty(value = "COMPLETE RETURN DATE")
  private String completeRetDate;

  @ApiModelProperty(value = "COMPLETE RETURN TIME")
  private String completeRetTime;

  @ApiModelProperty(value = "LAST PAYMENT DATE")
  private String lastPaymentDate;

  @ApiModelProperty(value = "NEXT CALL DATE")
  private String nextCallDate;

  @ApiModelProperty(value = "NECT CALL TIME")
  private String nextCallTime;

  @ApiModelProperty(value = "FRAME INDICATOR")
  private String fraYn;

  @ApiModelProperty(value = "FRAME ORDER NO")
  private String fraOrdNo;

  @ApiModelProperty(value = "FRAME PRODUCT CODE")
  private String fraProductCode;

  @ApiModelProperty(value = "FRAME PRODUCT NAME")
  private String fraProductName;

  @ApiModelProperty(value = "RETURN FAIL CODE REMARK")
  private String retnCodeFailRemark;

  @ApiModelProperty(value = "SERIAL CHECK")
  private String serialChk;

  @ApiModelProperty(value = "LATITUDE")
  private BigDecimal latitude;

  @ApiModelProperty(value = "LONGTITUDE")
  private BigDecimal longitude;

  @ApiModelProperty(value = "SALES PROMOTION")
  private String salesPromotion;

  @ApiModelProperty(value = "PARTNER CODE")
  private String partnerCode;

  @ApiModelProperty(value = "PARTNER CODE NAME")
  private String partnerCodeName;

  @ApiModelProperty(value = "PRODUCT CATEGORY")
  private String prodCat;

  @ApiModelProperty(value = "FRAME SERIAL CHECK")
  private String fraSerialChk;

  @ApiModelProperty(value = "SERAIL NO")
  private String selSerialNo;

  @ApiModelProperty(value = "FRAME SERIAL NO")
  private String selFraSerialNo;

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

  public String getJobStatus() {
    return jobStatus;
  }

  public void setJobStatus( String jobStatus ) {
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

  public String getCustomerId() {
    return customerId;
  }

  public void setCustomerId( String customerId ) {
    this.customerId = customerId;
  }

  public String getServiceState() {
    return serviceState;
  }

  public void setServiceState( String serviceState ) {
    this.serviceState = serviceState;
  }

  public String getPlanYear() {
    return planYear;
  }

  public void setPlanYear( String planYear ) {
    this.planYear = planYear;
  }

  public String getPlanMonth() {
    return planMonth;
  }

  public void setPlanMonth( String planMonth ) {
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

  public String getInstructionIns() {
    return instructionIns;
  }

  public void setInstructionIns( String instructionIns ) {
    this.instructionIns = instructionIns;
  }

  public String getInstallationDate() {
    return installationDate;
  }

  public void setInstallationDate( String installationDate ) {
    this.installationDate = installationDate;
  }

  public String getInstalledBy() {
    return installedBy;
  }

  public void setInstalledBy( String installedBy ) {
    this.installedBy = installedBy;
  }

  public String getPrevOutstanding() {
    return prevOutstanding;
  }

  public void setPrevOutstanding( String prevOutstanding ) {
    this.prevOutstanding = prevOutstanding;
  }

  public String getPenaltyCharges() {
    return penaltyCharges;
  }

  public void setPenaltyCharges( String penaltyCharges ) {
    this.penaltyCharges = penaltyCharges;
  }

  public String getUnbilledAmount() {
    return unbilledAmount;
  }

  public void setUnbilledAmount( String unbilledAmount ) {
    this.unbilledAmount = unbilledAmount;
  }

  public String getOutstanding() {
    return outstanding;
  }

  public void setOutstanding( String outstanding ) {
    this.outstanding = outstanding;
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

  public String getCcCode() {
    return ccCode;
  }

  public void setCcCode( String ccCode ) {
    this.ccCode = ccCode;
  }

  public String getResultCode() {
    return resultCode;
  }

  public void setResultCode( String resultCode ) {
    this.resultCode = resultCode;
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

  public String getRcCode() {
    return rcCode;
  }

  public void setRcCode( String rcCode ) {
    this.rcCode = rcCode;
  }

  public String getFailReasonCode() {
    return failReasonCode;
  }

  public void setFailReasonCode( String failReasonCode ) {
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

  public String getCompleteRetDate() {
    return completeRetDate;
  }

  public void setCompleteRetDate( String completeRetDate ) {
    this.completeRetDate = completeRetDate;
  }

  public String getCompleteRetTime() {
    return completeRetTime;
  }

  public void setCompleteRetTime( String completeRetTime ) {
    this.completeRetTime = completeRetTime;
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

  public String getRetnCodeFailRemark() {
    return retnCodeFailRemark;
  }

  public void setRetnCodeFailRemark( String retnCodeFailRemark ) {
    this.retnCodeFailRemark = retnCodeFailRemark;
  }

  public String getSerialChk() {
    return serialChk;
  }

  public void setSerialChk( String serialChk ) {
    this.serialChk = serialChk;
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

  public String getSalesPromotion() {
    return salesPromotion;
  }

  public void setSalesPromotion( String salesPromotion ) {
    this.salesPromotion = salesPromotion;
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

  public String getProdCat() {
    return prodCat;
  }

  public void setProdCat( String prodCat ) {
    this.prodCat = prodCat;
  }

  public String getFraSerialChk() {
    return fraSerialChk;
  }

  public void setFraSerialChk( String fraSerialChk ) {
    this.fraSerialChk = fraSerialChk;
  }

  public String getSelSerialNo() {
    return selSerialNo;
  }

  public void setSelSerialNo( String selSerialNo ) {
    this.selSerialNo = selSerialNo;
  }

  public String getSelFraSerialNo() {
    return selFraSerialNo;
  }

  public void setSelFraSerialNo( String selFraSerialNo ) {
    this.selFraSerialNo = selFraSerialNo;
  }

  @SuppressWarnings("unchecked")
  public static ProductRetrunJobDto create( EgovMap egvoMap ) {
    return BeanConverter.toBean( egvoMap, ProductRetrunJobDto.class );
  }
}
