package com.coway.trust.api.mobile.sales.eSVM;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.util.BeanConverter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

@ApiModel(value = "eSVMApiDto", description = "eSVMApiDto")
@JsonIgnoreProperties(ignoreUnknown = true)
public class eSVMApiDto {
  @SuppressWarnings("unchecked")
  public static eSVMApiDto create( EgovMap egvoMap ) {
    return BeanConverter.toBean( egvoMap, eSVMApiDto.class );
  }

  private int svmQuotId;

  private int psmId;

  private int salesOrdId;

  private String regId;

  private String custName;

  private String salesOrdNo;

  private String reqstDt;

  private String quotNo;

  private String psmNo;

  private String orderType;

  private String custType;

  private String status;

  private int statusId;

  private int stkId;

  private String ordNo;

  private String nric;

  private int ordOtdstnd;

  private int asOtstnd;

  private String areaId;

  private String instAddress;

  private String stkName;

  private String memExprDate;

  private int expint;

  private String coolingPrd;

  private String hsFreq;

  private String cvtLastSrvMemExprDate;

  private String cvtNowDate;

  private String trm;

  private int hiddenIsCharge;

  private int hiddenHasFilterCharge;

  private int billMonth;

  private int appTypeId;

  private String rentalStus;

  private String msg;

  private String strprmodt;

  private int custCntId;

  private String userId;

  private String resn;

  private int resnId;

  private int payMode;

  private String appvRem;

  private String saRef;

  private String taxRate;

  // private Boolean svmAllowFlg;
  private int errorCode;

  private String errorHeader;

  private String errorMsg;

  /* Filter Listing */
  private int srvFilterId;

  private int srvFilterStkId;

  private String stkCode;

  private String stkDesc;

  private String c2;

  private String c3;

  private int srvFilterStusId;

  private String srvFilterPrvChgDt;

  private int srvFilterPriod;

  private String code;

  private int c5;

  private int c6;

  private String expiredateint;

  private String todaydateint;

  private int stus;

  private String stusName;

  /* Type of Package */
  private int pkgComboId;

  private String pkgComboName;

  /* Package Promotion */
  private int packagePromoId;

  private String packagePromoName;

  private int promoDiscType;

  private int promoRpfDiscAmt;

  /* Filter Promotion */
  private int filterPromoId;

  private String filterPromoName;

  /* Membership Tab values */
  private int hiddenHasPackage;

  private String bsFreq;

  private int hiddenNormalPrice;

  private int hiddenNormalTaxPrice;

  private int packagePrice;

  private double packageTaxPrice;

  private String zeroRatYn;

  private String eurCertYn;

  private String hiddenBsFreq;

  private int srvMemPacId;

  private int filterCharge;

  private int memLvl;

  /* Package change/Filter change */
  private int promoPrcPrcnt;

  private int promoAddDiscPrc;

  private int productId;

  private int filterId;

  private int prc;

  private int oriPrc;

  private int lifePriod;

  private Date lastChngDt;

  private String filterCode;

  private String filterDesc;

  /* SMQ Request Validations */
  private int rentInstNo;

  private String rentInstDt;

  private int rentInstTypeId;

  private int rentInstAmt;

  private int rentInstInsertMonth;

  private int rentInstInsertYear;

  private int rentInstId;

  private String nowDate;

  /* SMQ Request Insert */
  private String docno;

  /* SMQ retrive - Detail View */
  private int srvDur;

  private String empChk;

  private double srvMemPacAmt;

  private double srvMemPacTaxes;

  private double srvMemPacNetAmt;

  private double paymentAmt;

  private int srvMemBsAmt;

  private String packageDesc;

  private String packageInfoDesc;

  private String filterPromoDesc;

  /* SMQ convert sales */
  private int atchFileGrpId;

  private String subPath;

  private String fileKeySeq;

  /* PSM Attachment */
  private int atchFileId;

  private String atchFileName;

  private String fileSubPath;

  private String physiclFileName;

  private String fileExtsn;

  private String saveFlag;

  private int curAtchFileGrpId;

  private String updBy;

  private String updDt;

  private List<eSVMApiDto> productFilterList;

  private List<eSVMApiDto> packageComboList;

  private List<eSVMApiDto> packagePromoList;

  private List<eSVMApiDto> filterPromoList;

  private List<eSVMApiDto> svmFilterList;

  private List<eSVMApiDto> attachment;

  public int getSvmQuotId() {
    return svmQuotId;
  }

