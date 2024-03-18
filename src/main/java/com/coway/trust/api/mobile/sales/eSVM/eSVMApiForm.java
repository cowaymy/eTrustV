package com.coway.trust.api.mobile.sales.eSVM;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "eSVMApiForm", description = "eSVMApiForm")
public class eSVMApiForm {
  public static eSVMApiForm create( Map<String, Object> map ) {
    return BeanConverter.toBean( map, eSVMApiForm.class );
  }

  public static Map<String, Object> createMap( eSVMApiForm vo ) {
    Map<String, Object> params = new HashMap<>();
    params.put( "flag", vo.getFlag() );
    params.put( "mode", vo.getMode() );
    params.put( "reqstDtFrom", vo.getReqstDtFrom() );
    params.put( "reqstDtTo", vo.getReqstDtTo() );
    params.put( "selectType", vo.getSelectType() );
    params.put( "selectKeyword", vo.getSelectKeyword() );
    params.put( "regId", vo.getRegId() );
    params.put( "svmQuotId", vo.getSvmQuotId() );
    params.put( "psmId", vo.getPsmId() );
    params.put( "salesOrdId", vo.getSalesOrdId() );
    params.put( "custName", vo.getCustName() );
    params.put( "salesOrdNo", vo.getSalesOrdNo() );
    params.put( "quotNo", vo.getQuotNo() );
    params.put( "psmNo", vo.getPsmNo() );
    params.put( "orderType", vo.getOrderType() );
    params.put( "custType", vo.getCustType() );
    params.put( "status", vo.getStatus() );
    params.put( "stkId", vo.getStkId() );
    params.put( "ordNo", vo.getOrdNo() );
    params.put( "nric", vo.getNric() );
    params.put( "ordOtdstnd", vo.getOrdOtdstnd() );
    params.put( "asOtstnd", vo.getAsOtstnd() );
    params.put( "address", vo.getAddress() );
    params.put( "stkName", vo.getStkName() );
    params.put( "memExprDate", vo.getMemExprDate() );
    params.put( "expint", vo.getExpint() );
    params.put( "coolingPrd", vo.getCoolingPrd() );
    params.put( "hsFreq", vo.getHsFreq() );
    params.put( "trm", vo.getTrm() );
    params.put( "hiddenIsCharge", vo.getHiddenIsCharge() );
    params.put( "hiddenHasFilterCharge", vo.getHiddenHasFilterCharge() );
    params.put( "employee", vo.getEmployee() );
    params.put( "appTypeId", vo.getAppTypeId() );
    params.put( "rentalStus", vo.getRentalStus() );
    params.put( "srvFilterId", vo.getSrvFilterId() );
    params.put( "srvFilterStkId", vo.getSrvFilterStkId() );
    params.put( "stkCode", vo.getStkCode() );
    params.put( "stkDesc", vo.getStkDesc() );
    params.put( "c2", vo.getC2() );
    params.put( "c3", vo.getC3() );
    params.put( "srvFilterStusId", vo.getSrvFilterStusId() );
    params.put( "srvFilterPrvChgDt", vo.getSrvFilterPrvChgDt() );
    params.put( "srvFilterPriod", vo.getSrvFilterPriod() );
    params.put( "code", vo.getCode() );
    params.put( "c5", vo.getC5() );
    params.put( "c6", vo.getC6() );
    params.put( "expiredateint", vo.getExpiredateint() );
    params.put( "todaydateint", vo.getTodaydateint() );
    params.put( "zeroRatYn", vo.getZeroRatYn() );
    params.put( "eurCertYn", vo.getEurCertYn() );
    params.put( "subYear", vo.getSubYear() );
    params.put( "promoId", vo.getPromoId() );
    params.put( "groupCode", vo.getGroupCode() );
    params.put( "codeName", vo.getCodeName() );
    params.put( "srvMemQuotId", vo.getSrvMemQuotId() );
    params.put( "srvSalesOrderId", vo.getSrvSalesOrderId() );
    params.put( "srvMemQuotNo", vo.getSrvMemQuotNo() );
    params.put( "srvMemPacId", vo.getSrvMemPacId() );
    params.put( "srvMemPacAmt", vo.getSrvMemPacAmt() );
    params.put( "srvMemPacNetAmt", vo.getSrvMemPacNetAmt() );
    params.put( "srvMemBSAmt", vo.getSrvMemBSAmt() );
    params.put( "srvMemBSNetAmt", vo.getSrvMemBSNetAmt() );
    params.put( "srvMemPv", vo.getSrvMemPv() );
    params.put( "srvDuration", vo.getSrvDuration() );
    params.put( "srvRemark", vo.getSrvRemark() );
    params.put( "srvQuotStatusId", vo.getSrvQuotStatusId() );
    params.put( "srvMemBS12Amt", vo.getSrvMemBS12Amt() );
    params.put( "srvPacPromoId", vo.getSrvPacPromoId() );
    params.put( "srvPromoId", vo.getSrvPromoId() );
    params.put( "srvQuotCustCntId", vo.getSrvQuotCustCntId() );
    params.put( "srvMemQty", vo.getSrvMemQty() );
    params.put( "srvSalesMemId", vo.getSrvSalesMemId() );
    params.put( "srvMemId", vo.getSrvMemId() );
    params.put( "srvOrderStkId", vo.getSrvOrderStkId() );
    params.put( "srvFreq", vo.getSrvFreq() );
    params.put( "empChk", vo.getEmpChk() );
    params.put( "isFilterCharge", vo.getIsFilterCharge() );
    params.put( "srvMemPacTaxes", vo.getSrvMemPacTaxes() );
    params.put( "srvMemBSTaxes", vo.getSrvMemBSTaxes() );
    params.put( "sal93Seq", vo.getSal93Seq() );
    params.put( "atchFileGrpId", vo.getAtchFileGrpId() );
    params.put( "subPath", vo.getSubPath() );
    params.put( "fileKeySeq", vo.getFileKeySeq() );
    params.put( "payMode", vo.getPayMode() );
    params.put( "otstndAmt", vo.getOtstndAmt() );
    params.put( "payAmt", vo.getPayAmt() );
    params.put( "slipNo", vo.getSlipNo() );
    params.put( "issuBankId", vo.getIssuBankId() );
    params.put( "chqDt", vo.getChqDt() );
    params.put( "chqNo", vo.getChqNo() );
    params.put( "sms1", vo.getSms1() );
    params.put( "sms2", vo.getSms2() );
    params.put( "email1", vo.getEmail1() );
    params.put( "email2", vo.getEmail2() );
    params.put( "cardNo", vo.getCardNo() );
    params.put( "approvalNo", vo.getApprovalNo() );
    params.put( "crcName", vo.getCrcName() );
    params.put( "transactionDate", vo.getTransactionDate() );
    params.put( "expiryDate", vo.getExpiryDate() );
    params.put( "cardMode", vo.getCardMode() );
    params.put( "merchantBank", vo.getMerchantBank() );
    params.put( "cardBrand", vo.getCardBrand() );
    params.put( "atchFileSvmF", vo.getAtchFileSvmF() );
    params.put( "atchFileSvmTnc", vo.getAtchFileSvmTnc() );
    params.put( "atchFilePo", vo.getAtchFilePo() );
    params.put( "atchFileNricCrcF", vo.getAtchFileNricCrcF() );
    params.put( "atchFileNricCrcB", vo.getAtchFileNricCrcB() );
    params.put( "atchFileTrxSlip", vo.getAtchFileTrxSlip() );
    params.put( "atchFileChqImg", vo.getAtchFileChqImg() );
    params.put( "atchFileOther1", vo.getAtchFileOther1() );
    params.put( "atchFileOther2", vo.getAtchFileOther2() );
    params.put( "atchFileOther3", vo.getAtchFileOther3() );
    params.put( "curAtchFileGrpId", vo.getCurAtchFileGrpId() );
    params.put( "progressStatus", vo.getProgressStatus() );
    params.put( "userNm", vo.getUserNm() );
    params.put( "custTypeId", vo.getCustTypeId() );
    params.put( "taxRate", vo.getTaxRate() );
    return params;
  }

