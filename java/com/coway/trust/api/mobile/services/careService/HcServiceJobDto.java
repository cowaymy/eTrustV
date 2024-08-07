package com.coway.trust.api.mobile.services.careService;

import java.math.BigDecimal;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HcServiceJobDto", description = "공통코드 Dto")
public class HcServiceJobDto {

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

  @ApiModelProperty(value = "작업 예정날짜")
  private String appointmentDate;

  @ApiModelProperty(value = "작업 예정시간")
  private String appointmentTime;

  @ApiModelProperty(value = "오전/오후/저녁(신규)")
  private String jobSession;

  @ApiModelProperty(value = "체크인 날짜(YYYYMMDD)")
  private String checkInDate;

  @ApiModelProperty(value = "체크인 시간(HHMM)")
  private String checkInTime;

  @ApiModelProperty(value = "체크인 GPS 값 (위도/경도값)")
  private String checkInGps;

  @ApiModelProperty(value = "일반/법인 고객 구분")
  private int customerType;

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
  private int appType;

  @ApiModelProperty(value = "")
  private String instruction;

  @ApiModelProperty(value = "")
  private String salesPromotion;

  @ApiModelProperty(value = "")
  private String contractDuration;

  @ApiModelProperty(value = "")
  private String monthlyRentalFees;

  @ApiModelProperty(value = "")
  private String registrationFees;

  @ApiModelProperty(value = "결제 방식 - Code")
  private String paymentMode;

  @ApiModelProperty(value = "결제 방식 - Name")
  private String paymentModeName;

  @ApiModelProperty(value = "결제 은행")
  private int bankCode;

  @ApiModelProperty(value = "결제 은행명")
  private String bankName;

  @ApiModelProperty(value = "결제 정보")
  private String cardAccountNo;

  @ApiModelProperty(value = "outstanding 정보(OutstandingV.total)")
  private String outstanding;

  @ApiModelProperty(value = "sirim 코드")
  private String sirimNo;

  @ApiModelProperty(value = "serial 코드")
  private String serialNo;

  @ApiModelProperty(value = "WARRANTY (YYYYMMDD)")
  private String warranty;

  @ApiModelProperty(value = "멤버십 만료 기간(YYYYMMDD)")
  private String MembershipContractExpiry;

  @ApiModelProperty(value = "렌탈 현황")
  private String rentalStatus;

  @ApiModelProperty(value = "")
  private int dscCode;

  @ApiModelProperty(value = "마지막 결제일(YYYYMMDD)")
  private String lastPaymentDate;

  @ApiModelProperty(value = "하트 결과등록시 체크")
  private String temperatureSetting;

  @ApiModelProperty(value = "remark")
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

  @ApiModelProperty(value = "설치시간(HHMMSS)")
  private String settledTime;

  @ApiModelProperty(value = "")
  private String renCollectionId;

  @ApiModelProperty(value = "bsr no")
  private String bsrNo;

  @ApiModelProperty(value = "다음 작업시간(HHMM)")
  private String needFilter;

  @ApiModelProperty(value = "다음 작업일자(YYYYMMDD)")
  private String nextAppointmentDate;

  @ApiModelProperty(value = "필터교체대상 여부")
  private String nextAppointmentTime;

  private String homeCareOrderYn;

  private String matsize;

  private String hcSalesOrderNo;

  private String hcRefNo;

  private String hcRefCat;

  private String hcRefProd;

  private String srvPacId;

  private String disinfecServ;

  private String srvType;

  private BigDecimal latitude;

  private BigDecimal longitude;

  private String prodCat;

  public String getHomeCareOrderYn() {
    return homeCareOrderYn;
  }

  public void setHomeCareOrderYn(String homeCareOrderYn) {
    this.homeCareOrderYn = homeCareOrderYn;
  }

  private String serialChk;

  public String getSerialChk() {
    return serialChk;
  }

  public void setSerialChk(String serialChk) {
    this.serialChk = serialChk;
  }

  public void setSalesOrderNo(String salesOrderNo) {
    this.salesOrderNo = salesOrderNo;
  }

  public void setJobStatus(int jobStatus) {
    this.jobStatus = jobStatus;
  }