  public void setSvmQuotId( int svmQuotId ) {
    this.svmQuotId = svmQuotId;
  }

  public int getPsmId() {
    return psmId;
  }

  public void setPsmId( int psmId ) {
    this.psmId = psmId;
  }

  public int getSalesOrdId() {
    return salesOrdId;
  }

  public void setSalesOrdId( int salesOrdId ) {
    this.salesOrdId = salesOrdId;
  }

  public String getRegId() {
    return regId;
  }

  public void setRegId( String regId ) {
    this.regId = regId;
  }

  public String getCustName() {
    return custName;
  }

  public void setCustName( String custName ) {
    this.custName = custName;
  }

  public String getSalesOrdNo() {
    return salesOrdNo;
  }

  public void setSalesOrdNo( String salesOrdNo ) {
    this.salesOrdNo = salesOrdNo;
  }

  public String getReqstDt() {
    return reqstDt;
  }

  public void setReqstDt( String reqstDt ) {
    this.reqstDt = reqstDt;
  }

  public String getQuotNo() {
    return quotNo;
  }

  public void setQuotNo( String quotNo ) {
    this.quotNo = quotNo;
  }

  public String getPsmNo() {
    return psmNo;
  }

  public void setPsmNo( String psmNo ) {
    this.psmNo = psmNo;
  }

  public String getOrderType() {
    return orderType;
  }

  public void setOrderType( String orderType ) {
    this.orderType = orderType;
  }

  public String getCustType() {
    return custType;
  }

  public void setCustType( String custType ) {
    this.custType = custType;
  }

  public String getStatus() {
    return status;
  }

  public void setStatus( String status ) {
    this.status = status;
  }

  public int getStatusId() {
    return statusId;
  }

  public void setStatusId( int statusId ) {
    this.statusId = statusId;
  }

  public int getStkId() {
    return stkId;
  }

  public void setStkId( int stkId ) {
    this.stkId = stkId;
  }

  public String getOrdNo() {
    return ordNo;
  }

  public void setOrdNo( String ordNo ) {
    this.ordNo = ordNo;
  }

  public String getNric() {
    return nric;
  }

  public void setNric( String nric ) {
    this.nric = nric;
  }

  public int getOrdOtdstnd() {
    return ordOtdstnd;
  }

  public void setOrdOtdstnd( int ordOtdstnd ) {
    this.ordOtdstnd = ordOtdstnd;
  }

  public int getAsOtstnd() {
    return asOtstnd;
  }

  public void setAsOtstnd( int asOtstnd ) {
    this.asOtstnd = asOtstnd;
  }

  public String getAreaId() {
    return areaId;
  }

  public void setAreaId( String areaId ) {
    this.areaId = areaId;
  }

  public String getInstAddress() {
    return instAddress;
  }

  public void setInstAddress( String instAddress ) {
    this.instAddress = instAddress;
  }

  public String getStkName() {
    return stkName;
  }

  public void setStkName( String stkName ) {
    this.stkName = stkName;
  }

  public String getMemExprDate() {
    return memExprDate;
  }

  public void setMemExprDate( String memExprDate ) {
    this.memExprDate = memExprDate;
  }

  public int getExpint() {
    return expint;
  }

  public void setExpint( int expint ) {
    this.expint = expint;
  }

  public String getCoolingPrd() {
    return coolingPrd;
  }

  public void setCoolingPrd( String coolingPrd ) {
    this.coolingPrd = coolingPrd;
  }

  public String getHsFreq() {
    return hsFreq;
  }

  public void setHsFreq( String hsFreq ) {
    this.hsFreq = hsFreq;
  }

  public String getCvtLastSrvMemExprDate() {
    return cvtLastSrvMemExprDate;
  }

  public void setCvtLastSrvMemExprDate( String cvtLastSrvMemExprDate ) {
    this.cvtLastSrvMemExprDate = cvtLastSrvMemExprDate;
  }

  public String getCvtNowDate() {
    return cvtNowDate;
  }

  public void setCvtNowDate( String cvtNowDate ) {
    this.cvtNowDate = cvtNowDate;
  }

  public String getTrm() {
    return trm;
  }

  public void setTrm( String trm ) {
    this.trm = trm;
  }

  public int getHiddenIsCharge() {
    return hiddenIsCharge;
  }

  public void setHiddenIsCharge( int hiddenIsCharge ) {
    this.hiddenIsCharge = hiddenIsCharge;
  }

