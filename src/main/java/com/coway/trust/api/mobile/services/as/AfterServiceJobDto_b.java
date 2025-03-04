package com.coway.trust.api.mobile.services.as;

import java.math.BigDecimal;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceJobDto_b", description = "공통코드 Dto")
public class AfterServiceJobDto_b {

  @ApiModelProperty(value = "SALES ORDER NO")
  private String salesOrderNo;

  @ApiModelProperty(value = "AS NO")
  private String serviceNo;

  @ApiModelProperty(value = "CUSTOMER NAME")
  private String custName;

  @ApiModelProperty(value = "AS / HS / INST / PR ")
  private String jobType;

  @ApiModelProperty(value = "ACT / COMPLETE / FAIL / CANCEL ")
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

  @ApiModelProperty(value = "SERVICE STATE")
  private String serviceState;

  @ApiModelProperty(value = "YEAR")
  private String planYear;

  @ApiModelProperty(value = "MONTH")
  private String planMonth;

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

  @ApiModelProperty(value = "EMAIL ADDRESS")
  private String mailAddress;

  @ApiModelProperty(value = "CUSTOMER VA NO")
  private String customerVaNo;

  @ApiModelProperty(value = "JOM PAY REFERENCE NO")
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

  @ApiModelProperty(value = "REQUESTOR")
  private String requestor;

  @ApiModelProperty(value = "REQUEST CONTACT")
  private String requestorContact;

  @ApiModelProperty(value = "ORDER CONTRACT DURATION")
  private String contractDuration;

  @ApiModelProperty(value = "ORDER MONTLY RENTAL FEES")
  private String monthlyRentalFees;

  @ApiModelProperty(value = "ORDER REGISTRATION FEES")
  private String registrationFees;

  @ApiModelProperty(value = "PAYMENT MODE")
  private String paymentMode;

  @ApiModelProperty(value = "BANK CODE")
  private String bankCode;

  @ApiModelProperty(value = "BANK NAME")
  private String bankName;

  @ApiModelProperty(value = "CARD ACCOUNT NO")
  private String cardAccountNo;

  @ApiModelProperty(value = "OUTSTANDING")
  private String outstanding;

  @ApiModelProperty(value = "SIRIM")
  private String sirimNo;

  @ApiModelProperty(value = "SERIAL")
  private String serialNo;

  @ApiModelProperty(value = "WARRANTY")
  private String warranty;

  @ApiModelProperty(value = "MEMBERSHIP CONTRACT EXPIRY")
  private String MembershipContractExpiry;

  @ApiModelProperty(value = "RENTAL STATUS")
  private String rentalStatus;

  @ApiModelProperty(value = "DSC CODE")
  private String dscCode;

  @ApiModelProperty(value = "INSTALLATION DATE")
  private String installationDate;

  @ApiModelProperty(value = "LABOUR CHARGE")
  private String labourCharge;

  @ApiModelProperty(value = "DEFECT TYPE ID")
  private String defectTypeId;

  @ApiModelProperty(value = "DEFECT GROUP ID")
  private String defectGroupId;

  @ApiModelProperty(value = "DEFECT ID")
  private String defectId;

  @ApiModelProperty(value = "DEFECT PART GROUP ID")
  private String defectPartGroupId;

  @ApiModelProperty(value = "DEFECT PART ID")
  private String defectPartId;

  @ApiModelProperty(value = "DEFECT DETAIL REASON ID")
  private String defectDetailReasonId;

  @ApiModelProperty(value = "SOLUTION REASON ID")
  private String solutionReasonId;

  @ApiModelProperty(value = "RESULT REMARK")
  private String resultRemark;

  @ApiModelProperty(value = "OWNER CODE")
  private String ownerCode;

  @ApiModelProperty(value = "OWNER CODE NAME")
  private String ownerCodeNm;

  @ApiModelProperty(value = "RESULT CUSTOMER NAME")
  private String resultCustName;

  @ApiModelProperty(value = "RESULT MOBILE NO")
  private String resultIcMobileNo;

  @ApiModelProperty(value = "RESULT EMAIL")
  private String resultReportEmailNo;

  @ApiModelProperty(value = "RESULT ACCEPTANCE NAME")
  private String resultAcceptanceName;