  public void setCustomerType(int customerType) {
    this.customerType = customerType;
  }

  public void setCustomerId(int customerId) {
    this.customerId = customerId;
  }

  public void setPlanYear(int planYear) {
    this.planYear = planYear;
  }

  public void setPlanMonth(int planMonth) {
    this.planMonth = planMonth;
  }

  public void setFailReasonCode(int failReasonCode) {
    this.failReasonCode = failReasonCode;
  }

  public String getSalesOrderNo() {
    return salesOrderNo;
  }

  public int getJobStatus() {
    return jobStatus;
  }

  public int getCustomerType() {
    return customerType;
  }

  public int getCustomerId() {
    return customerId;
  }

  public int getPlanYear() {
    return planYear;
  }

  public int getPlanMonth() {
    return planMonth;
  }

  public String getAppointmentDate() {
    return appointmentDate;
  }

  public void setAppointmentDate(String appointmentDate) {
    this.appointmentDate = appointmentDate;
  }

  public String getAppointmentTime() {
    return appointmentTime;
  }

  public void setAppointmentTime(String appointmentTime) {
    this.appointmentTime = appointmentTime;
  }

  public String getJobSession() {
    return jobSession;
  }

  public void setJobSession(String jobSession) {
    this.jobSession = jobSession;
  }

  public String getCheckInDate() {
    return checkInDate;
  }

  public void setCheckInDate(String checkInDate) {
    this.checkInDate = checkInDate;
  }

  public String getCheckInTime() {
    return checkInTime;
  }

  public void setCheckInTime(String checkInTime) {
    this.checkInTime = checkInTime;
  }

  public String getCheckInGps() {
    return checkInGps;
  }

  public void setCheckInGps(String checkInGps) {
    this.checkInGps = checkInGps;
  }

  public String getServiceState() {
    return serviceState;
  }

  public void setServiceState(String serviceState) {
    this.serviceState = serviceState;
  }

  public String getCustomerGps() {
    return customerGps;
  }

  public void setCustomerGps(String customerGps) {
    this.customerGps = customerGps;
  }

  public String getInstallAddress() {
    return installAddress;
  }

  public void setInstallAddress(String installAddress) {
    this.installAddress = installAddress;
  }

  public String getPostcode() {
    return postcode;
  }

  public void setPostcode(String postcode) {
    this.postcode = postcode;
  }

  public String getHandphoneTel() {
    return handphoneTel;
  }

  public void setHandphoneTel(String handphoneTel) {
    this.handphoneTel = handphoneTel;
  }

  public String getHomeTel() {
    return homeTel;
  }

  public void setHomeTel(String homeTel) {
    this.homeTel = homeTel;
  }

  public String getOfficeTel() {
    return officeTel;
  }

  public void setOfficeTel(String officeTel) {
    this.officeTel = officeTel;
  }

  public String getMailAddress() {
    return mailAddress;
  }

  public void setMailAddress(String mailAddress) {
    this.mailAddress = mailAddress;
  }

  public String getCustomerVaNo() {
    return customerVaNo;
  }

  public void setCustomerVaNo(String customerVaNo) {
    this.customerVaNo = customerVaNo;
  }

  public String getCustomerJomPayRefNo() {
    return customerJomPayRefNo;
  }

  public void setCustomerJomPayRefNo(String customerJomPayRefNo) {
    this.customerJomPayRefNo = customerJomPayRefNo;
  }

  public String getImageUrl() {
    return imageUrl;
  }

  public void setImageUrl(String imageUrl) {
    this.imageUrl = imageUrl;
  }

  public String getProductName() {
    return productName;
  }

  public void setProductName(String productName) {
    this.productName = productName;
  }

  public String getProductCode() {
    return productCode;
  }

  public void setProductCode(String productCode) {
    this.productCode = productCode;
  }

  public String getInstruction() {
    return instruction;
  }

  public void setInstruction(String instruction) {
    this.instruction = instruction;
  }

  public String getContractDuration() {
    return contractDuration;
  }

  public void setContractDuration(String contractDuration) {
    this.contractDuration = contractDuration;
  }

