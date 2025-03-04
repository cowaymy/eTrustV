package com.coway.trust.api.mobile.services.installation;

import java.util.ArrayList;
import org.apache.commons.codec.binary.Base64;
import java.util.List;
import java.util.Map;
// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class InstallationResultForm {
  // private static final Logger LOGGER = LoggerFactory.getLogger( InstallationResultForm.class );
  @ApiModelProperty(value = "installAccList")
  private List<InstallationResultDetailForm> installAccList;

  @ApiModelProperty(value = "partList")
  private List<InstallationResultDetailForm> partList;

  @ApiModelProperty(value = "USER ID")
  private String userId;

  @ApiModelProperty(value = "SALES ORDER NO")
  private int salesOrderNo;

  @ApiModelProperty(value = "INSTALLATION NO")
  private String serviceNo;

  @ApiModelProperty(value = "PRODUCT SIRIM NO")
  private String sirimNo;

  @ApiModelProperty(value = "PRODUCT SERIAL NO")
  private String serialNo;

  @ApiModelProperty(value = "AS EXCHANGE INDICATOR")
  private String asExchangeYN;

  @ApiModelProperty(value = "BEFORE PRODUCT SERIAL NO")
  private String beforeProductSerialNo;

  @ApiModelProperty(value = "RESULT REMARK")
  private String resultRemark;

  @ApiModelProperty(value = "OWNER CODE")
  private int ownerCode;

  @ApiModelProperty(value = "RESULT CUSTOMER NAME")
  private String resultCustName;

  @ApiModelProperty(value = "RESULT MOBILE NO")
  private String resultIcMobileNo;

  @ApiModelProperty(value = "RESULT EMAIL ADDRESS")
  private String resultReportEmailNo;

  @ApiModelProperty(value = "REUSLT ACCEPTANCE NAME")
  private String resultAcceptanceName;

  @ApiModelProperty(value = "BASE 64 SIGNATURE")
  private String signData;

  @ApiModelProperty(value = "TRANSACTION")
  private String transactionId;

  @ApiModelProperty(value = "SIGNATURE REGISTER DATE")
  private String signRegDate;

  @ApiModelProperty(value = "SIGNATURE REGISTER TIME")
  private String signRegTime;

  @ApiModelProperty(value = "CHECK IN DATE")
  private String checkInDate;

  @ApiModelProperty(value = "CHECK IN TIME")
  private String checkInTime;

  @ApiModelProperty(value = "CHECK IN GPS")
  private String checkInGps;

  @ApiModelProperty(value = "SCAN SERIAL INDICATOR")
  private String scanSerial;

  @ApiModelProperty(value = "FRAME SERIAL NO")
  private String fraSerialNo;

  @ApiModelProperty(value = "REQUIRE SERIAL CHECK INDICATOR")
  private String serialRequireChkYn;

  @ApiModelProperty(value = "PSI")
  private String psiRcd;

  @ApiModelProperty(value = "LPM")
  private String lpmRcd;

  @ApiModelProperty(value = "VOLTAGE")
  private String volt;

  @ApiModelProperty(value = "TDS")
  private String tds;

  @ApiModelProperty(value = "ROOM TEMP")
  private String roomTemp;

  @ApiModelProperty(value = "WATER SOURCE TEMP")
  private String waterSourceTemp;

  @ApiModelProperty(value = "USED ADAPTER")
  private String adptUsed;

  @ApiModelProperty(value = "INSTALLATION CHECK LIST INDICATOR")
  private String instChklstCheckBox;

  @ApiModelProperty(value = "INSTALLATION AGGREMENT CHECK LIST INDICATOR")
  private String instNoteChk;

  @ApiModelProperty(value = "BOOSTER PUMP")
  private String boosterPump;

  @ApiModelProperty(value = "AFTER PSI")
  private String aftPsi;

  @ApiModelProperty(value = "AFTER LPM")
  private String aftLpm;

  @ApiModelProperty(value = "TURBITY LEVEL")
  private String turbLvl;

  @ApiModelProperty(value = "NTU")
  private String ntu;

  @ApiModelProperty(value = "COMPETITOR")
  private String competitor;

  @ApiModelProperty(value = "COMPETITOR BRAND")
  private String competitorBrand;

  @ApiModelProperty(value = "WATER SOURCE TYPE")
  private String waterSrcType;

  @ApiModelProperty(value = "CREATE AS INDICATOR")
  private String chkCrtAs;

  @ApiModelProperty(value = "CHECK SMS INDICATOR")
  private String chkSms;

  @ApiModelProperty(value = "SEND INDICATOR")
  private String checkSend;

  @ApiModelProperty(value = "CUSTOMER MOBILE NO")
  private String custMobileNo;

  @ApiModelProperty(value = "CUSTOMER TYPE")
  private String customerType;

  @ApiModelProperty(value = "PARTNER CODE")
  private String partnerCode;

  @ApiModelProperty(value = "PARTNER NAME")
  private String memCode;

  @ApiModelProperty(value = "TYPE")
  private String type;

  @ApiModelProperty(value = "INSTALLATION ACCESSERIES PART ID")
  private int insAccPartId;

  @ApiModelProperty(value = "INSTALLATION ACCESSERIES INDICATOR")
  private String chkInstallAcc;

  @ApiModelProperty(value = "DISPOSAL COMMISSION INDICATOR")
  private String dispComm;

  @ApiModelProperty(value = "SERIAL CHECK INDICATOR")
  private String serialChk;

  @ApiModelProperty(value = "REAL AS EXCHANGE INDICATOR")
  private String realAsExchangeYn;

  @ApiModelProperty(value = "REAL BEFORE PRODUCT CODE")
  private String realBeforeProductCode;

  @ApiModelProperty(value = "REAL BEFORE PRODUCT NAME")
  private String realBeforeProductName;

  @ApiModelProperty(value = "REAL BEFORE PRODUCT SERIAL NO")
  private String realBeforeProductSerialNo;

  public List<InstallationResultDetailForm> getInstallAccList() {
    return installAccList;
  }

  public void setInstallAccList( List<InstallationResultDetailForm> installAccList ) {
    this.installAccList = installAccList;
  }

  public List<InstallationResultDetailForm> getPartList() {
    return partList;
  }

  public void setPartList( List<InstallationResultDetailForm> partList ) {
    this.partList = partList;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId( String userId ) {
    this.userId = userId;
  }

  public int getSalesOrderNo() {
    return salesOrderNo;
  }

  public void setSalesOrderNo( int salesOrderNo ) {
    this.salesOrderNo = salesOrderNo;
  }

  public String getServiceNo() {
    return serviceNo;
  }

  public void setServiceNo( String serviceNo ) {
    this.serviceNo = serviceNo;
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

  public String getAsExchangeYN() {
    return asExchangeYN;
  }

  public void setAsExchangeYN( String asExchangeYN ) {
    this.asExchangeYN = asExchangeYN;
  }

  public String getBeforeProductSerialNo() {
    return beforeProductSerialNo;
  }

  public void setBeforeProductSerialNo( String beforeProductSerialNo ) {
    this.beforeProductSerialNo = beforeProductSerialNo;
  }

  public String getResultRemark() {
    return resultRemark;
  }

  public void setResultRemark( String resultRemark ) {
    this.resultRemark = resultRemark;
  }

  public int getOwnerCode() {
    return ownerCode;
  }

  public void setOwnerCode( int ownerCode ) {
    this.ownerCode = ownerCode;
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

  public String getSignData() {
    return signData;
  }

  public void setSignData( String signData ) {
    this.signData = signData;
  }

  public String getTransactionId() {
    return transactionId;
  }

  public void setTransactionId( String transactionId ) {
    this.transactionId = transactionId;
  }

  public String getSignRegDate() {
    return signRegDate;
  }

  public void setSignRegDate( String signRegDate ) {
    this.signRegDate = signRegDate;
  }

  public String getSignRegTime() {
    return signRegTime;
  }

  public void setSignRegTime( String signRegTime ) {
    this.signRegTime = signRegTime;
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

  public String getScanSerial() {
    return scanSerial;
  }

  public void setScanSerial( String scanSerial ) {
    this.scanSerial = scanSerial;
  }

  public String getFraSerialNo() {
    return fraSerialNo;
  }

  public void setFraSerialNo( String fraSerialNo ) {
    this.fraSerialNo = fraSerialNo;
  }

  public String getSerialRequireChkYn() {
    return serialRequireChkYn;
  }

  public void setSerialRequireChkYn( String serialRequireChkYn ) {
    this.serialRequireChkYn = serialRequireChkYn;
  }

  public String getPsiRcd() {
    return psiRcd;
  }

  public void setPsiRcd( String psiRcd ) {
    this.psiRcd = psiRcd;
  }

  public String getLpmRcd() {
    return lpmRcd;
  }

  public void setLpmRcd( String lpmRcd ) {
    this.lpmRcd = lpmRcd;
  }

  public String getVolt() {
    return volt;
  }

  public void setVolt( String volt ) {
    this.volt = volt;
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

  public String getWaterSourceTemp() {
    return waterSourceTemp;
  }

  public void setWaterSourceTemp( String waterSourceTemp ) {
    this.waterSourceTemp = waterSourceTemp;
  }

  public String getAdptUsed() {
    return adptUsed;
  }

  public void setAdptUsed( String adptUsed ) {
    this.adptUsed = adptUsed;
  }

  public String getInstChklstCheckBox() {
    return instChklstCheckBox;
  }

  public void setInstChklstCheckBox( String instChklstCheckBox ) {
    this.instChklstCheckBox = instChklstCheckBox;
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

  public String getNtu() {
    return ntu;
  }

  public void setNtu( String ntu ) {
    this.ntu = ntu;
  }

  public String getCompetitor() {
    return competitor;
  }

  public void setCompetitor( String competitor ) {
    this.competitor = competitor;
  }

  public String getCompetitorBrand() {
    return competitorBrand;
  }

  public void setCompetitorBrand( String competitorBrand ) {
    this.competitorBrand = competitorBrand;
  }

  public String getWaterSrcType() {
    return waterSrcType;
  }

  public void setWaterSrcType( String waterSrcType ) {
    this.waterSrcType = waterSrcType;
  }

  public String getChkCrtAs() {
    return chkCrtAs;
  }

  public void setChkCrtAs( String chkCrtAs ) {
    this.chkCrtAs = chkCrtAs;
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

  public String getCustomerType() {
    return customerType;
  }

  public void setCustomerType( String customerType ) {
    this.customerType = customerType;
  }

  public String getPartnerCode() {
    return partnerCode;
  }

  public void setPartnerCode( String partnerCode ) {
    this.partnerCode = partnerCode;
  }

  public String getMemCode() {
    return memCode;
  }

  public void setMemCode( String memCode ) {
    this.memCode = memCode;
  }

  public String getType() {
    return type;
  }

  public void setType( String type ) {
    this.type = type;
  }

  public int getInsAccPartId() {
    return insAccPartId;
  }

  public void setInsAccPartId( int insAccPartId ) {
    this.insAccPartId = insAccPartId;
  }

  public String getChkInstallAcc() {
    return chkInstallAcc;
  }

  public void setChkInstallAcc( String chkInstallAcc ) {
    this.chkInstallAcc = chkInstallAcc;
  }

  public String getDispComm() {
    return dispComm;
  }

  public void setDispComm( String dispComm ) {
    this.dispComm = dispComm;
  }

  public String getSerialChk() {
    return serialChk;
  }

  public void setSerialChk( String serialChk ) {
    this.serialChk = serialChk;
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

  public List<Map<String, Object>> createMaps( InstallationResultForm installationResultForm ) {
    List<Map<String, Object>> list = new ArrayList<>();
    Map<String, Object> map;

    map = BeanConverter.toMap( installationResultForm, "signData" );
    map.put( "signData", Base64.decodeBase64( installationResultForm.getSignData() ) );
    map.put( "userId", installationResultForm.getUserId() );
    map.put( "salesOrderNo", installationResultForm.getSalesOrderNo() );
    map.put( "serviceNo", installationResultForm.getServiceNo() );
    map.put( "sirimNo", installationResultForm.getSirimNo() );
    map.put( "serialNo", installationResultForm.getSerialNo() );
    map.put( "asExchangeYN", installationResultForm.getAsExchangeYN() );
    map.put( "beforeProductSerialNo", installationResultForm.getBeforeProductSerialNo() );
    map.put( "resultRemark", installationResultForm.getResultRemark() );
    map.put( "ownerCode", installationResultForm.getOwnerCode() );
    map.put( "resultCustName", installationResultForm.getResultCustName() );
    map.put( "resultIcMobileNo", installationResultForm.getResultIcMobileNo() );
    map.put( "resultReportEmailNo", installationResultForm.getResultReportEmailNo() );
    map.put( "resultAcceptanceName", installationResultForm.getResultAcceptanceName() );
    map.put( "signData", Base64.decodeBase64( installationResultForm.getSignData() ) );
    map.put( "transactionId", installationResultForm.getTransactionId() );
    map.put( "signRegDate", installationResultForm.getSignRegDate() );
    map.put( "signRegTime", installationResultForm.getSignRegTime() );

    if ( partList != null && partList.size() > 0 ) {
      for ( InstallationResultDetailForm dtl : partList ) {
        map.put( "filterCode", dtl.getFilterCode() );
        map.put( "chargesFoc", dtl.getChargesFoc() );
        map.put( "exchangeId", dtl.getExchangeId() );
        map.put( "salesPrice", dtl.getSalesPrice() );
        map.put( "filterChangeQty", dtl.getFilterChangeQty() );
        map.put( "partsType", dtl.getPartsType() );
        map.put( "filterBarcdSerialNo", dtl.getFilterBarcdSerialNo() );
        map.put( "retSmoSerialNo", dtl.getRetSmoSerialNo() );
      }
    }

    if ( installAccList != null && installAccList.size() > 0 ) {
      for ( InstallationResultDetailForm dtl : installAccList ) {
        map.put( "resultNo", dtl.getResultNo() );
        map.put( "resultSoId", dtl.getResultSoId() );
        map.put( "insAccPartId", dtl.getInsAccPartId() );
        map.put( "remark", dtl.getRemark() );
        map.put( "crtUserId", dtl.getCrtUserId() );
      }
    }

    list.add( map );
    return list;
  }
}
