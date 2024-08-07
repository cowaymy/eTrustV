package com.coway.trust.api.mobile.services.as;

import com.coway.trust.api.mobile.services.heartService.HeartServiceJobDto;
import com.coway.trust.util.BeanConverter;
import java.math.BigDecimal;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceJobDto", description = "공통코드 Dto")
public class AfterServiceJobDto {

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

  @ApiModelProperty(value = "체크인 날짜")
  private String checkInDate;

  @ApiModelProperty(value = "체크인 시간")
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
  private String planYear;

  @ApiModelProperty(value = "작업예정일(월)_170908 추가")
  private String planMonth;

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

  private String instruction;

  private String salesPromotion;

  private String requestor;

  private String requestorContact;

  private int contractDuration;

  private int monthlyRentalFees;

  private int registrationFees;

  @ApiModelProperty(value = "결제 방식 - Code")
  private String paymentMode;

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

  @ApiModelProperty(value = "WARRANTY ")
  private String warranty;

  @ApiModelProperty(value = "멤버십 만료 기간")
  private String MembershipContractExpiry;

  @ApiModelProperty(value = "렌탈 현황")
  private String rentalStatus;

  private String dscCode;

  @ApiModelProperty(value = "설치일자 (YYYYMMDD)")
  private String installationDate;

  @ApiModelProperty(value = "labour Charge 금액 (작업결과보기시 필요)")
  private int labourCharge;

  private int defectTypeId;

  private int defectGroupId;

  private int defectId;

  private int defectPartGroupId;

  private int defectPartId;

  private int defectDetailReasonId;

  private int solutionReasonId;

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

  private String rcCode;

  @ApiModelProperty(value = "결함코드")
  private int malfunctionCode;

  @ApiModelProperty(value = "결함코드명")
  private String malfunctionName;

  @ApiModelProperty(value = "결함 사유 코드")
  private int malfunctionReasonCode;

  @ApiModelProperty(value = "결함 사유명")
  private String malfunctionReasonName;

  @ApiModelProperty(value = "실패 사유 코드")
  private int failReasonCode;

  @ApiModelProperty(value = "실패 사유명")
  private String failReasonName;

  @ApiModelProperty(value = "설치자")
  private String settledBy;

  @ApiModelProperty(value = "설치날짜")
  private String settledDate;

  @ApiModelProperty(value = "설치시간")
  private String settledTime;

  @ApiModelProperty(value = "inHouseRepair 처리시 등록되는 Remark_170906 추가")
  private String inHouseRepairRemark;

  @ApiModelProperty(value = "inHouseRepair 처리시 등록되는 Replacement 여부_170906 추가")
  private String inhouserepairreplacementyn;

  @ApiModelProperty(value = "inHouseRepair 처리시 등록되는 약속일자_170906 추가")
  private String inHouseRepairPromisedDate;

  @ApiModelProperty(value = "inHouseRepair 처리시 등록되는 제품대그룹 코드_170906 추가")
  private String inhouserepairproductgroupcode;

  @ApiModelProperty(value = "inHouseRepair 처리시 등록되는 제품코드_170906 추가")
  private String inHouseRepairProductCode;

  @ApiModelProperty(value = "inHouseRepair 처리시 등록되는 제품 SN_170906 추가")
  private String inHouseRepairSerialNo;

  @ApiModelProperty(value = "inHouseRepair 대상 여부(작업처리시, 대상이 Y 이면, 보여주기만하고 Complete)")
  private String inhouserepairyn;

  private int renCollectionId;

  @ApiModelProperty(value = "마지막 결제일(YYYYMMDD)")
  private String lastPaymentDate;

  @ApiModelProperty(value = "asr no")
  private String asrNo;

  @ApiModelProperty(value = "필터서비스 금액")
  private int filterAmount;

  @ApiModelProperty(value = "부가서비스 금액")
  private int accessoriesAmount;

  @ApiModelProperty(value = "서비스 총 금액")
  private int totalAmount;

  private String serialChk;

  @ApiModelProperty(value = "PSI")
  private String psi;

  @ApiModelProperty(value = "LPM")
  private String lpm;

  @ApiModelProperty(value = "PRODCAT")
  private int prodcat;

  @ApiModelProperty(value = "AS_UNMATCH_REASON")
  private String asUnmatchReason;

  private BigDecimal latitude;

  private BigDecimal longitude;

  @ApiModelProperty(value = "REWORK_PROJ")
  private String reworkProj;

  private String waterSrcType;

  private BigDecimal ntu;

  private String instAccs;

  private String instAccsVal;