  private String flag;

  private String mode;

  private String reqstDtFrom;

  private String reqstDtTo;

  private String selectType;

  private String selectKeyword;

  private String regId;

  private int svmQuotId;

  private int psmId;

  private int salesOrdId;

  private String custName;

  private String salesOrdNo;

  private String reqstDt;

  private String quotNo;

  private String psmNo;

  private String orderType;

  private String custType;

  private String status;

  private int progressStatus;

  private int stkId;

  private String ordNo;

  private String nric;

  private int ordOtdstnd;

  private int asOtstnd;

  private String address;

  private String stkName;

  private String memExprDate;

  private int expint;

  private String coolingPrd;

  private String hsFreq;

  private String trm;

  private String hiddenIsCharge;

  private String hiddenHasFilterCharge;

  private String employee;

  private int appTypeId;

  private String rentalStus;

  private int custTypeId;

  private String taxRate;

  /* New Quotation - Filter Listing */
  private int srvFilterId;

  private int srvFilterStkId;

  private String stkCode;

  private String stkDesc;

  private String c2;

  private String c3;

  private String srvFilterStusId;

  private String srvFilterPrvChgDt;

  private String srvFilterPriod;

  private String code;

  private String c5;

  private String c6;

  private String expiredateint;

  private String todaydateint;