  public String getMonthlyRentalFees() {
    return monthlyRentalFees;
  }

  public void setMonthlyRentalFees(String monthlyRentalFees) {
    this.monthlyRentalFees = monthlyRentalFees;
  }

  public String getRegistrationFees() {
    return registrationFees;
  }

  public void setRegistrationFees(String registrationFees) {
    this.registrationFees = registrationFees;
  }

  public String getPaymentMode() {
    return paymentMode;
  }

  public void setPaymentMode(String paymentMode) {
    this.paymentMode = paymentMode;
  }

  public String getPaymentModeName() {
    return paymentModeName;
  }

  public void setPaymentModeName(String paymentModeName) {
    this.paymentModeName = paymentModeName;
  }

  public String getBankName() {
    return bankName;
  }

  public void setBankName(String bankName) {
    this.bankName = bankName;
  }

  public String getCardAccountNo() {
    return cardAccountNo;
  }

  public void setCardAccountNo(String cardAccountNo) {
    this.cardAccountNo = cardAccountNo;
  }

  public String getOutstanding() {
    return outstanding;
  }

  public void setOutstanding(String outstanding) {
    this.outstanding = outstanding;
  }

  public String getSirimNo() {
    return sirimNo;
  }

  public void setSirimNo(String sirimNo) {
    this.sirimNo = sirimNo;
  }

  public String getSerialNo() {
    return serialNo;
  }

  public void setSerialNo(String serialNo) {
    this.serialNo = serialNo;
  }

  public String getWarranty() {
    return warranty;
  }

  public void setWarranty(String warranty) {
    this.warranty = warranty;
  }

  public String getMembershipContractExpiry() {
    return MembershipContractExpiry;
  }

  public void setMembershipContractExpiry(String membershipContractExpiry) {
    MembershipContractExpiry = membershipContractExpiry;
  }

  public String getRentalStatus() {
    return rentalStatus;
  }

  public void setRentalStatus(String rentalStatus) {
    this.rentalStatus = rentalStatus;
  }

  public String getLastPaymentDate() {
    return lastPaymentDate;
  }

  public void setLastPaymentDate(String lastPaymentDate) {
    this.lastPaymentDate = lastPaymentDate;
  }

  public String getTemperatureSetting() {
    return temperatureSetting;
  }

  public void setTemperatureSetting(String temperatureSetting) {
    this.temperatureSetting = temperatureSetting;
  }

  public String getResultRemark() {
    return resultRemark;
  }

  public void setResultRemark(String resultRemark) {
    this.resultRemark = resultRemark;
  }

  public String getOwnerCode() {
    return ownerCode;
  }

  public void setOwnerCode(String ownerCode) {
    this.ownerCode = ownerCode;
  }

  public String getOwnerCodeNm() {
    return ownerCodeNm;
  }

  public void setOwnerCodeNm(String ownerCodeNm) {
    this.ownerCodeNm = ownerCodeNm;
  }

  public String getResultCustName() {
    return resultCustName;
  }

  public void setResultCustName(String resultCustName) {
    this.resultCustName = resultCustName;
  }

  public String getResultIcMobileNo() {
    return resultIcMobileNo;
  }

  public void setResultIcMobileNo(String resultIcMobileNo) {
    this.resultIcMobileNo = resultIcMobileNo;
  }

  public String getResultReportEmailNo() {
    return resultReportEmailNo;
  }

  public void setResultReportEmailNo(String resultReportEmailNo) {
    this.resultReportEmailNo = resultReportEmailNo;
  }

  public String getResultAcceptanceName() {
    return resultAcceptanceName;
  }

  public void setResultAcceptanceName(String resultAcceptanceName) {
    this.resultAcceptanceName = resultAcceptanceName;
  }

  public String getFailReasonName() {
    return failReasonName;
  }

  public void setFailReasonName(String failReasonName) {
    this.failReasonName = failReasonName;
  }

  public String getSettledBy() {
    return settledBy;
  }

  public void setSettledBy(String settledBy) {
    this.settledBy = settledBy;
  }

  public String getSettledDate() {
    return settledDate;
  }

  public void setSettledDate(String settledDate) {
    this.settledDate = settledDate;
  }

