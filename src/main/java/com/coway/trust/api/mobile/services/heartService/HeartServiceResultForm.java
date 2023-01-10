package com.coway.trust.api.mobile.services.heartService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.api.mobile.services.as.AfterServiceResultDetailForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;
//import com.coway.trust.api.mobile.common.MalfunctionCodeForm;
import com.coway.trust.util.BeanConverter;
import com.crystaldecisions.Utilities.Logger;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT --------------------------------------------------------------------------------------------
 * 10/04/2019 ONGHC 1.0.1 - Amend File Format
 * 13/08/2019 ONGHC 1.0.2 - Add Variable faucetExch
 * 29/04/2020 ONGHC 1.0.3 - Add Variable scanSerial2
 * 28/05/2020 ONGHC 1.0.4 - Add Variable disinfecServ
 * 25/09/2020 ALEX 	1.0.5 - Add Variable hsChkLst
 *********************************************************************************************/

@ApiModel(value = "HeartServiceResultForm", description = "HeartServiceResultForm")
@JsonIgnoreProperties(ignoreUnknown = true)
public class HeartServiceResultForm {

	@ApiModelProperty(value = "사용자 ID (예_CT123456)")
	private String userId;

	@ApiModelProperty(value = "주문번호")
	private String salesOrderNo;

	@ApiModelProperty(value = "EX_BS00000 / AS00000")
	private String serviceNo;

	@ApiModelProperty(value = "Y/ N")
	private String temperatureSetting;

	@ApiModelProperty(value = "0/ 1")
	private String faucetExch;

	@ApiModelProperty(value = "결과 등록 메모")
	private String resultRemark;

	@ApiModelProperty(value = "다음 작업 날짜(YYYYMMDD)")
	private String nextAppointmentDate;

	@ApiModelProperty(value = "다음 작업 시간(HHMM)")
	private String nextAppointmentTime;

	@ApiModelProperty(value = "결과 등록시, Owner Code")
	private int ownerCode;

	@ApiModelProperty(value = "결과 등록시, Cust Name")
	private String resultCustName;

	@ApiModelProperty(value = "결과 등록시, NrIc 또는 Mobile No")
	private String resultIcMobileNo;

	@ApiModelProperty(value = "결과 등록시, Email_No")
	private String resultReportEmailNo;

	@ApiModelProperty(value = "결과 등록시, Acceptance Name")
	private String resultAcceptanceName;

	@ApiModelProperty(value = "")
	private int rcCode;

	@ApiModelProperty(value = "base64 Data")
	private String signData;

	@ApiModelProperty(value = "")
	private String signRegDate;

	@ApiModelProperty(value = "")
	private String signRegTime;

	@ApiModelProperty(value = "Transaction ID 값(체계 : USER_ID + SALES_ORDER_NO + SERVICE_NO + 현재시간_YYYYMMDDHHMMSS)")
	private String transactionId;

	private String checkInDate;
	private String checkInTime;
	private String checkInGps;

	private String scanSerial;
	private String homeCareOrderYn;

	private String serialRequireChkYn;

	private String scanSerial2;

	private String disinfecServ;

	private String hsChkLst;
	private String instruction;

	private String codeFailRemark;
	private String voucherRedemption;

	private String switchChkLst;

	//20220826: Celeste : Edit Customer Info [s]
	private String newHandphoneTel;
	private String newHomeTel;
	private String newOfficeTel;
	private String newEmail;
	private String resultIcHomeNo;
	private String resultIcOfficeNo;
	//20220826: Celeste : Edit Customer Info [e]

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

	@ApiModelProperty(value = "heartDtails")
	private List<HeartServiceResultDetailForm> heartDtails;

	public String getSignRegDate() {
		return signRegDate;
	}

	public void setSignRegDate(String signRegDate) {
		this.signRegDate = signRegDate;
	}

	public String getSignRegTime() {
		return signRegTime;
	}