  @ApiModelProperty(value = "RC CODE")
  private String rcCode;

  @ApiModelProperty(value = "MALFUNCTION CODE")
  private String malfunctionCode;

  @ApiModelProperty(value = "MALFUNCTION NAME")
  private String malfunctionName;

  @ApiModelProperty(value = "MALFUNCTION REASON CODE")
  private String malfunctionReasonCode;

  @ApiModelProperty(value = "MALFUNCTION REASON NAME")
  private String malfunctionReasonName;

  @ApiModelProperty(value = "FAIL REASON CODE")
  private String failReasonCode;

  @ApiModelProperty(value = "FAIL REASON NAME")
  private String failReasonName;

  @ApiModelProperty(value = "SETTLED BY")
  private String settledBy;

  @ApiModelProperty(value = "SETTLED DATE")
  private String settledDate;

  @ApiModelProperty(value = "SETTLED TIME")
  private String settledTime;

  @ApiModelProperty(value = "IN HOUSE REPAIR REMARK")
  private String inHouseRepairRemark;

  @ApiModelProperty(value = "IN HOUSE REPAIR REPLACEMENT INDICATOR")
  private String inhouserepairreplacementyn;

  @ApiModelProperty(value = "IN HOUSE REPAIR PROMISED DATE")
  private String inHouseRepairPromisedDate;

  @ApiModelProperty(value = "IN HOUSE REPAIR PRODUCT GROUP CODE")
  private String inhouserepairproductgroupcode;

  @ApiModelProperty(value = "IN HOUSE REPAIR PRODUCT CODE")
  private String inHouseRepairProductCode;

  @ApiModelProperty(value = "IN HOUSE REPAIR SERIAL NO")
  private String inHouseRepairSerialNo;

  @ApiModelProperty(value = "IN HOUSE REPAIR INDICATOR")
  private String inhouserepairyn;

  @ApiModelProperty(value = "RENTAL COLLECTION TARGET ID")
  private String renCollectionId;

  @ApiModelProperty(value = "LAST PAYMENT DATE")
  private String lastPaymentDate;

  @ApiModelProperty(value = "AS RESULT NO")
  private String asrNo;

  @ApiModelProperty(value = "FILTER AMOUNT")
  private String filterAmount;

  @ApiModelProperty(value = "ACCESSORIES AMOUNT")
  private String accessoriesAmount;

  @ApiModelProperty(value = "TOTAL AMOUNT")
  private String totalAmount;

  @ApiModelProperty(value = "PSI")
  private String psi;

  @ApiModelProperty(value = "LPM")
  private String lpm;

  @ApiModelProperty(value = "PRODUCT CATEGORY")
  private int prodcat;

  @ApiModelProperty(value = "AS UNMATCH REASON")
  private String asUnmatchReason;

  @ApiModelProperty(value = "LATITUDE")
  private BigDecimal latitude;

  @ApiModelProperty(value = "LONGTIDE")
  private BigDecimal longitude;

  @ApiModelProperty(value = "REWORK PROJECT")
  private String reworkProj;

  @ApiModelProperty(value = "WATER SOURCE TYPE")
  private String waterSrcType;

  @ApiModelProperty(value = "NTU")
  private int ntu;

  @ApiModelProperty(value = "INSTALLATION ACCESSORIES")
  private String instAccs;

  @ApiModelProperty(value = "INSTALLATION ACCESSORIES VALUE")
  private String instAccsVal;

  @ApiModelProperty(value = "SERVICE TYPE")
  private String srvType;

  @ApiModelProperty(value = "VOLTAGE")
  private String voltage;

  @ApiModelProperty(value = "PARTNER CODE")
  private String partnerCode;

  @ApiModelProperty(value = "PARTNER CODE NAME")
  private String partnerCodeName;

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

  public String getSalesPromotion() {
    return salesPromotion;
  }

  public void setSalesPromotion( String salesPromotion ) {
    this.salesPromotion = salesPromotion;
  }

  public String getRequestor() {
    return requestor;
  }

  public void setRequestor( String requestor ) {
    this.requestor = requestor;
  }

  public String getRequestorContact() {
    return requestorContact;
  }

  public void setRequestorContact( String requestorContact ) {
    this.requestorContact = requestorContact;
  }

