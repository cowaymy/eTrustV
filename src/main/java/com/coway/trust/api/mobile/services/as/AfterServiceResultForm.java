package com.coway.trust.api.mobile.services.as;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceResultForm", description = "AfterServiceResultForm")
public class AfterServiceResultForm {
  // private static final Logger LOGGER = LoggerFactory.getLogger( AfterServiceResultForm.class );
  @ApiModelProperty(value = "partList")
  private List<AfterServiceResultDetailForm> partList;

  @ApiModelProperty(value = "installAccList")
  private List<AfterServiceResultDetailForm> installAccList;

  @ApiModelProperty(value = "USER ID")
  private String userId;

  @ApiModelProperty(value = "SALES ORDER NO")
  private String salesOrderNo;

  @ApiModelProperty(value = "AS NO")
  private String serviceNo;

  @ApiModelProperty(value = "LABOUR CHARGE")
  private double labourCharge;

  @ApiModelProperty(value = "DEFECT ID")
  private int defectId;

  @ApiModelProperty(value = "DEFECT PART ID")
  private int defectPartId;

  @ApiModelProperty(value = "DEFECT DETAIL REASON ID")
  private int defectDetailReasonId;

  @ApiModelProperty(value = "SOLUTION REASON ID")
  private int solutionReasonId;

  @ApiModelProperty(value = "DEFECT TYPE ID")
  private int defectTypeId;

  @ApiModelProperty(value = "IN HOUSE REPAIR REMARK")
  private String inHouseRepairRemark;

  @ApiModelProperty(value = "IN HOUSE REPARI REPLACEMENT INDICATOR")
  private String inHouseRepairReplacementYN;

  @ApiModelProperty(value = "IN HOUSE REPAIR PROMISED DATE")
  private String inHouseRepairPromisedDate;

  @ApiModelProperty(value = "IN HOUSE REPAIR PRODUCT GROUP CODE")
  private String inHouseRepairProductGroupCode;

  @ApiModelProperty(value = "IN HOUSE REPAIR PRODUCT CODE")
  private String inHouseRepairProductCode;

  @ApiModelProperty(value = "IN HOUSE REPAIR SERIAL NO")
  private String inHouseRepairSerialNo;

  @ApiModelProperty(value = "RESULT REMARK")
  private String resultRemark;

  @ApiModelProperty(value = "OWNER CODE")
  private int ownerCode;

  @ApiModelProperty(value = "RESULT CUSTOMER NAME")
  private String resultCustName;

  @ApiModelProperty(value = "RESULT MOBILE NO")
  private String resultIcMobileNo;

  @ApiModelProperty(value = "RESULT REPORT EMAIL NO")
  private String resultReportEmailNo;

  @ApiModelProperty(value = "RESULT ACCPETANCE NAME")
  private String resultAcceptanceName;

  @ApiModelProperty(value = "BASE 64 SINGNATURE")
  private String signData;

  @ApiModelProperty(value = "TRANSACTION ID")
  private String transactionId;

  @ApiModelProperty(value = "SERIAL SCAN INDICATOR")
  private String scanSerial;

  @ApiModelProperty(value = "SERIAL CHECK INDICATOR")
  private String serialRequireChkYn;

  @ApiModelProperty(value = "PSI")
  private String psiRcd;

  @ApiModelProperty(value = "LPM")
  private String lpmRcd;

  @ApiModelProperty(value = "AS UNMATCH REASON")
  private String asUnmatchReason;

  @ApiModelProperty(value = "REWORK PROJECT")
  private String reworkProj;

  @ApiModelProperty(value = "WATER SOURCE TYPE")
  private String waterSrcType;

  @ApiModelProperty(value = "PARTNER CODE")
  private int partnerCode;

  @ApiModelProperty(value = "PARTNER CODE NAME")
  private String memCode;

  @ApiModelProperty(value = "NTU")
  private String ntu;

  @ApiModelProperty(value = "INSTALLATION ACCESSERIES")
  private String instAccs;

  @ApiModelProperty(value = "INSTALLATION ACCESSERIES VALUE")
  private int instAccsVal;

  @ApiModelProperty(value = "TYPE")
  private String type;

  @ApiModelProperty(value = "INSTALLATION ACCESSERIES PART ID")
  private int insAccPartId;

  @ApiModelProperty(value = "INSTALLATION ACCESSERIES INDICATOR")
  private String chkInstallAcc;

  @ApiModelProperty(value = "SIGNATURE DATE")
  private String signRegDate;

  @ApiModelProperty(value = "SIGNATURE TIME")
  private String signRegTime;

  @ApiModelProperty(value = "CHECK IN DATE")
  private String checkInDate;

  @ApiModelProperty(value = "CHECK IN TIME")
  private String checkInTime;

  @ApiModelProperty(value = "CHECK IN GPS")
  private String checkInGps;

  @ApiModelProperty(value = "VOLTAGE")
  private String voltage;

  public List<AfterServiceResultDetailForm> getPartList() {
    return partList;
  }

  public void setPartList( List<AfterServiceResultDetailForm> partList ) {
    this.partList = partList;
  }

  public List<AfterServiceResultDetailForm> getInstallAccList() {
    return installAccList;
  }