  public BigDecimal getNtu() {
	return ntu;
}

public String getInstAccs() {
	return instAccs;
}

public String getInstAccsVal() {
	return instAccsVal;
}

public void setNtu(BigDecimal ntu) {
	this.ntu = ntu;
}

public void setInstAccs(String instAccs) {
	this.instAccs = instAccs;
}

public void setInstAccsVal(String instAccsVal) {
	this.instAccsVal = instAccsVal;
}

public String getWaterSrcType() {
	return waterSrcType;
}

public void setWaterSrcType(String waterSrcType) {
	this.waterSrcType = waterSrcType;
}

public String getReworkProj() {
	return reworkProj;
}

public void setReworkProj(String reworkProj) {
	this.reworkProj = reworkProj;
}


  public String getAsUnmatchReason() {
	return asUnmatchReason;
}

  public void setAsUnmatchReason(String asUnmatchReason) {
	this.asUnmatchReason = asUnmatchReason;
}

  public int getProdcat() {
    return prodcat;
  }

  public void setProdcat(int prodcat) {
    this.prodcat = prodcat;
  }

  public String getPsi() {
    return psi;
  }

  public void setPsi(String psi) {
    this.psi = psi;
  }

  public String getLpm() {
    return lpm;
  }

  public void setLpm(String lpm) {
    this.lpm = lpm;
  }

  public String getSerialChk() {
    return serialChk;
  }

  public void setSerialChk(String serialChk) {
    this.serialChk = serialChk;
  }

  public String getSalesOrderNo() {
    return salesOrderNo;
  }

