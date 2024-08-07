package com.coway.trust.api.mobile.services.dtProductRetrun;

import java.math.BigDecimal;

import com.coway.trust.api.mobile.services.heartService.HeartServiceJobDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ProductRetrunJobDto", description = "공통코드 Dto")
public class DtProductRetrunJobDto {



	@ApiModelProperty(value = "주문번호")
	private String salesOrderNo;

	@ApiModelProperty(value = "EX_BS00000 / AS00000")
	private String serviceNo;

	@ApiModelProperty(value = "고객명")
	private String custName;

	@ApiModelProperty(value = "AS / HS / INST / PR 구분값")
	private String jobType;

	@ApiModelProperty(value = "ACT / COMPLETE / FAIL / CANCLE 구분")
	private String jobStatus;

	@ApiModelProperty(value = "작업 예정날짜(YYYYMMDD)")
	private String appointmentDate;

	@ApiModelProperty(value = "작업 예정시간(HHMM)")
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
	private String customerId;

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

	@ApiModelProperty(value = "")
	private String instruction;

	@ApiModelProperty(value = "YYYYMMDD")
	private String installationDate;

	@ApiModelProperty(value = "")
	private String installedBy;

	@ApiModelProperty(value = "")
	private String prevOutstanding;

	@ApiModelProperty(value = "")
	private String penaltyCharges;

	@ApiModelProperty(value = "")
	private String unbilledAmount;

	@ApiModelProperty(value = "outstanding 정보")
	private String outstanding;

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
	private String ccCode;

	@ApiModelProperty(value = "")
	private String resultCode;

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
	private String rcCode;

	@ApiModelProperty(value = "실패 사유 코드")
	private String failReasonCode;

	@ApiModelProperty(value = "실패 사유명")
	private String failReasonName;

	@ApiModelProperty(value = "설치자")
	private String settledBy;

	@ApiModelProperty(value = "설치날짜(YYYYMMDD)")
	private String settledDate;

	@ApiModelProperty(value = "설치시간")
	private String settledTime;

	@ApiModelProperty(value = "Return 완료 날짜(YYYYMMDD)")
	private String completeRetDate;

	@ApiModelProperty(value = "Return 완료 시간(HHMM)")
	private String completeRetTime;

	@ApiModelProperty(value = "")
	private String lastPaymentDate;

	@ApiModelProperty(value = "YYYYMMDD")
	private String nextCallDate;

	@ApiModelProperty(value = "HHMM")
	private String nextCallTime;

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

	public String getSerialChk() {
		return serialChk;
	}
	public void setSerialChk(String serialChk) {
		this.serialChk = serialChk;
	}

	private String selSerialNo;
	public String getSelSerialNo() {
		return selSerialNo;
	}
	public void setSelSerialNo(String selSerialNo) {
		this.selSerialNo = selSerialNo;
	}

	private String selFraSerialNo;
	public String getSelFraSerialNo() {
		return selFraSerialNo;
	}
	public void setSelFraSerialNo(String selFraSerialNo) {
		this.selFraSerialNo = selFraSerialNo;
	}

	private String fraSerialChk;
	public String getFraSerialChk() {
		return fraSerialChk;
	}
	public void setFraSerialChk(String fraSerialChk) {
		this.fraSerialChk = fraSerialChk;
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

	public String getJobStatus() {
		return jobStatus;
	}

	public void setJobStatus(String jobStatus) {
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

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
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

	public String getInstallationDate() {
		return installationDate;
	}

	public void setInstallationDate(String installationDate) {
		this.installationDate = installationDate;
	}

	public String getInstalledBy() {
		return installedBy;
	}

	public void setInstalledBy(String installedBy) {
		this.installedBy = installedBy;
	}

	public String getPrevOutstanding() {
		return prevOutstanding;
	}

	public void setPrevOutstanding(String prevOutstanding) {
		this.prevOutstanding = prevOutstanding;
	}

	public String getPenaltyCharges() {
		return penaltyCharges;
	}

	public void setPenaltyCharges(String penaltyCharges) {
		this.penaltyCharges = penaltyCharges;
	}

	public String getUnbilledAmount() {
		return unbilledAmount;
	}

	public void setUnbilledAmount(String unbilledAmount) {
		this.unbilledAmount = unbilledAmount;
	}

	public String getOutstanding() {
		return outstanding;
	}

	public void setOutstanding(String outstanding) {
		this.outstanding = outstanding;
	}

	public String getDscCode() {
		return dscCode;
	}

	public void setDscCode(String dscCode) {
		this.dscCode = dscCode;
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

	public String getHpName() {
		return hpName;
	}

	public void setHpName(String hpName) {
		this.hpName = hpName;
	}

	public String getHpTel() {
		return hpTel;
	}

	public void setHpTel(String hpTel) {
		this.hpTel = hpTel;
	}

	public String getSmName() {
		return smName;
	}

	public void setSmName(String smName) {
		this.smName = smName;
	}

	public String getSmTel() {
		return smTel;
	}

	public void setSmTel(String smTel) {
		this.smTel = smTel;
	}

	public String getHmName() {
		return hmName;
	}

	public void setHmName(String hmName) {
		this.hmName = hmName;
	}

	public String getHmTel() {
		return hmTel;
	}

	public void setHmTel(String hmTel) {
		this.hmTel = hmTel;
	}

	public String getCcCode() {
		return ccCode;
	}

	public void setCcCode(String ccCode) {
		this.ccCode = ccCode;
	}

	public String getResultCode() {
		return resultCode;
	}

	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
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

	public String getFailReasonCode() {
		return failReasonCode;
	}

	public void setFailReasonCode(String failReasonCode) {
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

	public String getCompleteRetDate() {
		return completeRetDate;
	}

	public void setCompleteRetDate(String completeRetDate) {
		this.completeRetDate = completeRetDate;
	}

	public String getCompleteRetTime() {
		return completeRetTime;
	}

	public void setCompleteRetTime(String completeRetTime) {
		this.completeRetTime = completeRetTime;
	}

	public String getLastPaymentDate() {
		return lastPaymentDate;
	}

	public void setLastPaymentDate(String lastPaymentDate) {
		this.lastPaymentDate = lastPaymentDate;
	}

	public String getNextCallDate() {
		return nextCallDate;
	}

	public void setNextCallDate(String nextCallDate) {
		this.nextCallDate = nextCallDate;
	}

	public String getNextCallTime() {
		return nextCallTime;
	}

	public void setNextCallTime(String nextCallTime) {
		this.nextCallTime = nextCallTime;
	}

	public String getFraYn() {
		return fraYn;
	}

	public void setFraYn(String fraYn) {
		this.fraYn = fraYn;
	}

	public String getFraOrdNo() {
		return fraOrdNo;
	}

	public void setFraOrdNo(String fraOrdNo) {
		this.fraOrdNo = fraOrdNo;
	}

	public String getFraProductCode() {
		return fraProductCode;
	}

	public void setFraProductCode(String fraProductCode) {
		this.fraProductCode = fraProductCode;
	}

	public String getFraProductName() {
		return fraProductName;
	}

	public void setFraProductName(String fraProductName) {
		this.fraProductName = fraProductName;
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

	public static DtProductRetrunJobDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, DtProductRetrunJobDto.class);
	}

}