  /* Defaulting values after initial criteria selection */
  private String zeroRatYn;

  private String eurCertYn;

  private int subYear;

  private int promoId;

  private String groupCode;

  private String codeName;

  /* SMQ Request */
  private String srvMemQuotId;

  private String srvSalesOrderId;

  private String srvMemQuotNo;

  private String srvMemPacId;

  private String srvMemPacAmt;

  private String srvMemPacNetAmt;

  private String srvMemBSAmt;

  private String srvMemBSNetAmt;

  private String srvMemPv;

  private String srvDuration;

  private String srvRemark;

  private String srvQuotStatusId;

  private String srvMemBS12Amt;

  private String srvPacPromoId;

  private String srvPromoId;

  private String srvQuotCustCntId;

  private String srvMemQty;

  private String srvSalesMemId;

  private String srvMemId;

  private String srvOrderStkId;

  private String srvFreq;

  private String empChk;

  private String isFilterCharge;

  private String srvMemPacTaxes;

  private String srvMemBSTaxes;

  private String sal93Seq;

  /* SMQ convert sales */
  private int atchFileGrpId;

  private String subPath;

  private String fileKeySeq;
  // private eSVMApiDto saveData;

  private int payMode;

  private BigDecimal otstndAmt;

  private BigDecimal payAmt;

  private String slipNo;

  private int issuBankId;

  private String chqDt;

  private String chqNo;

  private String sms1;

  private String sms2;

  private String email1;

  private String email2;

  private String cardNo;

  private String approvalNo;

  private String crcName;

  private String transactionDate;

  private String expiryDate;

  private String cardMode;

  private String merchantBank;

  private String cardBrand;

  /* PSM Attachment Update */
  private int atchFileSvmF;

  private int atchFileSvmTnc;

  private int atchFilePo;

  private int atchFileNricCrcF;

  private int atchFileNricCrcB;

  private int atchFileTrxSlip;

  private int atchFileChqImg;

  private int atchFileOther1;

  private int atchFileOther2;

  private int atchFileOther3;

  private int curAtchFileGrpId;
  // CELESTE

  // private Boolean svmAllowFlg;
  private int errorCode;

  private String errorHeader;

  private String errorMsg;

  // CELESTE
  private String userNm;

  public String getFlag() {
    return flag;
  }

  public void setFlag( String flag ) {
    this.flag = flag;
  }

  public String getMode() {
    return mode;
  }

  public void setMode( String mode ) {
    this.mode = mode;
  }

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

  public String getReqstDtFrom() {
    return reqstDtFrom;
  }

  public void setReqstDtFrom( String reqstDtFrom ) {
    this.reqstDtFrom = reqstDtFrom;
  }

  public String getReqstDtTo() {
    return reqstDtTo;
  }

  public void setReqstDtTo( String reqstDtTo ) {
    this.reqstDtTo = reqstDtTo;
  }

  public String getSelectType() {
    return selectType;
  }

  public void setSelectType( String selectType ) {
    this.selectType = selectType;
  }

  public String getSelectKeyword() {
    return selectKeyword;
  }