  public void setSalesOrderNo(String salesOrderNo) {
    this.salesOrderNo = salesOrderNo;
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

  public int getJobStatus() {
    return jobStatus;
  }

  public void setJobStatus(int jobStatus) {
    this.jobStatus = jobStatus;
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

  public int getCustomerType() {
    return customerType;
  }

  public void setCustomerType(int customerType) {
    this.customerType = customerType;
  }

  public int getCustomerId() {
    return customerId;
  }

  public void setCustomerId(int customerId) {
    this.customerId = customerId;
  }

  public String getServiceState() {
    return serviceState;
  }

  public void setServiceState(String serviceState) {
    this.serviceState = serviceState;
  }

  public String getPlanYear() {
    return planYear;
  }

  public void setPlanYear(String planYear) {
    this.planYear = planYear;
  }

  public String getPlanMonth() {
    return planMonth;
  }

  public void setPlanMonth(String planMonth) {
    this.planMonth = planMonth;
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

  public String getAppType() {
    return appType;
  }

  public void setAppType(String appType) {
    this.appType = appType;
  }

  public String getInstruction() {
    return instruction;
  }

  public void setInstruction(String instruction) {
    this.instruction = instruction;
  }

  public String getSalesPromotion() {
    return salesPromotion;
  }

  public void setSalesPromotion(String salesPromotion) {
    this.salesPromotion = salesPromotion;
  }

  public String getRequestor() {
    return requestor;
  }

  public void setRequestor(String requestor) {
    this.requestor = requestor;
  }

  public String getRequestorContact() {
    return requestorContact;
  }

  public void setRequestorContact(String requestorContact) {
    this.requestorContact = requestorContact;
  }

  public int getContractDuration() {
    return contractDuration;
  }

  public void setContractDuration(int contractDuration) {
    this.contractDuration = contractDuration;
  }

  public int getMonthlyRentalFees() {
    return monthlyRentalFees;
  }

  public void setMonthlyRentalFees(int monthlyRentalFees) {
    this.monthlyRentalFees = monthlyRentalFees;
  }

  public int getRegistrationFees() {
    return registrationFees;
  }

  public void setRegistrationFees(int registrationFees) {
    this.registrationFees = registrationFees;
  }

  public String getPaymentMode() {
    return paymentMode;
  }

  public void setPaymentMode(String paymentMode) {
    this.paymentMode = paymentMode;
  }

  public int getBankCode() {
    return bankCode;
  }

  public void setBankCode(int bankCode) {
    this.bankCode = bankCode;
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

  public String getDscCode() {
    return dscCode;
  }

  public void setDscCode(String dscCode) {
    this.dscCode = dscCode;
  }

  public String getInstallationDate() {
    return installationDate;
  }

  public void setInstallationDate(String installationDate) {
    this.installationDate = installationDate;
  }

  public int getLabourCharge() {
    return labourCharge;
  }

  public void setLabourCharge(int labourCharge) {
    this.labourCharge = labourCharge;
  }

  public int getDefectTypeId() {
    return defectTypeId;
  }

  public void setDefectTypeId(int defectTypeId) {
    this.defectTypeId = defectTypeId;
  }

  public int getDefectGroupId() {
    return defectGroupId;
  }

  public void setDefectGroupId(int defectGroupId) {
    this.defectGroupId = defectGroupId;
  }

  public int getDefectId() {
    return defectId;
  }

  public void setDefectId(int defectId) {
    this.defectId = defectId;
  }

  public int getDefectPartGroupId() {
    return defectPartGroupId;
  }

  public void setDefectPartGroupId(int defectPartGroupId) {
    this.defectPartGroupId = defectPartGroupId;
  }

  public int getDefectPartId() {
    return defectPartId;
  }

  public void setDefectPartId(int defectPartId) {
    this.defectPartId = defectPartId;
  }

  public int getDefectDetailReasonId() {
    return defectDetailReasonId;
  }

  public void setDefectDetailReasonId(int defectDetailReasonId) {
    this.defectDetailReasonId = defectDetailReasonId;
  }

  public int getSolutionReasonId() {
    return solutionReasonId;
  }

  public void setSolutionReasonId(int solutionReasonId) {
    this.solutionReasonId = solutionReasonId;
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

  public String getRcCode() {
    return rcCode;
  }

  public void setRcCode(String rcCode) {
    this.rcCode = rcCode;
  }

  public int getMalfunctionCode() {
    return malfunctionCode;
  }

  public void setMalfunctionCode(int malfunctionCode) {
    this.malfunctionCode = malfunctionCode;
  }

  public String getMalfunctionName() {
    return malfunctionName;
  }

  public void setMalfunctionName(String malfunctionName) {
    this.malfunctionName = malfunctionName;
  }

  public int getMalfunctionReasonCode() {
    return malfunctionReasonCode;
  }

  public void setMalfunctionReasonCode(int malfunctionReasonCode) {
    this.malfunctionReasonCode = malfunctionReasonCode;
  }

  public String getMalfunctionReasonName() {
    return malfunctionReasonName;
  }

  public void setMalfunctionReasonName(String malfunctionReasonName) {
    this.malfunctionReasonName = malfunctionReasonName;
  }

  public int getFailReasonCode() {
    return failReasonCode;
  }

  public void setFailReasonCode(int failReasonCode) {
    this.failReasonCode = failReasonCode;
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

  public String getInHouseRepairRemark() {
    return inHouseRepairRemark;
  }

  public void setInHouseRepairRemark(String inHouseRepairRemark) {
    this.inHouseRepairRemark = inHouseRepairRemark;
  }

  public String getInHouseRepairPromisedDate() {
    return inHouseRepairPromisedDate;
  }

  public void setInHouseRepairPromisedDate(String inHouseRepairPromisedDate) {
    this.inHouseRepairPromisedDate = inHouseRepairPromisedDate;
  }

  public String getInHouseRepairProductCode() {
    return inHouseRepairProductCode;
  }

  public void setInHouseRepairProductCode(String inHouseRepairProductCode) {
    this.inHouseRepairProductCode = inHouseRepairProductCode;
  }

  public String getInHouseRepairSerialNo() {
    return inHouseRepairSerialNo;
  }

  public void setInHouseRepairSerialNo(String inHouseRepairSerialNo) {
    this.inHouseRepairSerialNo = inHouseRepairSerialNo;
  }

  public int getRenCollectionId() {
    return renCollectionId;
  }

  public void setRenCollectionId(int renCollectionId) {
    this.renCollectionId = renCollectionId;
  }

  public String getLastPaymentDate() {
    return lastPaymentDate;
  }

  public void setLastPaymentDate(String lastPaymentDate) {
    this.lastPaymentDate = lastPaymentDate;
  }

  public String getAsrNo() {
    return asrNo;
  }

  public void setAsrNo(String asrNo) {
    this.asrNo = asrNo;
  }

  public int getFilterAmount() {
    return filterAmount;
  }

  public void setFilterAmount(int filterAmount) {
    this.filterAmount = filterAmount;
  }

  public int getAccessoriesAmount() {
    return accessoriesAmount;
  }

  public void setAccessoriesAmount(int accessoriesAmount) {
    this.accessoriesAmount = accessoriesAmount;
  }

  public int getTotalAmount() {
    return totalAmount;
  }

  public void setTotalAmount(int totalAmount) {
    this.totalAmount = totalAmount;
  }

  public String getInhouserepairreplacementyn() {
    return inhouserepairreplacementyn;
  }

  public void setInhouserepairreplacementyn(String inhouserepairreplacementyn) {
    this.inhouserepairreplacementyn = inhouserepairreplacementyn;
  }

  public String getInhouserepairproductgroupcode() {
    return inhouserepairproductgroupcode;
  }

  public void setInhouserepairproductgroupcode(String inhouserepairproductgroupcode) {
    this.inhouserepairproductgroupcode = inhouserepairproductgroupcode;
  }

  public String getInhouserepairyn() {
    return inhouserepairyn;
  }

  public void setInhouserepairyn(String inhouserepairyn) {
    this.inhouserepairyn = inhouserepairyn;
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

  public static AfterServiceJobDto create(EgovMap egovMap) {
    return BeanConverter.toBean(egovMap, AfterServiceJobDto.class);
  }

}