	public void setSignRegTime(String signRegTime) {
		this.signRegTime = signRegTime;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
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

	public String getTemperatureSetting() {
		return temperatureSetting;
	}

	public void setTemperatureSetting(String temperatureSetting) {
		this.temperatureSetting = temperatureSetting;
	}

	public String getFaucetExch() {
		return faucetExch;
	}

	public void setFaucetExch(String faucetExch) {
		this.faucetExch = faucetExch;
	}

	public String getResultRemark() {
		return resultRemark;
	}

	public void setResultRemark(String resultRemark) {
		this.resultRemark = resultRemark;
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

	public int getOwnerCode() {
		return ownerCode;
	}

	public void setOwnerCode(int ownerCode) {
		this.ownerCode = ownerCode;
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

	public int getRcCode() {
		return rcCode;
	}

	public void setRcCode(int rcCode) {
		this.rcCode = rcCode;
	}

	public String getSignData() {
		return signData;
	}

	public void setSignData(String signData) {
		this.signData = signData;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	public List<HeartServiceResultDetailForm> getHeartDtails() {
		return heartDtails;
	}

	public void setHeartDtails(List<HeartServiceResultDetailForm> heartDtails) {
		this.heartDtails = heartDtails;
	}

	public String getScanSerial() {
		return scanSerial;
	}

	public void setScanSerial(String scanSerial) {
		this.scanSerial = scanSerial;
	}

	public String getHomeCareOrderYn() {
		return homeCareOrderYn;
	}

	public void setHomeCareOrderYn(String homeCareOrderYn) {
		this.homeCareOrderYn = homeCareOrderYn;
	}

	public String getSerialRequireChkYn() {
		return serialRequireChkYn;
	}

	public void setSerialRequireChkYn(String serialRequireChkYn) {
		this.serialRequireChkYn = serialRequireChkYn;
	}

	public String getScanSerial2() {
		return scanSerial2;
	}

	public void setScanSerial2(String scanSerial2) {
		this.scanSerial2 = scanSerial2;
	}

	public String getDisinfecServ() {
		return disinfecServ;
	}

	public void setDisinfecServ(String disinfecServ) {
		this.disinfecServ = disinfecServ;
	}

	public String getHsChkLst() {
		return hsChkLst;
	}

	public void setHsChkLst(String hsChkLst) {
		this.hsChkLst = hsChkLst;
	}

	public String getCodeFailRemark() {
		return codeFailRemark;
	}

	public void setCodeFailRemark(String codeFailRemark) {
		this.codeFailRemark = codeFailRemark;
	}

	public String getVoucherRedemption() {
		return voucherRedemption;
	}

	public void setVoucherRedemption(String voucherRedemption) {
		this.voucherRedemption = voucherRedemption;
	}

	public String getInstruction() {
		return instruction;
	}

	public void setInstruction(String instruction) {
		this.instruction = instruction;
	}

	public String getSwitchChkLst() {
		return switchChkLst;
	}

	public void setSwitchChkLst(String switchChkLst) {
		this.switchChkLst = switchChkLst;
	}

	public List<Map<String, Object>> createMaps(HeartServiceResultForm heartServiceResultForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (heartDtails != null && heartDtails.size() > 0) {
			Map<String, Object> map = new HashMap();
			for (HeartServiceResultDetailForm dtl : heartDtails) {
				map = BeanConverter.toMap(heartServiceResultForm, "signData", "heartDtails");
				map.put("signData", Base64.decodeBase64(heartServiceResultForm.getSignData()));

				// heartDtails
				map.put("filterCode", dtl.getFilterCode());
				map.put("exchangeId", dtl.getExchangeId());
				map.put("filterChangeQty", dtl.getFilterChangeQty());
				map.put("alternativeFilterCode", dtl.getAlternativeFilterCode());
				map.put("filterBarcdSerialNo", dtl.getFilterBarcdSerialNo());
				map.put("filterBarcdNewSerialNo", dtl.getFilterBarcdNewSerialNo());
				map.put("filterSerialUnmatchReason", dtl.getFilterSerialUnmatchReason());
				map.put("sysFilterBarcdSerialNo", dtl.getSysFilterBarcdSerialNo());


			}
			list.add(map);
		}
		return list;
	}

	public List<Map<String, Object>> createMaps1(HeartServiceResultForm heartServiceResultForm) {

		List<Map<String, Object>> list = new ArrayList<>();

		if (heartDtails != null && heartDtails.size() > 0) {
			Map<String, Object> map;
			map = BeanConverter.toMap(heartServiceResultForm, "signData");
			map.put("signData", Base64.decodeBase64(heartServiceResultForm.getSignData()));

			for (HeartServiceResultDetailForm obj : heartDtails) {
				map.put("filterCode", obj.getFilterCode());
				map.put("exchangeId", obj.getExchangeId());
				map.put("filterChangeQty", obj.getFilterChangeQty());
				map.put("filterBarcdSerialNo", obj.getFilterBarcdSerialNo());
				map.put("filterBarcdNewSerialNo", obj.getFilterBarcdNewSerialNo());
				map.put("filterSerialUnmatchReason", obj.getFilterSerialUnmatchReason());
				map.put("sysFilterBarcdSerialNo", obj.getSysFilterBarcdSerialNo());


			}
			list.add(map);
		}

		return list;
	}

	public String getNewHandphoneTel() {
		return newHandphoneTel;
	}

	public void setNewHandphoneTel(String newHandphoneTel) {
		this.newHandphoneTel = newHandphoneTel;
	}

	public String getNewEmail() {
		return newEmail;
	}

	public void setNewEmail(String newEmail) {
		this.newEmail = newEmail;
	}

	public String getNewHomeTel() {
		return newHomeTel;
	}

	public void setNewHomeTel(String newHomeTel) {
		this.newHomeTel = newHomeTel;
	}

	public String getNewOfficeTel() {
		return newOfficeTel;
	}

	public void setNewOfficeTel(String newOfficeTel) {
		this.newOfficeTel = newOfficeTel;
	}

	public String getResultIcHomeNo() {
		return resultIcHomeNo;
	}

	public void setResultIcHomeNo(String resultIcHomeNo) {
		this.resultIcHomeNo = resultIcHomeNo;
	}

	public String getResultIcOfficeNo() {
		return resultIcOfficeNo;
	}

	public void setResultIcOfficeNo(String resultIcOfficeNo) {
		this.resultIcOfficeNo = resultIcOfficeNo;
	}
}