  public void setSelectKeyword( String selectKeyword ) {
    this.selectKeyword = selectKeyword;
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

  public String getAddress() {
    return address;
  }

  public void setAddress( String address ) {
    this.address = address;
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

  public String getTrm() {
    return trm;
  }

  public void setTrm( String trm ) {
    this.trm = trm;
  }

  public String getHiddenIsCharge() {
    return hiddenIsCharge;
  }

  public void setHiddenIsCharge( String hiddenIsCharge ) {
    this.hiddenIsCharge = hiddenIsCharge;
  }

  public String getHiddenHasFilterCharge() {
    return hiddenHasFilterCharge;
  }

  public void setHiddenHasFilterCharge( String hiddenHasFilterCharge ) {
    this.hiddenHasFilterCharge = hiddenHasFilterCharge;
  }

  public String getEmployee() {
    return employee;
  }

  public void setEmployee( String employee ) {
    this.employee = employee;
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

  public String getSrvFilterStusId() {
    return srvFilterStusId;
  }

  public void setSrvFilterStusId( String srvFilterStusId ) {
    this.srvFilterStusId = srvFilterStusId;
  }

  public String getSrvFilterPrvChgDt() {
    return srvFilterPrvChgDt;
  }

  public void setSrvFilterPrvChgDt( String srvFilterPrvChgDt ) {
    this.srvFilterPrvChgDt = srvFilterPrvChgDt;
  }

  public String getSrvFilterPriod() {
    return srvFilterPriod;
  }

  public void setSrvFilterPriod( String srvFilterPriod ) {
    this.srvFilterPriod = srvFilterPriod;
  }

  public String getCode() {
    return code;
  }

  public void setCode( String code ) {
    this.code = code;
  }

  public String getC5() {
    return c5;
  }

  public void setC5( String c5 ) {
    this.c5 = c5;
  }

  public String getC6() {
    return c6;
  }

  public void setC6( String c6 ) {
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
    this.trm = todaydateint;
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

  public int getSubYear() {
    return subYear;
  }

  public void setSubYear( int subYear ) {
    this.subYear = subYear;
  }

  public int getPromoId() {
    return promoId;
  }

  public void setPromoId( int promoId ) {
    this.promoId = promoId;
  }

  public String getGroupCode() {
    return groupCode;
  }

  public void setGroupCode( String groupCode ) {
    this.groupCode = groupCode;
  }

  public String getCodeName() {
    return codeName;
  }

  public void setCodeName( String codeName ) {
    this.codeName = codeName;
  }

  public String getSrvMemQuotId() {
    return srvMemQuotId;
  }

  public void setSrvMemQuotId( String srvMemQuotId ) {
    this.srvMemQuotId = srvMemQuotId;
  }

  public String getSrvSalesOrderId() {
    return srvSalesOrderId;
  }

  public void setSrvSalesOrderId( String srvSalesOrderId ) {
    this.srvSalesOrderId = srvSalesOrderId;
  }

  public String getSrvMemQuotNo() {
    return srvMemQuotNo;
  }

  public void setSrvMemQuotNo( String srvMemQuotNo ) {
    this.srvMemQuotNo = srvMemQuotNo;
  }

  public String getSrvMemPacId() {
    return srvMemPacId;
  }

  public void setSrvMemPacId( String srvMemPacId ) {
    this.srvMemPacId = srvMemPacId;
  }

  public String getSrvMemPacAmt() {
    return srvMemPacAmt;
  }

  public void setSrvMemPacAmt( String srvMemPacAmt ) {
    this.srvMemPacAmt = srvMemPacAmt;
  }

  public String getSrvMemPacNetAmt() {
    return srvMemPacNetAmt;
  }

  public void setSrvMemPacNetAmt( String srvMemPacNetAmt ) {
    this.srvMemPacNetAmt = srvMemPacNetAmt;
  }

  public String getSrvMemBSAmt() {
    return srvMemBSAmt;
  }

  public void setSrvMemBSAmt( String srvMemBSAmt ) {
    this.srvMemBSAmt = srvMemBSAmt;
  }

  public String getSrvMemBSNetAmt() {
    return srvMemBSNetAmt;
  }

  public void setSrvMemBSNetAmt( String srvMemBSNetAmt ) {
    this.srvMemBSNetAmt = srvMemBSNetAmt;
  }

  public String getSrvMemPv() {
    return srvMemPv;
  }

  public void setSrvMemPv( String srvMemPv ) {
    this.srvMemPv = srvMemPv;
  }

  public String getSrvDuration() {
    return srvDuration;
  }

  public void setSrvDuration( String srvDuration ) {
    this.srvDuration = srvDuration;
  }

  public String getSrvRemark() {
    return srvRemark;
  }

  public void setSrvRemark( String srvRemark ) {
    this.srvRemark = srvRemark;
  }

  public String getSrvQuotStatusId() {
    return srvQuotStatusId;
  }

  public void setSrvQuotStatusId( String srvQuotStatusId ) {
    this.srvQuotStatusId = srvQuotStatusId;
  }

  public String getSrvMemBS12Amt() {
    return srvMemBS12Amt;
  }

  public void setSrvMemBS12Amt( String srvMemBS12Amt ) {
    this.srvMemBS12Amt = srvMemBS12Amt;
  }

  public String getSrvPacPromoId() {
    return srvPacPromoId;
  }

  public void setSrvPacPromoId( String srvPacPromoId ) {
    this.srvPacPromoId = srvPacPromoId;
  }

  public String getSrvPromoId() {
    return srvPromoId;
  }

  public void setSrvPromoId( String srvPromoId ) {
    this.srvPromoId = srvPromoId;
  }

  public String getSrvQuotCustCntId() {
    return srvQuotCustCntId;
  }

  public void setSrvQuotCustCntId( String srvQuotCustCntId ) {
    this.srvQuotCustCntId = srvQuotCustCntId;
  }

  public String getSrvMemQty() {
    return srvMemQty;
  }

  public void setSrvMemQty( String srvMemQty ) {
    this.srvMemQty = srvMemQty;
  }

  public String getSrvSalesMemId() {
    return srvSalesMemId;
  }

  public void setSrvSalesMemId( String srvSalesMemId ) {
    this.srvSalesMemId = srvSalesMemId;
  }

  public String getSrvMemId() {
    return srvMemId;
  }

  public void setSrvMemId( String srvMemId ) {
    this.srvMemId = srvMemId;
  }

  public String getSrvOrderStkId() {
    return srvOrderStkId;
  }

  public void setSrvOrderStkId( String srvOrderStkId ) {
    this.srvOrderStkId = srvOrderStkId;
  }

  public String getSrvFreq() {
    return srvFreq;
  }

  public void setSrvFreq( String srvFreq ) {
    this.srvFreq = srvFreq;
  }

  public String getEmpChk() {
    return empChk;
  }

  public void setEmpChk( String empChk ) {
    this.empChk = empChk;
  }

  public String getIsFilterCharge() {
    return isFilterCharge;
  }

  public void setIsFilterCharge( String isFilterCharge ) {
    this.isFilterCharge = isFilterCharge;
  }

  public String getSrvMemPacTaxes() {
    return srvMemPacTaxes;
  }

  public void setSrvMemPacTaxes( String srvMemPacTaxes ) {
    this.srvMemPacTaxes = srvMemPacTaxes;
  }

  public String getSrvMemBSTaxes() {
    return srvMemBSTaxes;
  }

  public void setSrvMemBSTaxes( String srvMemBSTaxes ) {
    this.srvMemBSTaxes = srvMemBSTaxes;
  }

  public String getSal93Seq() {
    return sal93Seq;
  }

  public void setSal93Seq( String sal93Seq ) {
    this.sal93Seq = sal93Seq;
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

  // public eSVMApiDto getSaveData() {
  // return saveData;
  // }
  //
  // public void setSaveData(eSVMApiDto saveData) {
  // this.saveData = saveData;
  // }
  public int getPayMode() {
    return payMode;
  }

  public void setPayMode( int payMode ) {
    this.payMode = payMode;
  }

  public BigDecimal getOtstndAmt() {
    return otstndAmt;
  }

  public void setOtstndAmt( BigDecimal otstndAmt ) {
    this.otstndAmt = otstndAmt;
  }

  public BigDecimal getPayAmt() {
    return payAmt;
  }

  public void setPayAmt( BigDecimal payAmt ) {
    this.payAmt = payAmt;
  }

  public String getSlipNo() {
    return slipNo;
  }

  public void setSlipNo( String slipNo ) {
    this.slipNo = slipNo;
  }

  public int getIssuBankId() {
    return issuBankId;
  }

  public void setIssuBankId( int issuBankId ) {
    this.issuBankId = issuBankId;
  }

  public String getChqDt() {
    return chqDt;
  }

  public void setChqDt( String chqDt ) {
    this.chqDt = chqDt;
  }

  public String getChqNo() {
    return chqNo;
  }

  public void setChqNo( String chqNo ) {
    this.chqNo = chqNo;
  }

  public String getSms1() {
    return sms1;
  }

  public void setSms1( String sms1 ) {
    this.sms1 = sms1;
  }

  public String getSms2() {
    return sms2;
  }

  public void setSms2( String sms2 ) {
    this.sms2 = sms2;
  }

  public String getEmail1() {
    return email1;
  }

  public void setEmail1( String email1 ) {
    this.email1 = email1;
  }

  public String getEmail2() {
    return email2;
  }

  public void setEmail2( String email2 ) {
    this.email2 = email2;
  }

  public String getCardNo() {
    return cardNo;
  }

  public void setCardNo( String cardNo ) {
    this.cardNo = cardNo;
  }

  public String getApprovalNo() {
    return approvalNo;
  }

  public void setApprovalNo( String approvalNo ) {
    this.approvalNo = approvalNo;
  }

  public String getCrcName() {
    return crcName;
  }

  public void setCrcName( String crcName ) {
    this.crcName = crcName;
  }

  public String getTransactionDate() {
    return transactionDate;
  }

  public void setTransactionDate( String transactionDate ) {
    this.transactionDate = transactionDate;
  }

  public String getExpiryDate() {
    return expiryDate;
  }

  public void setExpiryDate( String expiryDate ) {
    this.expiryDate = expiryDate;
  }

  public String getCardMode() {
    return cardMode;
  }

  public void setCardMode( String cardMode ) {
    this.cardMode = cardMode;
  }

  public String getMerchantBank() {
    return merchantBank;
  }

  public void setMerchantBank( String merchantBank ) {
    this.merchantBank = merchantBank;
  }

  public String getCardBrand() {
    return cardBrand;
  }

  public void setCardBrand( String cardBrand ) {
    this.cardBrand = cardBrand;
  }

  public int getAtchFileSvmF() {
    return atchFileSvmF;
  }

  public void setAtchFileSvmF( int atchFileSvmF ) {
    this.atchFileSvmF = atchFileSvmF;
  }

  public int getAtchFileSvmTnc() {
    return atchFileSvmTnc;
  }

  public void setAtchFileSvmTnc( int atchFileSvmTnc ) {
    this.atchFileSvmTnc = atchFileSvmTnc;
  }

  public int getAtchFilePo() {
    return atchFilePo;
  }

  public void setAtchFilePo( int atchFilePo ) {
    this.atchFilePo = atchFilePo;
  }

  public int getAtchFileNricCrcF() {
    return atchFileNricCrcF;
  }

  public void setAtchFileNricCrcF( int atchFileNricCrcF ) {
    this.atchFileNricCrcF = atchFileNricCrcF;
  }

  public int getAtchFileNricCrcB() {
    return atchFileNricCrcB;
  }

  public void setAtchFileNricCrcB( int atchFileNricCrcB ) {
    this.atchFileNricCrcB = atchFileNricCrcB;
  }

  public int getAtchFileTrxSlip() {
    return atchFileTrxSlip;
  }

  public void setAtchFileTrxSlip( int atchFileTrxSlip ) {
    this.atchFileTrxSlip = atchFileTrxSlip;
  }

  public int getAtchFileChqImg() {
    return atchFileChqImg;
  }

  public void setAtchFileChqImg( int atchFileChqImg ) {
    this.atchFileChqImg = atchFileChqImg;
  }

  public int getAtchFileOther1() {
    return atchFileOther1;
  }

  public void setAtchFileOther1( int atchFileOther1 ) {
    this.atchFileOther1 = atchFileOther1;
  }

  public int getAtchFileOther2() {
    return atchFileOther2;
  }

  public void setAtchFileOther2( int atchFileOther2 ) {
    this.atchFileOther2 = atchFileOther2;
  }

  public int getAtchFileOther3() {
    return atchFileOther3;
  }

  public void setAtchFileOther3( int atchFileOther3 ) {
    this.atchFileOther3 = atchFileOther3;
  }

  public int getCurAtchFileGrpId() {
    return curAtchFileGrpId;
  }

  public void setCurAtchFileGrpId( int curAtchFileGrpId ) {
    this.curAtchFileGrpId = curAtchFileGrpId;
  }

  public int getProgressStatus() {
    return progressStatus;
  }

  public void setProgressStatus( int progressStatus ) {
    this.progressStatus = progressStatus;
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

  public String getUserNm() {
    return userNm;
  }

  public void setUserNm( String userNm ) {
    this.userNm = userNm;
  }

  public int getCustTypeId() {
    return custTypeId;
  }

  public void setCustTypeId( int custTypeId ) {
    this.custTypeId = custTypeId;
  }

  public String getTaxRate() {
    return taxRate;
  }

  public void setTaxRate( String taxRate ) {
    this.taxRate = taxRate;
  }
}