  public String getSettledTime() {
    return settledTime;
  }

  public void setSettledTime(String settledTime) {
    this.settledTime = settledTime;
  }

  public String getRenCollectionId() {
    return renCollectionId;
  }

  public void setRenCollectionId(String renCollectionId) {
    this.renCollectionId = renCollectionId;
  }

  public String getBsrNo() {
    return bsrNo;
  }

  public void setBsrNo(String bsrNo) {
    this.bsrNo = bsrNo;
  }

  public String getNeedFilter() {
    return needFilter;
  }

  public void setNeedFilter(String needFilter) {
    this.needFilter = needFilter;
  }

  public String getNextAppointmentDate() {
    return nextAppointmentDate;
  }

  public void setNextAppointmentDate(String nextAppointmentDate) {
    this.nextAppointmentDate = nextAppointmentDate;
  }

  public String getNextAppointmentTime() {
    return nextAppointmentTime;
  }

  public void setNextAppointmentTime(String nextAppointmentTime) {
    this.nextAppointmentTime = nextAppointmentTime;
  }

  public static HcServiceJobDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, HcServiceJobDto.class);
  }

  public String getServiceNo() {
    return serviceNo;
  }

  public void setServiceNo(String serviceNo) {
    this.serviceNo = serviceNo;
  }

  public String getCustName() {
    return custName;
  }

  public void setCustName(String custName) {
    this.custName = custName;
  }

  public String getJobType() {
    return jobType;
  }

  public void setJobType(String jobType) {
    this.jobType = jobType;
  }

  public int getAppType() {
    return appType;
  }

  public void setAppType(int appType) {
    this.appType = appType;
  }

  public String getSalesPromotion() {
    return salesPromotion;
  }

  public void setSalesPromotion(String salesPromotion) {
    this.salesPromotion = salesPromotion;
  }

  public int getBankCode() {
    return bankCode;
  }

  public void setBankCode(int bankCode) {
    this.bankCode = bankCode;
  }

  public int getDscCode() {
    return dscCode;
  }

  public void setDscCode(int dscCode) {
    this.dscCode = dscCode;
  }

  public int getRcCode() {
    return rcCode;
  }

  public void setRcCode(int rcCode) {
    this.rcCode = rcCode;
  }

  public int getFailReasonCode() {
    return failReasonCode;
  }

  public String getMatsize() {
    return matsize;
  }

  public void setMatsize(String matsize) {
    this.matsize = matsize;
  }

  public String getHcSalesOrderNo() {
    return hcSalesOrderNo;
  }

  public void setHcSalesOrderNo(String hcSalesOrderNo) {
    this.hcSalesOrderNo = hcSalesOrderNo;
  }

  public String getHcRefNo() {
    return hcRefNo;
  }

  public void setHcRefNo(String hcRefNo) {
    this.hcRefNo = hcRefNo;
  }

  public String getHcRefCat() {
    return hcRefCat;
  }

  public void setHcRefCat(String hcRefCat) {
    this.hcRefCat = hcRefCat;
  }

  public String getHcRefProd() {
    return hcRefProd;
  }

  public void setHcRefProd(String hcRefProd) {
    this.hcRefProd = hcRefProd;
  }

  public String getSrvPacId() {
    return srvPacId;
  }

  public void setSrvPacId(String srvPacId) {
    this.srvPacId = srvPacId;
  }

  public String getDisinfecServ() {
    return disinfecServ;
  }

  public void setDisinfecServ(String disinfecServ) {
    this.disinfecServ = disinfecServ;
  }

  public String getSrvType() {
	    return srvType;
  }

  public void setSrvType(String srvType) {
	    this.srvType = srvType;
  }

  public BigDecimal getLatitude(){
    return latitude;
  }

  public void setLatitude(BigDecimal latitude){
    this.latitude = latitude;
  }

  public BigDecimal getLongitude(){
    return longitude;
  }

  public void setLongitude(BigDecimal longitude){
     this.longitude = longitude;
  }

  public String getProdCat() {
	    return prodCat;
}

public void setProdCat(String prodCat) {
	    this.prodCat = prodCat;
}
}