  public int getHiddenHasFilterCharge() {
    return hiddenHasFilterCharge;
  }

  public void setHiddenHasFilterCharge( int hiddenHasFilterCharge ) {
    this.hiddenHasFilterCharge = hiddenHasFilterCharge;
  }

  public int getBillMonth() {
    return billMonth;
  }

  public void setBillMonth( int billMonth ) {
    this.billMonth = billMonth;
  }

  public int getAppTypeId() {
    return appTypeId;
  }

  public void setAppTypeId( int appTypeId ) {
    this.appTypeId = appTypeId;
  }

  public String getRentalStus() {
    return rentalStus;
  }

  public void setRentalStus( String rentalStus ) {
    this.rentalStus = rentalStus;
  }

  public String getMsg() {
    return msg;
  }

  public void setMsg( String msg ) {
    this.msg = msg;
  }

  public String getStrprmodt() {
    return strprmodt;
  }

  public void setStrprmodt( String strprmodt ) {
    this.strprmodt = strprmodt;
  }

  public int getCustCntId() {
    return custCntId;
  }

  public void setCustCntId( int custCntId ) {
    this.custCntId = custCntId;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId( String userId ) {
    this.userId = userId;
  }

  public String getResn() {
    return resn;
  }

  public void setResn( String resn ) {
    this.resn = resn;
  }

  public int getResnId() {
    return resnId;
  }

  public void setResnId( int resnId ) {
    this.resnId = resnId;
  }

  public int getPayMode() {
    return payMode;
  }

  public void setPayMode( int payMode ) {
    this.payMode = payMode;
  }

  public String getAppvRem() {
    return appvRem;
  }

  public void setAppvRem( String appvRem ) {
    this.appvRem = appvRem;
  }

  public int getSrvFilterId() {
    return srvFilterId;
  }

  public void setSrvFilterId( int srvFilterId ) {
    this.srvFilterId = srvFilterId;
  }

  public int getSrvFilterStkId() {
    return srvFilterStkId;
  }

  public void setSrvFilterStkId( int srvFilterStkId ) {
    this.srvFilterStkId = srvFilterStkId;
  }

  public String getStkCode() {
    return stkCode;
  }

  public void setStkCode( String stkCode ) {
    this.stkCode = stkCode;
  }

  public String getStkDesc() {
    return stkDesc;
  }

  public void setStkDesc( String stkDesc ) {
    this.stkDesc = stkDesc;
  }

  public String getC2() {
    return c2;
  }

  public void setC2( String c2 ) {
    this.c2 = c2;
  }

  public String getC3() {
    return c3;
  }

  public void setC3( String c3 ) {
    this.c3 = c3;
  }

  public int getSrvFilterStusId() {
    return srvFilterStusId;
  }

  public void setSrvFilterStusId( int srvFilterStusId ) {
    this.srvFilterStusId = srvFilterStusId;
  }

  public String getSrvFilterPrvChgDt() {
    return srvFilterPrvChgDt;
  }

  public void setSrvFilterPrvChgDt( String srvFilterPrvChgDt ) {
    this.srvFilterPrvChgDt = srvFilterPrvChgDt;
  }

  public int getSrvFilterPriod() {
    return srvFilterPriod;
  }

  public void setSrvFilterPriod( int srvFilterPriod ) {
    this.srvFilterPriod = srvFilterPriod;
  }

  public String getCode() {
    return code;
  }

  public void setCode( String code ) {
    this.code = code;
  }

  public int getC5() {
    return c5;
  }

  public void setC5( int c5 ) {
    this.c5 = c5;
  }

  public int getC6() {
    return c6;
  }

  public void setC6( int c6 ) {
    this.c6 = c6;
  }

  public String getExpiredateint() {
    return expiredateint;
  }

  public void setExpiredateint( String expiredateint ) {
    this.expiredateint = expiredateint;
  }

  public String getTodaydateint() {
    return todaydateint;
  }

  public void setTodaydateint( String todaydateint ) {
    this.todaydateint = todaydateint;
  }

  public int getStus() {
    return stus;
  }

  public void setStus( int stus ) {
    this.stus = stus;
  }

  public String getStusName() {
    return stusName;
  }

  public void setStusName( String stusName ) {
    this.stusName = stusName;
  }

  public List<eSVMApiDto> getProductFilterList() {
    return productFilterList;
  }

  public void setProductFilterList( List<eSVMApiDto> productFilterList ) {
    this.productFilterList = productFilterList;
  }

  public int getPkgComboId() {
    return pkgComboId;
  }

  public void setPkgComboId( int pkgComboId ) {
    this.pkgComboId = pkgComboId;
  }

  public String getPkgComboName() {
    return pkgComboName;
  }

  public void setPkgComboName( String pkgComboName ) {
    this.pkgComboName = pkgComboName;
  }

  public List<eSVMApiDto> getPackageComboList() {
    return packageComboList;
  }

  public void setPackageComboList( List<eSVMApiDto> packageComboList ) {
    this.packageComboList = packageComboList;
  }

  public int getPackagePromoId() {
    return packagePromoId;
  }

  public void setPackagePromoId( int packagePromoId ) {
    this.packagePromoId = packagePromoId;
  }

  public String getPackagePromoName() {
    return packagePromoName;
  }

  public void setPackagePromoName( String packagePromoName ) {
    this.packagePromoName = packagePromoName;
  }

  public int getPromoDiscType() {
    return promoDiscType;
  }

  public void setPromoDiscType( int promoDiscType ) {
    this.promoDiscType = promoDiscType;
  }

  public int getPromoRpfDiscAmt() {
    return promoRpfDiscAmt;
  }

  public void setPromoRpfDiscAmt( int promoRpfDiscAmt ) {
    this.promoRpfDiscAmt = promoRpfDiscAmt;
  }

  public List<eSVMApiDto> getPackagePromoList() {
    return packagePromoList;
  }

  public void setPackagePromoList( List<eSVMApiDto> packagePromoList ) {
    this.packagePromoList = packagePromoList;
  }

  public int getFilterPromoId() {
    return filterPromoId;
  }

  public void setFilterPromoId( int filterPromoId ) {
    this.filterPromoId = filterPromoId;
  }

  public String getFilterPromoName() {
    return filterPromoName;
  }

  public void setFilterPromoName( String filterPromoName ) {
    this.filterPromoName = filterPromoName;
  }

  public List<eSVMApiDto> getFilterPromoList() {
    return filterPromoList;
  }

  public void setFilterPromoList( List<eSVMApiDto> filterPromoList ) {
    this.filterPromoList = filterPromoList;
  }

  public int getHiddenHasPackage() {
    return hiddenHasPackage;
  }

  public void setHiddenHasPackage( int hiddenHasPackage ) {
    this.hiddenHasPackage = hiddenHasPackage;
  }

  public String getBsFreq() {
    return bsFreq;
  }

  public void setBsFreq( String bsFreq ) {
    this.bsFreq = bsFreq;
  }

  public int getHiddenNormalPrice() {
    return hiddenNormalPrice;
  }

  public void setHiddenNormalPrice( int hiddenNormalPrice ) {
    this.hiddenNormalPrice = hiddenNormalPrice;
  }

  public int getHiddenNormalTaxPrice() {
    return hiddenNormalTaxPrice;
  }

  public void setHiddenNormalTaxPrice( int hiddenNormalTaxPrice ) {
    this.hiddenNormalTaxPrice = hiddenNormalTaxPrice;
  }

  public int getPackagePrice() {
    return packagePrice;
  }

  public void setPackagePrice( int packagePrice ) {
    this.packagePrice = packagePrice;
  }

  public double getPackageTaxPrice() {
    return packageTaxPrice;
  }

  public void setPackageTaxPrice( double packageTaxPrice ) {
    this.packageTaxPrice = packageTaxPrice;
  }

  public String getZeroRatYn() {
    return zeroRatYn;
  }

  public void setZeroRatYn( String zeroRatYn ) {
    this.zeroRatYn = zeroRatYn;
  }

  public String getEurCertYn() {
    return eurCertYn;
  }

  public void setEurCertYn( String eurCertYn ) {
    this.eurCertYn = eurCertYn;
  }

  public String getHiddenBsFreq() {
    return hiddenBsFreq;
  }

  public void setHiddenBsFreq( String hiddenBsFreq ) {
    this.hiddenBsFreq = hiddenBsFreq;
  }

  public int getSrvMemPacId() {
    return srvMemPacId;
  }

  public void setSrvMemPacId( int srvMemPacId ) {
    this.srvMemPacId = srvMemPacId;
  }

  public int getFilterCharge() {
    return filterCharge;
  }

  public void setFilterCharge( int filterCharge ) {
    this.filterCharge = filterCharge;
  }

  public int getPromoPrcPrcnt() {
    return promoPrcPrcnt;
  }

  public void setPromoPrcPrcnt( int promoPrcPrcnt ) {
    this.promoPrcPrcnt = promoPrcPrcnt;
  }

  public int getPromoAddDiscPrc() {
    return promoAddDiscPrc;
  }

  public void setPromoAddDiscPrc( int promoAddDiscPrc ) {
    this.promoAddDiscPrc = promoAddDiscPrc;
  }

  public int getProductId() {
    return productId;
  }

  public void setProductId( int productId ) {
    this.productId = productId;
  }

  public int getFilterId() {
    return filterId;
  }

  public void setFilterId( int filterId ) {
    this.filterId = filterId;
  }

  public int getPrc() {
    return prc;
  }

  public void setPrc( int prc ) {
    this.prc = prc;
  }

  public int getOriPrc() {
    return oriPrc;
  }

  public void setOriPrc( int oriPrc ) {
    this.oriPrc = oriPrc;
  }

  public int getLifePriod() {
    return lifePriod;
  }

  public void setLifePriod( int lifePriod ) {
    this.lifePriod = lifePriod;
  }

  public Date getLastChngDt() {
    return lastChngDt;
  }

  public void setLastChngDt( Date lastChngDt ) {
    this.lastChngDt = lastChngDt;
  }

  public String getFilterCode() {
    return filterCode;
  }

  public void setFilterCode( String filterCode ) {
    this.filterCode = filterCode;
  }

  public String getFilterDesc() {
    return filterDesc;
  }

  public void setFilterDesc( String filterDesc ) {
    this.filterDesc = filterDesc;
  }

  public int getRentInstNo() {
    return rentInstNo;
  }

  public void setRentInstNo( int rentInstNo ) {
    this.rentInstNo = rentInstNo;
  }

  public String getRentInstDt() {
    return rentInstDt;
  }

  public void setRentInstDt( String rentInstDt ) {
    this.rentInstDt = rentInstDt;
  }

  public int getRentInstTypeId() {
    return rentInstTypeId;
  }

  public void setRentInstTypeId( int rentInstTypeId ) {
    this.rentInstTypeId = rentInstTypeId;
  }

  public int getRentInstAmt() {
    return rentInstAmt;
  }

  public void setRentInstAmt( int rentInstAmt ) {
    this.rentInstAmt = rentInstAmt;
  }

  public int getRentInstInsertMonth() {
    return rentInstInsertMonth;
  }

  public void setRentInstInsertMonth( int rentInstInsertMonth ) {
    this.rentInstInsertMonth = rentInstInsertMonth;
  }

  public int getRentInstInsertYear() {
    return rentInstInsertYear;
  }

  public void setRentInstInsertYear( int rentInstInsertYear ) {
    this.rentInstInsertYear = rentInstInsertYear;
  }

  public int getRentInstId() {
    return rentInstId;
  }

  public void setRentInstId( int rentInstId ) {
    this.rentInstId = rentInstId;
  }

  public String getNowDate() {
    return nowDate;
  }

  public void setNowDate( String nowDate ) {
    this.nowDate = nowDate;
  }

  public String getDocno() {
    return docno;
  }

  public void setDocno( String docno ) {
    this.docno = docno;
  }

  public int getSrvDur() {
    return srvDur;
  }

  public void setSrvDur( int srvDur ) {
    this.srvDur = srvDur;
  }

  public String getEmpChk() {
    return empChk;
  }

  public void setEmpChk( String empChk ) {
    this.empChk = empChk;
  }

  public double getSrvMemPacAmt() {
    return srvMemPacAmt;
  }

  public void setSrvMemPacAmt( double srvMemPacAmt ) {
    this.srvMemPacAmt = srvMemPacAmt;
  }

  public int getSrvMemBsAmt() {
    return srvMemBsAmt;
  }

  public void setSrvMemBsAmt( int srvMemBsAmt ) {
    this.srvMemBsAmt = srvMemBsAmt;
  }

  public double getSrvMemPacTaxes() {
    return srvMemPacTaxes;
  }

  public void setSrvMemPacTaxes( double srvMemPacTaxes ) {
    this.srvMemPacTaxes = srvMemPacTaxes;
  }

  public double getPaymentAmt() {
    return paymentAmt;
  }

  public void setPaymentAmt( double paymentAmt ) {
    this.paymentAmt = paymentAmt;
  }

  public String getPackageDesc() {
    return packageDesc;
  }

  public void setPackageDesc( String packageDesc ) {
    this.packageDesc = packageDesc;
  }

  public String getPackageInfoDesc() {
    return packageInfoDesc;
  }

  public void setPackageInfoDesc( String packageInfoDesc ) {
    this.packageInfoDesc = packageInfoDesc;
  }

  public String getFilterPromoDesc() {
    return filterPromoDesc;
  }

  public void setFilterPromoDesc( String filterPromoDesc ) {
    this.filterPromoDesc = filterPromoDesc;
  }

  public List<eSVMApiDto> getSvmFilterList() {
    return svmFilterList;
  }

  public void setSvmFilterList( List<eSVMApiDto> svmFilterList ) {
    this.svmFilterList = svmFilterList;
  }

  public int getAtchFileGrpId() {
    return atchFileGrpId;
  }

  public void setAtchFileGrpId( int atchFileGrpId ) {
    this.atchFileGrpId = atchFileGrpId;
  }

  public String getSubPath() {
    return subPath;
  }

  public void setSubPath( String subPath ) {
    this.subPath = subPath;
  }

  public String getFileKeySeq() {
    return fileKeySeq;
  }

  public void setFileKeySeq( String fileKeySeq ) {
    this.fileKeySeq = fileKeySeq;
  }

  public List<eSVMApiDto> getAttachment() {
    return attachment;
  }

  public void setAttachment( List<eSVMApiDto> attachment ) {
    this.attachment = attachment;
  }

  public int getAtchFileId() {
    return atchFileId;
  }

  public void setAtchFileId( int atchFileId ) {
    this.atchFileId = atchFileId;
  }

  public String getAtchFileName() {
    return atchFileName;
  }

  public void setAtchFileName( String atchFileName ) {
    this.atchFileName = atchFileName;
  }

  public String getFileSubPath() {
    return fileSubPath;
  }

  public void setFileSubPath( String fileSubPath ) {
    this.fileSubPath = fileSubPath;
  }

  public String getPhysiclFileName() {
    return physiclFileName;
  }

  public void setPhysiclFileName( String physiclFileName ) {
    this.physiclFileName = physiclFileName;
  }

  public String getFileExtsn() {
    return fileExtsn;
  }

  public void setFileExtsn( String fileExtsn ) {
    this.fileExtsn = fileExtsn;
  }

  public String getSaveFlag() {
    return saveFlag;
  }

  public void setSaveFlag( String saveFlag ) {
    this.saveFlag = saveFlag;
  }

  public int getCurAtchFileGrpId() {
    return curAtchFileGrpId;
  }

  public void setCurAtchFileGrpId( int curAtchFileGrpId ) {
    this.curAtchFileGrpId = curAtchFileGrpId;
  }

  public int getMemLvl() {
    return memLvl;
  }

  public void setMemLvl( int memLvl ) {
    this.memLvl = memLvl;
  }

  public String getSaRef() {
    return saRef;
  }

  public void setSaRef( String saRef ) {
    this.saRef = saRef;
  }

  public String getTaxRate() {
    return taxRate;
  }

  public void setTaxRate( String taxRate ) {
    this.taxRate = taxRate;
  }

  // public Boolean getSvmAllowFlg() {
  // return svmAllowFlg;
  // }
  //
  // public void setSvmAllowFlg(Boolean svmAllowFlg) {
  // this.svmAllowFlg = svmAllowFlg;
  // }
  public int getErrorCode() {
    return errorCode;
  }

  public void setErrorCode( int errorCode ) {
    this.errorCode = errorCode;
  }

  public String getErrorHeader() {
    return errorHeader;
  }

  public void setErrorHeader( String errorHeader ) {
    this.errorHeader = errorHeader;
  }

  public String getErrorMsg() {
    return errorMsg;
  }

  public void setErrorMsg( String errorMsg ) {
    this.errorMsg = errorMsg;
  }

  public String getUpdBy() {
    return updBy;
  }

  public void setUpdBy( String updBy ) {
    this.updBy = updBy;
  }

  public String getUpdDt() {
    return updDt;
  }

  public void setUpdDt( String updDt ) {
    this.updDt = updDt;
  }

public double getSrvMemPacNetAmt() {
	return srvMemPacNetAmt;
}

public void setSrvMemPacNetAmt(double srvMemPacNetAmt) {
	this.srvMemPacNetAmt = srvMemPacNetAmt;
}
}