  public String getContractDuration() {
    return contractDuration;
  }

  public void setContractDuration( String contractDuration ) {
    this.contractDuration = contractDuration;
  }

  public String getMonthlyRentalFees() {
    return monthlyRentalFees;
  }

  public void setMonthlyRentalFees( String monthlyRentalFees ) {
    this.monthlyRentalFees = monthlyRentalFees;
  }

  public String getRegistrationFees() {
    return registrationFees;
  }

  public void setRegistrationFees( String registrationFees ) {
    this.registrationFees = registrationFees;
  }

  public String getPaymentMode() {
    return paymentMode;
  }

  public void setPaymentMode( String paymentMode ) {
    this.paymentMode = paymentMode;
  }

  public String getBankCode() {
    return bankCode;
  }

  public void setBankCode( String bankCode ) {
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

  public String getWarranty() {
    return warranty;
  }

  public void setWarranty( String warranty ) {
    this.warranty = warranty;
  }

  public String getMembershipContractExpiry() {
    return MembershipContractExpiry;
  }

  public void setMembershipContractExpiry( String membershipContractExpiry ) {
    MembershipContractExpiry = membershipContractExpiry;
  }

  public String getRentalStatus() {
    return rentalStatus;
  }

  public void setRentalStatus( String rentalStatus ) {
    this.rentalStatus = rentalStatus;
  }

  public String getDscCode() {
    return dscCode;
  }

  public void setDscCode( String dscCode ) {
    this.dscCode = dscCode;
  }

  public String getInstallationDate() {
    return installationDate;
  }

  public void setInstallationDate( String installationDate ) {
    this.installationDate = installationDate;
  }

  public String getLabourCharge() {
    return labourCharge;
  }

  public void setLabourCharge( String labourCharge ) {
    this.labourCharge = labourCharge;
  }

  public String getDefectTypeId() {
    return defectTypeId;
  }

  public void setDefectTypeId( String defectTypeId ) {
    this.defectTypeId = defectTypeId;
  }

  public String getDefectGroupId() {
    return defectGroupId;
  }

  public void setDefectGroupId( String defectGroupId ) {
    this.defectGroupId = defectGroupId;
  }

  public String getDefectId() {
    return defectId;
  }

  public void setDefectId( String defectId ) {
    this.defectId = defectId;
  }

  public String getDefectPartGroupId() {
    return defectPartGroupId;
  }

  public void setDefectPartGroupId( String defectPartGroupId ) {
    this.defectPartGroupId = defectPartGroupId;
  }

  public String getDefectPartId() {
    return defectPartId;
  }

  public void setDefectPartId( String defectPartId ) {
    this.defectPartId = defectPartId;
  }

  public String getDefectDetailReasonId() {
    return defectDetailReasonId;
  }

  public void setDefectDetailReasonId( String defectDetailReasonId ) {
    this.defectDetailReasonId = defectDetailReasonId;
  }

  public String getSolutionReasonId() {
    return solutionReasonId;
  }

  public void setSolutionReasonId( String solutionReasonId ) {
    this.solutionReasonId = solutionReasonId;
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

  public String getMalfunctionCode() {
    return malfunctionCode;
  }

  public void setMalfunctionCode( String malfunctionCode ) {
    this.malfunctionCode = malfunctionCode;
  }

  public String getMalfunctionName() {
    return malfunctionName;
  }

  public void setMalfunctionName( String malfunctionName ) {
    this.malfunctionName = malfunctionName;
  }

  public String getMalfunctionReasonCode() {
    return malfunctionReasonCode;
  }

  public void setMalfunctionReasonCode( String malfunctionReasonCode ) {
    this.malfunctionReasonCode = malfunctionReasonCode;
  }

  public String getMalfunctionReasonName() {
    return malfunctionReasonName;
  }

  public void setMalfunctionReasonName( String malfunctionReasonName ) {
    this.malfunctionReasonName = malfunctionReasonName;
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

  public String getInHouseRepairRemark() {
    return inHouseRepairRemark;
  }

  public void setInHouseRepairRemark( String inHouseRepairRemark ) {
    this.inHouseRepairRemark = inHouseRepairRemark;
  }

  public String getInhouserepairreplacementyn() {
    return inhouserepairreplacementyn;
  }

  public void setInhouserepairreplacementyn( String inhouserepairreplacementyn ) {
    this.inhouserepairreplacementyn = inhouserepairreplacementyn;
  }

  public String getInHouseRepairPromisedDate() {
    return inHouseRepairPromisedDate;
  }

  public void setInHouseRepairPromisedDate( String inHouseRepairPromisedDate ) {
    this.inHouseRepairPromisedDate = inHouseRepairPromisedDate;
  }

  public String getInhouserepairproductgroupcode() {
    return inhouserepairproductgroupcode;
  }

  public void setInhouserepairproductgroupcode( String inhouserepairproductgroupcode ) {
    this.inhouserepairproductgroupcode = inhouserepairproductgroupcode;
  }

  public String getInHouseRepairProductCode() {
    return inHouseRepairProductCode;
  }

  public void setInHouseRepairProductCode( String inHouseRepairProductCode ) {
    this.inHouseRepairProductCode = inHouseRepairProductCode;
  }

  public String getInHouseRepairSerialNo() {
    return inHouseRepairSerialNo;
  }

  public void setInHouseRepairSerialNo( String inHouseRepairSerialNo ) {
    this.inHouseRepairSerialNo = inHouseRepairSerialNo;
  }

  public String getInhouserepairyn() {
    return inhouserepairyn;
  }

  public void setInhouserepairyn( String inhouserepairyn ) {
    this.inhouserepairyn = inhouserepairyn;
  }

  public String getRenCollectionId() {
    return renCollectionId;
  }

  public void setRenCollectionId( String renCollectionId ) {
    this.renCollectionId = renCollectionId;
  }

  public String getLastPaymentDate() {
    return lastPaymentDate;
  }

  public void setLastPaymentDate( String lastPaymentDate ) {
    this.lastPaymentDate = lastPaymentDate;
  }

  public String getAsrNo() {
    return asrNo;
  }

  public void setAsrNo( String asrNo ) {
    this.asrNo = asrNo;
  }

  public String getFilterAmount() {
    return filterAmount;
  }

  public void setFilterAmount( String filterAmount ) {
    this.filterAmount = filterAmount;
  }

  public String getAccessoriesAmount() {
    return accessoriesAmount;
  }

  public void setAccessoriesAmount( String accessoriesAmount ) {
    this.accessoriesAmount = accessoriesAmount;
  }

  public String getTotalAmount() {
    return totalAmount;
  }

  public void setTotalAmount( String totalAmount ) {
    this.totalAmount = totalAmount;
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

  public int getProdcat() {
    return prodcat;
  }

  public void setProdcat( int prodcat ) {
    this.prodcat = prodcat;
  }

  public String getAsUnmatchReason() {
    return asUnmatchReason;
  }

  public void setAsUnmatchReason( String asUnmatchReason ) {
    this.asUnmatchReason = asUnmatchReason;
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

  public String getReworkProj() {
    return reworkProj;
  }

  public void setReworkProj( String reworkProj ) {
    this.reworkProj = reworkProj;
  }

  public String getWaterSrcType() {
    return waterSrcType;
  }

  public void setWaterSrcType( String waterSrcType ) {
    this.waterSrcType = waterSrcType;
  }

  public int getNtu() {
    return ntu;
  }

  public void setNtu( int ntu ) {
    this.ntu = ntu;
  }

  public String getInstAccs() {
    return instAccs;
  }

  public void setInstAccs( String instAccs ) {
    this.instAccs = instAccs;
  }

  public String getInstAccsVal() {
    return instAccsVal;
  }

  public void setInstAccsVal( String instAccsVal ) {
    this.instAccsVal = instAccsVal;
  }

  public String getSrvType() {
    return srvType;
  }

  public void setSrvType( String srvType ) {
    this.srvType = srvType;
  }

  public String getVoltage() {
    return voltage;
  }

  public void setVoltage( String voltage ) {
    this.voltage = voltage;
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

  @SuppressWarnings("unchecked")
  public static AfterServiceJobDto_b create( EgovMap egovMap ) {
    return BeanConverter.toBean( egovMap, AfterServiceJobDto_b.class );
  }
}