  public void setInstallAccList( List<AfterServiceResultDetailForm> installAccList ) {
    this.installAccList = installAccList;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId( String userId ) {
    this.userId = userId;
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

  public double getLabourCharge() {
    return labourCharge;
  }

  public void setLabourCharge( double labourCharge ) {
    this.labourCharge = labourCharge;
  }

  public int getDefectId() {
    return defectId;
  }

  public void setDefectId( int defectId ) {
    this.defectId = defectId;
  }

  public int getDefectPartId() {
    return defectPartId;
  }

  public void setDefectPartId( int defectPartId ) {
    this.defectPartId = defectPartId;
  }

  public int getDefectDetailReasonId() {
    return defectDetailReasonId;
  }

  public void setDefectDetailReasonId( int defectDetailReasonId ) {
    this.defectDetailReasonId = defectDetailReasonId;
  }

  public int getSolutionReasonId() {
    return solutionReasonId;
  }

  public void setSolutionReasonId( int solutionReasonId ) {
    this.solutionReasonId = solutionReasonId;
  }

  public int getDefectTypeId() {
    return defectTypeId;
  }

  public void setDefectTypeId( int defectTypeId ) {
    this.defectTypeId = defectTypeId;
  }

  public String getInHouseRepairRemark() {
    return inHouseRepairRemark;
  }

  public void setInHouseRepairRemark( String inHouseRepairRemark ) {
    this.inHouseRepairRemark = inHouseRepairRemark;
  }

  public String getInHouseRepairReplacementYN() {
    return inHouseRepairReplacementYN;
  }

  public void setInHouseRepairReplacementYN( String inHouseRepairReplacementYN ) {
    this.inHouseRepairReplacementYN = inHouseRepairReplacementYN;
  }

  public String getInHouseRepairPromisedDate() {
    return inHouseRepairPromisedDate;
  }

  public void setInHouseRepairPromisedDate( String inHouseRepairPromisedDate ) {
    this.inHouseRepairPromisedDate = inHouseRepairPromisedDate;
  }

  public String getInHouseRepairProductGroupCode() {
    return inHouseRepairProductGroupCode;
  }

  public void setInHouseRepairProductGroupCode( String inHouseRepairProductGroupCode ) {
    this.inHouseRepairProductGroupCode = inHouseRepairProductGroupCode;
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

  public String getScanSerial() {
    return scanSerial;
  }

  public void setScanSerial( String scanSerial ) {
    this.scanSerial = scanSerial;
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

  public String getAsUnmatchReason() {
    return asUnmatchReason;
  }

  public void setAsUnmatchReason( String asUnmatchReason ) {
    this.asUnmatchReason = asUnmatchReason;
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

  public int getPartnerCode() {
    return partnerCode;
  }

  public void setPartnerCode( int partnerCode ) {
    this.partnerCode = partnerCode;
  }

  public String getMemCode() {
    return memCode;
  }

  public void setMemCode( String memCode ) {
    this.memCode = memCode;
  }

  public String getNtu() {
    return ntu;
  }

  public void setNtu( String ntu ) {
    this.ntu = ntu;
  }

  public String getInstAccs() {
    return instAccs;
  }

  public void setInstAccs( String instAccs ) {
    this.instAccs = instAccs;
  }

  public int getInstAccsVal() {
    return instAccsVal;
  }

  public void setInstAccsVal( int instAccsVal ) {
    this.instAccsVal = instAccsVal;
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

  public String getVoltage() {
    return voltage;
  }

  public void setVoltage( String voltage ) {
    this.voltage = voltage;
  }

  public List<Map<String, Object>> createMaps( AfterServiceResultForm afterServiceResultForm ) {
    List<Map<String, Object>> list = new ArrayList<>();
    Map<String, Object> map;

    map = BeanConverter.toMap( afterServiceResultForm, "signData", "partList" );
    map.put( "signData", Base64.decodeBase64( afterServiceResultForm.getSignData() ) );

    if ( partList != null && partList.size() > 0 ) {
      for ( AfterServiceResultDetailForm dtl : partList ) {
        map.put( "filterCode", dtl.getFilterCode() );
        map.put( "chargesFoc", dtl.getChargesFoc() );
        map.put( "exchangeId", dtl.getExchangeId() );
        map.put( "salesPrice", dtl.getSalesPrice() );
        map.put( "filterChangeQty", dtl.getFilterChangeQty() );
        map.put( "partsType", dtl.getPartsType() );
        map.put( "filterBarcdSerialNo", dtl.getFilterBarcdSerialNo() );
        map.put( "retSmoSerialNo", dtl.getRetSmoSerialNo() );
        map.put( "filterBarcdNewSerialNo", dtl.getFilterBarcdNewSerialNo() );
        map.put( "filterBarcdOldSerialNo", dtl.getFilterBarcdOldSerialNo() );
        map.put( "filterSerialUnmatchReason", dtl.getFilterSerialUnmatchReason() );
        map.put( "sysFilterBarcdSerialNo", dtl.getSysFilterBarcdSerialNo() );
      }
    }

    if ( installAccList != null && installAccList.size() > 0 ) {
      for ( AfterServiceResultDetailForm dtl : installAccList ) {
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

  public static List<Map<String, Object>> createMaps1( AfterServiceResultForm afterServiceResultForm ) {
    List<Map<String, Object>> list = new ArrayList<>();
    Map<String, Object> map;

    map = BeanConverter.toMap( afterServiceResultForm, "signData" );
    map.put( "signData", Base64.decodeBase64( afterServiceResultForm.getSignData() ) );
    list.add( map );

    return list;
  }
}
