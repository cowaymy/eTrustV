package com.coway.trust.api.mobile.services.installation;

import java.util.ArrayList;
import org.apache.commons.codec.binary.Base64;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.api.mobile.services.ServiceApiController;
import com.coway.trust.api.mobile.services.as.AfterServiceResultDetailForm;
import com.coway.trust.api.mobile.services.as.AfterServiceResultForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class InstallationResultForm {
  private static final Logger LOGGER = LoggerFactory.getLogger( InstallationResultForm.class );

  @ApiModelProperty(value = "사용자 ID (예_CT123456)")
  private String userId;

  @ApiModelProperty(value = "주문번호")
  private int salesOrderNo;

  @ApiModelProperty(value = "EX_BS00000 / AS00000")
  private String serviceNo;

  @ApiModelProperty(value = "sirim 코드")
  private String sirimNo;

  @ApiModelProperty(value = "serial 코드")
  private String serialNo;

  @ApiModelProperty(value = "before INST 교체여부")
  private String asExchangeYN;

  @ApiModelProperty(value = "before INST 교체제품 SN")
  private String beforeProductSerialNo;

  @ApiModelProperty(value = "결과 등록 메모")
  private String resultRemark;

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

  @ApiModelProperty(value = "base64 Data")
  private String signData;

  @ApiModelProperty(value = "Transaction ID 값(체계 : USER_ID + SALES_ORDER_NO + SERVICE_NO + 현재시간_YYYYMMDDHHMMSS)")
  private String transactionId;

  private String signRegDate;

  private String signRegTime;

  private String checkInDate;

  private String checkInTime;

  private String checkInGps;

  private String scanSerial;

  private String fraSerialNo;

  private String serialRequireChkYn;

  private String psiRcd;

  private String lpmRcd;

  private String volt;

  private String tds;

  private String roomTemp;

  private String waterSourceTemp;

  private String adptUsed;

  private String instChklstCheckBox;

  private String instNoteChk;

  private String boosterPump;

  private String aftPsi;

  private String aftLpm;

  private String turbLvl;

  private String ntu;

  private String competitor;

  private String competitorBrand;

  private String waterSrcType;

  private String chkCrtAs;

  private String chkSms;

  private String checkSend;

  private String custMobileNo;

  private String customerType;

  private String partnerCode;

  private String memCode;

  private String type;

  private int insAccPartId;

  private String chkInstallAcc;

  @ApiModelProperty(value = "installAccList")
  private List<InstallationResultDetailForm> installAccList;

  @ApiModelProperty(value = "partList")
  private List<InstallationResultDetailForm> partList;

  public String getChkInstallAcc() {
    return chkInstallAcc;
  }

  public List<InstallationResultDetailForm> getInstallAccList() {
    return installAccList;
  }

  public void setChkInstallAcc( String chkInstallAcc ) {
    this.chkInstallAcc = chkInstallAcc;
  }

  public void setInstallAccList( List<InstallationResultDetailForm> installAccList ) {
    this.installAccList = installAccList;
  }

  public String getType() {
    return type;
  }

  public String getNtu() {
    return ntu;
  }

  public void setNtu( String ntu ) {
    this.ntu = ntu;
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

  public String getChkCrtAs() {
    return chkCrtAs;
  }

  public String getPartnerCode() {
    return partnerCode;
  }

  public String getMemCode() {
    return memCode;
  }

  public void setPartnerCode( String partnerCode ) {
    this.partnerCode = partnerCode;
  }

  public void setMemCode( String memCode ) {
    this.memCode = memCode;
  }

  public void setChkCrtAs( String chkCrtAs ) {
    this.chkCrtAs = chkCrtAs;
  }

  public String getTurbLvl() {
    return turbLvl;
  }

  public void setTurbLvl( String turbLvl ) {
    this.turbLvl = turbLvl;
  }

  public String getWaterSrcType() {
    return waterSrcType;
  }

  public void setWaterSrcType( String waterSrcType ) {
    this.waterSrcType = waterSrcType;
  }

  public String getCheckSend() {
    return checkSend;
  }

  public void setCheckSend( String checkSend ) {
    this.checkSend = checkSend;
  }

  public String getChkSms() {
    return chkSms;
  }

  public void setChkSms( String chkSms ) {
    this.chkSms = chkSms;
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

  public String getLpmRcd() {
    return lpmRcd;
  }

  public void setLpmRcd( String lpmRcd ) {
    this.lpmRcd = lpmRcd;
  }

  public String getPsiRcd() {
    return psiRcd;
  }

  public void setPsiRcd( String psiRcd ) {
    this.psiRcd = psiRcd;
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

  public String getSerialRequireChkYn() {
    return serialRequireChkYn;
  }

  public void setSerialRequireChkYn( String serialRequireChkYn ) {
    this.serialRequireChkYn = serialRequireChkYn;
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

  private String serialChk;

  public String getSerialChk() {
    return serialChk;
  }

  public void setSerialChk( String serialChk ) {
    this.serialChk = serialChk;
  }

  private String realAsExchangeYn;

  public String getRealAsExchangeYn() {
    return realAsExchangeYn;
  }

  public void setRealAsExchangeYn( String realAsExchangeYn ) {
    this.realAsExchangeYn = realAsExchangeYn;
  }

  private String realBeforeProductCode;

  public String getRealBeforeProductCode() {
    return realBeforeProductCode;
  }

  public void setRealBeforeProductCode( String realBeforeProductCode ) {
    this.realBeforeProductCode = realBeforeProductCode;
  }

  private String realBeforeProductName;

  public String getRealBeforeProductName() {
    return realBeforeProductName;
  }

  public void setRealBeforeProductName( String realBeforeProductName ) {
    this.realBeforeProductName = realBeforeProductName;
  }

  private String realBeforeProductSerialNo;

  public String getRealBeforeProductSerialNo() {
    return realBeforeProductSerialNo;
  }

  public void setRealBeforeProductSerialNo( String realBeforeProductSerialNo ) {
    this.realBeforeProductSerialNo = realBeforeProductSerialNo;
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

  public List<InstallationResultDetailForm> getPartList() {
    return partList;
  }

  public void setPartList( List<InstallationResultDetailForm> partList ) {
    this.partList = partList;
  }

  // public static Map<String, Object> createMaps(InstallationResultForm
  // installationResultForm) {
  // Map<String, Object> params = new HashMap<>();
  // params.put("userId", installationResultForm.getUserId());
  // params.put("salesOrderNo", installationResultForm.getSalesOrderNo());
  // params.put("serviceNo", installationResultForm.getServiceNo());
  // params.put("sirimNo", installationResultForm.getSirimNo());
  // params.put("serialNo", installationResultForm.getSerialNo());
  // params.put("asExchangeYN", installationResultForm.getAsExchangeYN());
  // params.put("beforeProductSerialNo",
  // installationResultForm.getBeforeProductSerialNo());
  // params.put("resultRemark", installationResultForm.getResultRemark());
  // params.put("ownerCode", installationResultForm.getOwnerCode());
  // params.put("resultCustName", installationResultForm.getResultCustName());
  // params.put("resultIcMobileNo",
  // installationResultForm.getResultIcMobileNo());
  // params.put("resultReportEmailNo",
  // installationResultForm.getResultReportEmailNo());
  // params.put("resultAcceptanceName",
  // installationResultForm.getResultAcceptanceName());
  //
  // params.put("signData",
  // Base64.decodeBase64(installationResultForm.getSignData()));
  //
  // params.put("transactionId", installationResultForm.getTransactionId());
  //
  // return params;
  // }

  public List<Map<String, Object>> createMaps( InstallationResultForm installationResultForm ) {
    List<Map<String, Object>> list = new ArrayList<>();
    Map<String, Object> map;

    // for(InstallationResultForm form : installationResultForm){
    //// map = BeanConverter.toMap(installationResultForm, "signData");
    //// map.put("signData",
    // Base64.decodeBase64(installationResultForm.getSignData()));
    //
    // list.add(map);
    // }

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

    /////////////////////////////// ADD FILTER / PARTS /MISC /////////////////////////////////////
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
    /////////////////////////////// ADD FILTER / PARTS / MISC /////////////////////////////////////

    /////////////////////////////// ADD INSTALLATION ACCES. /////////////////////////////////////
    if ( installAccList != null && installAccList.size() > 0 ) {
      for ( InstallationResultDetailForm dtl : installAccList ) {
        map.put( "resultNo", dtl.getResultNo() );
        map.put( "resultSoId", dtl.getResultSoId() );
        map.put( "insAccPartId", dtl.getInsAccPartId() );
        map.put( "remark", dtl.getRemark() );
        map.put( "crtUserId", dtl.getCrtUserId() );
      }
    }
    /////////////////////////////// ADD INSTALLATION ACCES.  /////////////////////////////////////

    list.add( map );
    return list;
  }

  /*
   * public List<Map<String, Object>> createMaps(InstallationResultForm installationResultForm) {
   * List<Map<String, Object>> list = new ArrayList<>(); if (partList != null && partList.size() >
   * 0) { Map<String, Object> map; for (InstallationResultDetailForm dtl : partList) { map =
   * BeanConverter.toMap(installationResultForm, "signData", "partList"); map.put("signData",
   * Base64.decodeBase64(installationResultForm.getSignData())); // as Dtails map.put("filterCode",
   * dtl.getFilterCode()); map.put("chargesFoc", dtl.getChargesFoc()); map.put("exchangeId",
   * dtl.getExchangeId()); map.put("salesPrice", dtl.getSalesPrice()); map.put("filterChangeQty",
   * dtl.getFilterChangeQty()); map.put("partsType", dtl.getPartsType());
   * map.put("filterBarcdSerialNo", dtl.getFilterBarcdSerialNo()); map.put("retSmoSerialNo",
   * dtl.getRetSmoSerialNo()); list.add(map); } } return list; }
   */
}
