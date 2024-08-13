package com.coway.trust.api.mobile.sales.eKeyInApi;

import java.math.BigDecimal;
import java.util.List;

import com.coway.trust.util.BeanConverter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

/**
 * @ClassName : EKeyInApiDto.java
 * @Description : TO-DO Class Description
 *
 *
 *
 * @History
 *
 *          <pre>
 *          Date Author Description
 *          ------------- ----------- -------------
 *          2019. 12. 09. KR-JAEMJAEM:) First creation
 *          2020. 03. 23. MY-ONGHC Amend custCrcExprMM and custCrcExprYYYY from INT to STRING
 *          2020. 04. 08. MY-ONGHC Add cpntList for component
 *          Add promoByCpntIdList
 *          2020. 09. 01. MY-ONGHC Add Billing Address Getter and Setter
 *          </pre>
 */
@ApiModel(value = "EKeyInApiDto", description = "EKeyInApiDto")
@JsonIgnoreProperties(ignoreUnknown = true)
public class EKeyInApiDto {

  @SuppressWarnings("unchecked")
  public static EKeyInApiDto create(EgovMap egvoMap) {
    return BeanConverter.toBean(egvoMap, EKeyInApiDto.class);
  }

  private List<EKeyInApiDto> codeList;
  private List<EKeyInApiDto> bankList;
  private List<EKeyInApiDto> productList;
  private List<EKeyInApiDto> promotionList;
  private List<EKeyInApiDto> packTypeList;
  private List<EgovMap> cpntList;
  private List<EgovMap> promoByCpntIdList;
  private EKeyInApiDto saveData;
  private EKeyInApiDto basic;
  private EKeyInApiDto homecare;
  private EKeyInApiDto mattress;
  private EKeyInApiDto frame;
  private List<EKeyInApiDto> mattressProductList;
  private List<EKeyInApiDto> frameProductList;
  private List<EKeyInApiDto> attachment;
  private EKeyInApiDto selectAnotherContactMain;
  private EKeyInApiDto selectAnotherAddressMain;
  private int custId;
  private String custName;
  private String hcGu;
  private String sofNo;
  private String reqstDt;
  private int stusId;
  private String stusName;
  private String stkDesc;
  private int preOrdId;
  private String rem1;
  private String rem2;
  private int codeMasterId;
  private int codeId;
  private String code;
  private String codeName;
  private String codeDesc;
  private int bankId;
  private int typeId;
  private String typeIdName;
  private String nric;
  private String initials;
  private String companyType;
  private String dob;
  private String gender;
  private String nation;
  private String race;
  private String pasSportExpr;
  private String visaExpr;
  private int receivingMarketingMsgStatus;
  private String name;
  private String telM1;
  private String telR;
  private String telO;
  private String telf;
  private String email;
  private String ext;
  private int appTypeId;
  private int srvPacId;
  private int instPriod;
  private String srvPacName;
  private int itmStkId;
  private int promoId;
  private BigDecimal totAmt;
  private BigDecimal norAmt;
  private BigDecimal mthRentAmt;
  private BigDecimal totPv;
  private BigDecimal totPvGst;
  private String instct;
  private String yyyy;
  private String mm;
  private int empChk;
  private int exTrade;
  private int stkId;
  private String c1;
  private int discontinue;
  private String promoDesc;
  private String promoDtFrom;
  private String addrDtl;
  private String street;
  private String area;
  private String city;
  private String postcode;
  private String state;
  private String country;
  private String addrDtlBilling;
  private String streetBilling;
  private String areaBilling;
  private String cityBilling;
  private String postcodeBilling;
  private String stateBilling;
  private String countryBilling;
  private String dscBrnch;
  private String postingBrnch;
  private String hdcBrnch;
  private int rentPayModeId;
  private String custOriCrcNo;
  private int custCrcTypeId;
  private String custCrcOwner;
  private String custCrcExpr;
  private int custCrcBankId;
  private int cardTypeId;
  private int matPreOrdId;
  private int fraPreOrdId;
  private int stkCtgryId;
  private int custCntcId;
  private int custInitial;
  private String pos;
  private String telM2;
  private int raceId;
  private int stusCodeId;
  private int idOld;
  private String dept;
  private int dcm;
  private String stusCodeIdName;
  private String regId;
  private int prcId;
  private BigDecimal amt;
  private BigDecimal monthlyRental;
  private BigDecimal prcRpf;
  private BigDecimal prcPv;
  private BigDecimal tradeInPv;
  private BigDecimal prcCosting;
  private BigDecimal orderPricePromo;
  private BigDecimal ordPvGST;
  private BigDecimal orderRentalFeesPromo;
  private BigDecimal promoDiscPeriodTp;
  private BigDecimal promoDiscPeriod;
  private BigDecimal normalPricePromo;
  private BigDecimal discRntFee;
  private int promoItmId;
  private int promoItmStkId;
  private int stkCode;
  private int promoItmCurId;
  private BigDecimal promoItmPrc;
  private BigDecimal promoAmt;
  private BigDecimal promoPrcRpf;
  private BigDecimal promoItmPv;
  private BigDecimal promoItmPvGst;
  private int promoAppTypeId;
  private int custAddId;
  private int custAddBillingId;
  private String fullAddr;
  private String areaId;
  private String rem;
  private int custCrcId;
  private String cardTypeIdName;
  private String paramVal;
  private int tknId;
  private String etyPoint;
  private String refNo;
  private String tknzUrl;
  private String tknzMerchantId;
  private String tknzVerfKey;
  private String pan;
  private String expyear;
  private String expmonth;
  private String urlReq;
  private String merchantId;
  private String signature;
  private String custCrcExprMM;
  private String custCrcExprYYYY;
  private String custCrcRem;
  private String crcCheck;
  private String errorDesc;
  private String crcNo;
  private String token;
  private String stus;
  private int memId;
  private String memCode;
  private BigDecimal targetTot;
  private BigDecimal collectTot;
  private BigDecimal rcPrct;
  private int opCnt;
  private int flg6Month;
  private int cnt;
  private String userId;
  private int dscBrnchId;
  private int postingBrnchId;
  private int hdcBrnchId;
  private int keyinBrnchId;
  private int instAddId;
  private int rentPayCustId;
  private int custBillCustId;
  private int custBillCntId;
  private int custBillAddId;
  private String custBillEmail;
  private String orderType;
  private int atchFileGrpId;
  private String subPath;
  private String fileKeySeq;
  private int crtUserId;
  private int updUserId;
  private int atchFileId;
  private String atchFileName;
  private String fileSubPath;
  private String physiclFileName;
  private String fileExtsn;
  private String saveFlag;
  private int updateAtchFileGrpId;
  private int atchFileIdSales;
  private int atchFileIdNric;
  private int atchFileIdPayment;
  private int atchFileIdTemporary;
  private int atchFileIdoOthersform;
  private int atchFileIdoOthersform2;
  private int ordSeqNo;
  private String promoDt;
  private String gu;
  private String cpntCode;
  private String cpntCodeName;
  private BigDecimal quotaStus;
  private int isHcAcInstallationFlag;
  private String acBrnch;
  private int acBrnchId;
  private int custCrcTokenIdStus;
  private int Is3rdParty;
  private int voucherValid;
  private String voucherCode;
  private int voucherType;
  private String voucherEmail;
  private String customerStatusCode;
  private String customerStatus;
  private String srvType;


  public List<EKeyInApiDto> getCodeList() {
    return codeList;
  }

  public void setCodeList(List<EKeyInApiDto> codeList) {
    this.codeList = codeList;
  }

  public List<EKeyInApiDto> getBankList() {
    return bankList;
  }

  public void setBankList(List<EKeyInApiDto> bankList) {
    this.bankList = bankList;
  }

  public List<EKeyInApiDto> getProductList() {
    return productList;
  }

  public void setProductList(List<EKeyInApiDto> productList) {
    this.productList = productList;
  }

  public List<EKeyInApiDto> getPromotionList() {
    return promotionList;
  }

  public void setPromotionList(List<EKeyInApiDto> promotionList) {
    this.promotionList = promotionList;
  }

  public List<EKeyInApiDto> getPackTypeList() {
    return packTypeList;
  }

  public void setPackTypeList(List<EKeyInApiDto> packTypeList) {
    this.packTypeList = packTypeList;
  }

  public List<EgovMap> getCpntList() {
    return cpntList;
  }

  public void setCpntList(List<EgovMap> cpntList) {
    this.cpntList = cpntList;
  }

  public List<EgovMap> getPromoByCpntIdList() {
    return promoByCpntIdList;
  }

  public void setPromoByCpntIdList(List<EgovMap> promoByCpntIdList) {
    this.promoByCpntIdList = promoByCpntIdList;
  }

  public EKeyInApiDto getSaveData() {
    return saveData;
  }

  public void setSaveData(EKeyInApiDto saveData) {
    this.saveData = saveData;
  }

  public EKeyInApiDto getBasic() {
    return basic;
  }

  public void setBasic(EKeyInApiDto basic) {
    this.basic = basic;
  }

  public EKeyInApiDto getHomecare() {
    return homecare;
  }

  public void setHomecare(EKeyInApiDto homecare) {
    this.homecare = homecare;
  }

  public EKeyInApiDto getMattress() {
    return mattress;
  }

  public void setMattress(EKeyInApiDto mattress) {
    this.mattress = mattress;
  }

  public EKeyInApiDto getFrame() {
    return frame;
  }

  public void setFrame(EKeyInApiDto frame) {
    this.frame = frame;
  }

  public List<EKeyInApiDto> getMattressProductList() {
    return mattressProductList;
  }

  public void setMattressProductList(List<EKeyInApiDto> mattressProductList) {
    this.mattressProductList = mattressProductList;
  }

  public List<EKeyInApiDto> getFrameProductList() {
    return frameProductList;
  }

  public void setFrameProductList(List<EKeyInApiDto> frameProductList) {
    this.frameProductList = frameProductList;
  }

  public List<EKeyInApiDto> getAttachment() {
    return attachment;
  }

  public void setAttachment(List<EKeyInApiDto> attachment) {
    this.attachment = attachment;
  }

  public EKeyInApiDto getSelectAnotherContactMain() {
    return selectAnotherContactMain;
  }

  public void setSelectAnotherContactMain(EKeyInApiDto selectAnotherContactMain) {
    this.selectAnotherContactMain = selectAnotherContactMain;
  }

  public EKeyInApiDto getSelectAnotherAddressMain() {
    return selectAnotherAddressMain;
  }

  public void setSelectAnotherAddressMain(EKeyInApiDto selectAnotherAddressMain) {
    this.selectAnotherAddressMain = selectAnotherAddressMain;
  }

  public int getCustId() {
    return custId;
  }

  public void setCustId(int custId) {
    this.custId = custId;
  }

  public String getCustName() {
    return custName;
  }

  public void setCustName(String custName) {
    this.custName = custName;
  }

  public String getHcGu() {
    return hcGu;
  }

  public void setHcGu(String hcGu) {
    this.hcGu = hcGu;
  }

  public String getSofNo() {
    return sofNo;
  }

  public void setSofNo(String sofNo) {
    this.sofNo = sofNo;
  }

  public String getReqstDt() {
    return reqstDt;
  }

  public void setReqstDt(String reqstDt) {
    this.reqstDt = reqstDt;
  }

  public int getStusId() {
    return stusId;
  }

  public void setStusId(int stusId) {
    this.stusId = stusId;
  }

  public String getStusName() {
    return stusName;
  }

  public void setStusName(String stusName) {
    this.stusName = stusName;
  }

  public String getStkDesc() {
    return stkDesc;
  }

  public void setStkDesc(String stkDesc) {
    this.stkDesc = stkDesc;
  }

  public int getPreOrdId() {
    return preOrdId;
  }

  public void setPreOrdId(int preOrdId) {
    this.preOrdId = preOrdId;
  }

  public String getRem1() {
    return rem1;
  }

  public void setRem1(String rem1) {
    this.rem1 = rem1;
  }

  public String getRem2() {
    return rem2;
  }

  public void setRem2(String rem2) {
    this.rem2 = rem2;
  }

  public int getCodeMasterId() {
    return codeMasterId;
  }

  public void setCodeMasterId(int codeMasterId) {
    this.codeMasterId = codeMasterId;
  }

  public int getCodeId() {
    return codeId;
  }

  public void setCodeId(int codeId) {
    this.codeId = codeId;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getCodeName() {
    return codeName;
  }

  public void setCodeName(String codeName) {
    this.codeName = codeName;
  }

  public String getCodeDesc() {
    return codeDesc;
  }

  public void setCodeDesc(String codeDesc) {
    this.codeDesc = codeDesc;
  }

  public int getBankId() {
    return bankId;
  }

  public void setBankId(int bankId) {
    this.bankId = bankId;
  }

  public int getTypeId() {
    return typeId;
  }

  public void setTypeId(int typeId) {
    this.typeId = typeId;
  }

  public String getTypeIdName() {
    return typeIdName;
  }

  public void setTypeIdName(String typeIdName) {
    this.typeIdName = typeIdName;
  }

  public String getNric() {
    return nric;
  }

  public void setNric(String nric) {
    this.nric = nric;
  }

  public String getInitials() {
    return initials;
  }

  public void setInitials(String initials) {
    this.initials = initials;
  }

  public String getCompanyType() {
    return companyType;
  }

  public void setCompanyType(String companyType) {
    this.companyType = companyType;
  }

  public String getDob() {
    return dob;
  }

  public void setDob(String dob) {
    this.dob = dob;
  }

  public String getGender() {
    return gender;
  }

  public void setGender(String gender) {
    this.gender = gender;
  }

  public String getNation() {
    return nation;
  }

  public void setNation(String nation) {
    this.nation = nation;
  }

  public String getRace() {
    return race;
  }

  public void setRace(String race) {
    this.race = race;
  }

  public String getPasSportExpr() {
    return pasSportExpr;
  }

  public void setPasSportExpr(String pasSportExpr) {
    this.pasSportExpr = pasSportExpr;
  }

  public String getVisaExpr() {
    return visaExpr;
  }

  public void setVisaExpr(String visaExpr) {
    this.visaExpr = visaExpr;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getTelM1() {
    return telM1;
  }

  public void setTelM1(String telM1) {
    this.telM1 = telM1;
  }

  public String getTelR() {
    return telR;
  }

  public void setTelR(String telR) {
    this.telR = telR;
  }

  public String getTelO() {
    return telO;
  }

  public void setTelO(String telO) {
    this.telO = telO;
  }

  public String getTelf() {
    return telf;
  }

  public void setTelf(String telf) {
    this.telf = telf;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail(String email) {
    this.email = email;
  }

  public String getExt() {
    return ext;
  }

  public void setExt(String ext) {
    this.ext = ext;
  }

  public int getAppTypeId() {
    return appTypeId;
  }

  public void setAppTypeId(int appTypeId) {
    this.appTypeId = appTypeId;
  }

  public int getSrvPacId() {
    return srvPacId;
  }

  public void setSrvPacId(int srvPacId) {
    this.srvPacId = srvPacId;
  }

  public int getInstPriod() {
    return instPriod;
  }

  public void setInstPriod(int instPriod) {
    this.instPriod = instPriod;
  }

  public String getSrvPacName() {
    return srvPacName;
  }

  public void setSrvPacName(String srvPacName) {
    this.srvPacName = srvPacName;
  }

  public int getItmStkId() {
    return itmStkId;
  }

  public void setItmStkId(int itmStkId) {
    this.itmStkId = itmStkId;
  }

  public int getPromoId() {
    return promoId;
  }

  public void setPromoId(int promoId) {
    this.promoId = promoId;
  }

  public BigDecimal getTotAmt() {
    return totAmt;
  }

  public void setTotAmt(BigDecimal totAmt) {
    this.totAmt = totAmt;
  }

  public BigDecimal getNorAmt() {
    return norAmt;
  }

  public void setNorAmt(BigDecimal norAmt) {
    this.norAmt = norAmt;
  }

  public BigDecimal getMthRentAmt() {
    return mthRentAmt;
  }

  public void setMthRentAmt(BigDecimal mthRentAmt) {
    this.mthRentAmt = mthRentAmt;
  }

  public BigDecimal getTotPv() {
    return totPv;
  }

  public void setTotPv(BigDecimal totPv) {
    this.totPv = totPv;
  }

  public BigDecimal getTotPvGst() {
    return totPvGst;
  }

  public void setTotPvGst(BigDecimal totPvGst) {
    this.totPvGst = totPvGst;
  }

  public String getInstct() {
    return instct;
  }

  public void setInstct(String instct) {
    this.instct = instct;
  }

  public String getYyyy() {
    return yyyy;
  }

  public void setYyyy(String yyyy) {
    this.yyyy = yyyy;
  }

  public String getMm() {
    return mm;
  }

  public void setMm(String mm) {
    this.mm = mm;
  }

  public int getEmpChk() {
    return empChk;
  }

  public void setEmpChk(int empChk) {
    this.empChk = empChk;
  }

  public int getExTrade() {
    return exTrade;
  }

  public void setExTrade(int exTrade) {
    this.exTrade = exTrade;
  }

  public int getStkId() {
    return stkId;
  }

  public void setStkId(int stkId) {
    this.stkId = stkId;
  }

  public String getC1() {
    return c1;
  }

  public void setC1(String c1) {
    this.c1 = c1;
  }

  public int getDiscontinue() {
    return discontinue;
  }

  public void setDiscontinue(int discontinue) {
    this.discontinue = discontinue;
  }

  public String getPromoDesc() {
    return promoDesc;
  }

  public void setPromoDesc(String promoDesc) {
    this.promoDesc = promoDesc;
  }

  public String getPromoDtFrom() {
    return promoDtFrom;
  }

  public void setPromoDtFrom(String promoDtFrom) {
    this.promoDtFrom = promoDtFrom;
  }

  public String getAddrDtl() {
    return addrDtl;
  }

  public void setAddrDtl(String addrDtl) {
    this.addrDtl = addrDtl;
  }

  public String getStreet() {
    return street;
  }

  public void setStreet(String street) {
    this.street = street;
  }

  public String getArea() {
    return area;
  }

  public void setArea(String area) {
    this.area = area;
  }

  public String getCity() {
    return city;
  }

  public void setCity(String city) {
    this.city = city;
  }

  public String getPostcode() {
    return postcode;
  }

  public void setPostcode(String postcode) {
    this.postcode = postcode;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public String getCountry() {
    return country;
  }

  public void setCountry(String country) {
    this.country = country;
  }

  public String getAddrDtlBilling() {
    return addrDtlBilling;
  }

  public void setAddrDtlBilling(String addrDtlBilling) {
    this.addrDtlBilling = addrDtlBilling;
  }

  public String getStreetBilling() {
    return streetBilling;
  }

  public void setStreetBilling(String streetBilling) {
    this.streetBilling = streetBilling;
  }

  public String getAreaBilling() {
    return areaBilling;
  }

  public void setAreaBilling(String areaBilling) {
    this.areaBilling = areaBilling;
  }

  public String getCityBilling() {
    return cityBilling;
  }

  public void setCityBilling(String cityBilling) {
    this.cityBilling = cityBilling;
  }

  public String getPostcodeBilling() {
    return postcodeBilling;
  }

  public void setPostcodeBilling(String postcodeBilling) {
    this.postcodeBilling = postcodeBilling;
  }

  public String getStateBilling() {
    return stateBilling;
  }

  public void setStateBilling(String stateBilling) {
    this.stateBilling = stateBilling;
  }

  public String getCountryBilling() {
    return countryBilling;
  }

  public void setCountryBilling(String countryBilling) {
    this.countryBilling = countryBilling;
  }

  public String getDscBrnch() {
    return dscBrnch;
  }

  public void setDscBrnch(String dscBrnch) {
    this.dscBrnch = dscBrnch;
  }

  public String getPostingBrnch() {
    return postingBrnch;
  }

  public void setPostingBrnch(String postingBrnch) {
    this.postingBrnch = postingBrnch;
  }

  public String getHdcBrnch() {
    return hdcBrnch;
  }

  public void setHdcBrnch(String hdcBrnch) {
    this.hdcBrnch = hdcBrnch;
  }

  public int getRentPayModeId() {
    return rentPayModeId;
  }

  public void setRentPayModeId(int rentPayModeId) {
    this.rentPayModeId = rentPayModeId;
  }

  public String getCustOriCrcNo() {
    return custOriCrcNo;
  }

  public void setCustOriCrcNo(String custOriCrcNo) {
    this.custOriCrcNo = custOriCrcNo;
  }

  public int getCustCrcTypeId() {
    return custCrcTypeId;
  }

  public void setCustCrcTypeId(int custCrcTypeId) {
    this.custCrcTypeId = custCrcTypeId;
  }

  public String getCustCrcOwner() {
    return custCrcOwner;
  }

  public void setCustCrcOwner(String custCrcOwner) {
    this.custCrcOwner = custCrcOwner;
  }

  public String getCustCrcExpr() {
    return custCrcExpr;
  }

  public void setCustCrcExpr(String custCrcExpr) {
    this.custCrcExpr = custCrcExpr;
  }

  public int getCustCrcBankId() {
    return custCrcBankId;
  }

  public void setCustCrcBankId(int custCrcBankId) {
    this.custCrcBankId = custCrcBankId;
  }

  public int getCardTypeId() {
    return cardTypeId;
  }

  public void setCardTypeId(int cardTypeId) {
    this.cardTypeId = cardTypeId;
  }

  public int getMatPreOrdId() {
    return matPreOrdId;
  }

  public void setMatPreOrdId(int matPreOrdId) {
    this.matPreOrdId = matPreOrdId;
  }

  public int getFraPreOrdId() {
    return fraPreOrdId;
  }

  public void setFraPreOrdId(int fraPreOrdId) {
    this.fraPreOrdId = fraPreOrdId;
  }

  public int getStkCtgryId() {
    return stkCtgryId;
  }

  public void setStkCtgryId(int stkCtgryId) {
    this.stkCtgryId = stkCtgryId;
  }

  public int getCustCntcId() {
    return custCntcId;
  }

  public void setCustCntcId(int custCntcId) {
    this.custCntcId = custCntcId;
  }

  public int getCustInitial() {
    return custInitial;
  }

  public void setCustInitial(int custInitial) {
    this.custInitial = custInitial;
  }

  public String getPos() {
    return pos;
  }

  public void setPos(String pos) {
    this.pos = pos;
  }

  public String getTelM2() {
    return telM2;
  }

  public void setTelM2(String telM2) {
    this.telM2 = telM2;
  }

  public int getRaceId() {
    return raceId;
  }

  public void setRaceId(int raceId) {
    this.raceId = raceId;
  }

  public int getStusCodeId() {
    return stusCodeId;
  }

  public void setStusCodeId(int stusCodeId) {
    this.stusCodeId = stusCodeId;
  }

  public int getIdOld() {
    return idOld;
  }

  public void setIdOld(int idOld) {
    this.idOld = idOld;
  }

  public String getDept() {
    return dept;
  }

  public void setDept(String dept) {
    this.dept = dept;
  }

  public int getDcm() {
    return dcm;
  }

  public void setDcm(int dcm) {
    this.dcm = dcm;
  }

  public String getStusCodeIdName() {
    return stusCodeIdName;
  }

  public void setStusCodeIdName(String stusCodeIdName) {
    this.stusCodeIdName = stusCodeIdName;
  }

  public String getRegId() {
    return regId;
  }

  public void setRegId(String regId) {
    this.regId = regId;
  }

  public int getPrcId() {
    return prcId;
  }

  public void setPrcId(int prcId) {
    this.prcId = prcId;
  }

  public BigDecimal getAmt() {
    return amt;
  }

  public void setAmt(BigDecimal amt) {
    this.amt = amt;
  }

  public BigDecimal getMonthlyRental() {
    return monthlyRental;
  }

  public void setMonthlyRental(BigDecimal monthlyRental) {
    this.monthlyRental = monthlyRental;
  }

  public BigDecimal getPrcRpf() {
    return prcRpf;
  }

  public void setPrcRpf(BigDecimal prcRpf) {
    this.prcRpf = prcRpf;
  }

  public BigDecimal getPrcPv() {
    return prcPv;
  }

  public void setPrcPv(BigDecimal prcPv) {
    this.prcPv = prcPv;
  }

  public BigDecimal getTradeInPv() {
    return tradeInPv;
  }

  public void setTradeInPv(BigDecimal tradeInPv) {
    this.tradeInPv = tradeInPv;
  }

  public BigDecimal getPrcCosting() {
    return prcCosting;
  }

  public void setPrcCosting(BigDecimal prcCosting) {
    this.prcCosting = prcCosting;
  }

  public BigDecimal getOrderPricePromo() {
    return orderPricePromo;
  }

  public void setOrderPricePromo(BigDecimal orderPricePromo) {
    this.orderPricePromo = orderPricePromo;
  }

  public BigDecimal getOrdPvGST() {
    return ordPvGST;
  }

  public void setOrdPvGST(BigDecimal ordPvGST) {
    this.ordPvGST = ordPvGST;
  }

  public BigDecimal getOrderRentalFeesPromo() {
    return orderRentalFeesPromo;
  }

  public void setOrderRentalFeesPromo(BigDecimal orderRentalFeesPromo) {
    this.orderRentalFeesPromo = orderRentalFeesPromo;
  }

  public BigDecimal getPromoDiscPeriodTp() {
    return promoDiscPeriodTp;
  }

  public void setPromoDiscPeriodTp(BigDecimal promoDiscPeriodTp) {
    this.promoDiscPeriodTp = promoDiscPeriodTp;
  }

  public BigDecimal getPromoDiscPeriod() {
    return promoDiscPeriod;
  }

  public void setPromoDiscPeriod(BigDecimal promoDiscPeriod) {
    this.promoDiscPeriod = promoDiscPeriod;
  }

  public BigDecimal getNormalPricePromo() {
    return normalPricePromo;
  }

  public void setNormalPricePromo(BigDecimal normalPricePromo) {
    this.normalPricePromo = normalPricePromo;
  }

  public BigDecimal getDiscRntFee() {
    return discRntFee;
  }

  public void setDiscRntFee(BigDecimal discRntFee) {
    this.discRntFee = discRntFee;
  }

  public int getPromoItmId() {
    return promoItmId;
  }

  public void setPromoItmId(int promoItmId) {
    this.promoItmId = promoItmId;
  }

  public int getPromoItmStkId() {
    return promoItmStkId;
  }

  public void setPromoItmStkId(int promoItmStkId) {
    this.promoItmStkId = promoItmStkId;
  }

  public int getStkCode() {
    return stkCode;
  }

  public void setStkCode(int stkCode) {
    this.stkCode = stkCode;
  }

  public int getPromoItmCurId() {
    return promoItmCurId;
  }

  public void setPromoItmCurId(int promoItmCurId) {
    this.promoItmCurId = promoItmCurId;
  }

  public BigDecimal getPromoItmPrc() {
    return promoItmPrc;
  }

  public void setPromoItmPrc(BigDecimal promoItmPrc) {
    this.promoItmPrc = promoItmPrc;
  }

  public BigDecimal getPromoAmt() {
    return promoAmt;
  }

  public void setPromoAmt(BigDecimal promoAmt) {
    this.promoAmt = promoAmt;
  }

  public BigDecimal getPromoPrcRpf() {
    return promoPrcRpf;
  }

  public void setPromoPrcRpf(BigDecimal promoPrcRpf) {
    this.promoPrcRpf = promoPrcRpf;
  }

  public BigDecimal getPromoItmPv() {
    return promoItmPv;
  }

  public void setPromoItmPv(BigDecimal promoItmPv) {
    this.promoItmPv = promoItmPv;
  }

  public BigDecimal getPromoItmPvGst() {
    return promoItmPvGst;
  }

  public void setPromoItmPvGst(BigDecimal promoItmPvGst) {
    this.promoItmPvGst = promoItmPvGst;
  }

  public int getPromoAppTypeId() {
    return promoAppTypeId;
  }

  public void setPromoAppTypeId(int promoAppTypeId) {
    this.promoAppTypeId = promoAppTypeId;
  }

  public int getCustAddId() {
    return custAddId;
  }

  public void setCustAddId(int custAddId) {
    this.custAddId = custAddId;
  }

  public int getCustAddBillingId() {
    return custAddBillingId;
  }

  public void setCustAddBillingId(int custAddBillingId) {
    this.custAddBillingId = custAddBillingId;
  }

  public String getFullAddr() {
    return fullAddr;
  }

  public void setFullAddr(String fullAddr) {
    this.fullAddr = fullAddr;
  }

  public String getAreaId() {
    return areaId;
  }

  public void setAreaId(String areaId) {
    this.areaId = areaId;
  }

  public String getRem() {
    return rem;
  }

  public void setRem(String rem) {
    this.rem = rem;
  }

  public int getCustCrcId() {
    return custCrcId;
  }

  public void setCustCrcId(int custCrcId) {
    this.custCrcId = custCrcId;
  }

  public String getCardTypeIdName() {
    return cardTypeIdName;
  }

  public void setCardTypeIdName(String cardTypeIdName) {
    this.cardTypeIdName = cardTypeIdName;
  }

  public String getParamVal() {
    return paramVal;
  }

  public void setParamVal(String paramVal) {
    this.paramVal = paramVal;
  }

  public int getTknId() {
    return tknId;
  }

  public void setTknId(int tknId) {
    this.tknId = tknId;
  }

  public String getEtyPoint() {
    return etyPoint;
  }

  public void setEtyPoint(String etyPoint) {
    this.etyPoint = etyPoint;
  }

  public String getRefNo() {
    return refNo;
  }

  public void setRefNo(String refNo) {
    this.refNo = refNo;
  }

  public String getTknzUrl() {
    return tknzUrl;
  }

  public void setTknzUrl(String tknzUrl) {
    this.tknzUrl = tknzUrl;
  }

  public String getTknzMerchantId() {
    return tknzMerchantId;
  }

  public void setTknzMerchantId(String tknzMerchantId) {
    this.tknzMerchantId = tknzMerchantId;
  }

  public String getTknzVerfKey() {
    return tknzVerfKey;
  }

  public void setTknzVerfKey(String tknzVerfKey) {
    this.tknzVerfKey = tknzVerfKey;
  }

  public String getPan() {
    return pan;
  }

  public void setPan(String pan) {
    this.pan = pan;
  }

  public String getExpyear() {
    return expyear;
  }

  public void setExpyear(String expyear) {
    this.expyear = expyear;
  }

  public String getExpmonth() {
    return expmonth;
  }

  public void setExpmonth(String expmonth) {
    this.expmonth = expmonth;
  }

  public String getUrlReq() {
    return urlReq;
  }

  public void setUrlReq(String urlReq) {
    this.urlReq = urlReq;
  }

  public String getMerchantId() {
    return merchantId;
  }

  public void setMerchantId(String merchantId) {
    this.merchantId = merchantId;
  }

  public String getSignature() {
    return signature;
  }

  public void setSignature(String signature) {
    this.signature = signature;
  }

  public String getCustCrcExprMM() {
    return custCrcExprMM;
  }

  public void setCustCrcExprMM(String custCrcExprMM) {
    this.custCrcExprMM = custCrcExprMM;
  }

  public String getCustCrcExprYYYY() {
    return custCrcExprYYYY;
  }

  public void setCustCrcExprYYYY(String custCrcExprYYYY) {
    this.custCrcExprYYYY = custCrcExprYYYY;
  }

  public String getCustCrcRem() {
    return custCrcRem;
  }

  public void setCustCrcRem(String custCrcRem) {
    this.custCrcRem = custCrcRem;
  }

  public String getCrcCheck() {
    return crcCheck;
  }

  public void setCrcCheck(String crcCheck) {
    this.crcCheck = crcCheck;
  }

  public String getErrorDesc() {
    return errorDesc;
  }

  public void setErrorDesc(String errorDesc) {
    this.errorDesc = errorDesc;
  }

  public String getCrcNo() {
    return crcNo;
  }

  public void setCrcNo(String crcNo) {
    this.crcNo = crcNo;
  }

  public String getToken() {
    return token;
  }

  public void setToken(String token) {
    this.token = token;
  }

  public String getStus() {
    return stus;
  }

  public void setStus(String stus) {
    this.stus = stus;
  }

  public int getMemId() {
    return memId;
  }

  public void setMemId(int memId) {
    this.memId = memId;
  }

  public String getMemCode() {
    return memCode;
  }

  public void setMemCode(String memCode) {
    this.memCode = memCode;
  }

  public BigDecimal getTargetTot() {
    return targetTot;
  }

  public void setTargetTot(BigDecimal targetTot) {
    this.targetTot = targetTot;
  }

  public BigDecimal getCollectTot() {
    return collectTot;
  }

  public void setCollectTot(BigDecimal collectTot) {
    this.collectTot = collectTot;
  }

  public BigDecimal getRcPrct() {
    return rcPrct;
  }

  public void setRcPrct(BigDecimal rcPrct) {
    this.rcPrct = rcPrct;
  }

  public int getOpCnt() {
    return opCnt;
  }

  public void setOpCnt(int opCnt) {
    this.opCnt = opCnt;
  }

  public int getFlg6Month() {
    return flg6Month;
  }

  public void setFlg6Month(int flg6Month) {
    this.flg6Month = flg6Month;
  }

  public int getCnt() {
    return cnt;
  }

  public void setCnt(int cnt) {
    this.cnt = cnt;
  }

  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  public int getDscBrnchId() {
    return dscBrnchId;
  }

  public void setDscBrnchId(int dscBrnchId) {
    this.dscBrnchId = dscBrnchId;
  }

  public int getPostingBrnchId() {
    return postingBrnchId;
  }

  public void setPostingBrnchId(int postingBrnchId) {
    this.postingBrnchId = postingBrnchId;
  }

  public int getHdcBrnchId() {
    return hdcBrnchId;
  }

  public void setHdcBrnchId(int hdcBrnchId) {
    this.hdcBrnchId = hdcBrnchId;
  }

  public int getKeyinBrnchId() {
    return keyinBrnchId;
  }

  public void setKeyinBrnchId(int keyinBrnchId) {
    this.keyinBrnchId = keyinBrnchId;
  }

  public int getInstAddId() {
    return instAddId;
  }

  public void setInstAddId(int instAddId) {
    this.instAddId = instAddId;
  }

  public int getRentPayCustId() {
    return rentPayCustId;
  }

  public void setRentPayCustId(int rentPayCustId) {
    this.rentPayCustId = rentPayCustId;
  }

  public int getCustBillCustId() {
    return custBillCustId;
  }

  public void setCustBillCustId(int custBillCustId) {
    this.custBillCustId = custBillCustId;
  }

  public int getCustBillCntId() {
    return custBillCntId;
  }

  public void setCustBillCntId(int custBillCntId) {
    this.custBillCntId = custBillCntId;
  }

  public int getCustBillAddId() {
    return custBillAddId;
  }

  public void setCustBillAddId(int custBillAddId) {
    this.custBillAddId = custBillAddId;
  }

  public String getCustBillEmail() {
    return custBillEmail;
  }

  public void setCustBillEmail(String custBillEmail) {
    this.custBillEmail = custBillEmail;
  }

  public String getOrderType() {
    return orderType;
  }

  public void setOrderType(String orderType) {
    this.orderType = orderType;
  }

  public int getAtchFileGrpId() {
    return atchFileGrpId;
  }

  public void setAtchFileGrpId(int atchFileGrpId) {
    this.atchFileGrpId = atchFileGrpId;
  }

  public String getSubPath() {
    return subPath;
  }

  public void setSubPath(String subPath) {
    this.subPath = subPath;
  }

  public String getFileKeySeq() {
    return fileKeySeq;
  }

  public void setFileKeySeq(String fileKeySeq) {
    this.fileKeySeq = fileKeySeq;
  }

  public int getCrtUserId() {
    return crtUserId;
  }

  public void setCrtUserId(int crtUserId) {
    this.crtUserId = crtUserId;
  }

  public int getUpdUserId() {
    return updUserId;
  }

  public void setUpdUserId(int updUserId) {
    this.updUserId = updUserId;
  }

  public int getAtchFileId() {
    return atchFileId;
  }

  public void setAtchFileId(int atchFileId) {
    this.atchFileId = atchFileId;
  }

  public String getAtchFileName() {
    return atchFileName;
  }

  public void setAtchFileName(String atchFileName) {
    this.atchFileName = atchFileName;
  }

  public String getFileSubPath() {
    return fileSubPath;
  }

  public void setFileSubPath(String fileSubPath) {
    this.fileSubPath = fileSubPath;
  }

  public String getPhysiclFileName() {
    return physiclFileName;
  }

  public void setPhysiclFileName(String physiclFileName) {
    this.physiclFileName = physiclFileName;
  }

  public String getFileExtsn() {
    return fileExtsn;
  }

  public void setFileExtsn(String fileExtsn) {
    this.fileExtsn = fileExtsn;
  }

  public String getSaveFlag() {
    return saveFlag;
  }

  public void setSaveFlag(String saveFlag) {
    this.saveFlag = saveFlag;
  }

  public int getUpdateAtchFileGrpId() {
    return updateAtchFileGrpId;
  }

  public void setUpdateAtchFileGrpId(int updateAtchFileGrpId) {
    this.updateAtchFileGrpId = updateAtchFileGrpId;
  }

  public int getAtchFileIdSales() {
    return atchFileIdSales;
  }

  public void setAtchFileIdSales(int atchFileIdSales) {
    this.atchFileIdSales = atchFileIdSales;
  }

  public int getAtchFileIdNric() {
    return atchFileIdNric;
  }

  public void setAtchFileIdNric(int atchFileIdNric) {
    this.atchFileIdNric = atchFileIdNric;
  }

  public int getAtchFileIdPayment() {
    return atchFileIdPayment;
  }

  public void setAtchFileIdPayment(int atchFileIdPayment) {
    this.atchFileIdPayment = atchFileIdPayment;
  }

  public int getAtchFileIdTemporary() {
    return atchFileIdTemporary;
  }

  public void setAtchFileIdTemporary(int atchFileIdTemporary) {
    this.atchFileIdTemporary = atchFileIdTemporary;
  }

  public int getAtchFileIdoOthersform() {
    return atchFileIdoOthersform;
  }

  public void setAtchFileIdoOthersform(int atchFileIdoOthersform) {
    this.atchFileIdoOthersform = atchFileIdoOthersform;
  }

  public int getAtchFileIdoOthersform2() {
    return atchFileIdoOthersform2;
  }

  public void setAtchFileIdoOthersform2(int atchFileIdoOthersform2) {
    this.atchFileIdoOthersform2 = atchFileIdoOthersform2;
  }

  public int getOrdSeqNo() {
    return ordSeqNo;
  }

  public void setOrdSeqNo(int ordSeqNo) {
    this.ordSeqNo = ordSeqNo;
  }

  public String getPromoDt() {
    return promoDt;
  }

  public void setPromoDt(String promoDt) {
    this.promoDt = promoDt;
  }

  public String getGu() {
    return gu;
  }

  public void setGu(String gu) {
    this.gu = gu;
  }

  public String getCpntCode() {
    return cpntCode;
  }

  public void setCpntCode(String cpntCode) {
    this.cpntCode = cpntCode;
  }

  public String getCpntCodeName() {
    return cpntCodeName;
  }

  public void setCpntCodeName(String cpntCodeName) {
    this.cpntCodeName = cpntCodeName;
  }

  public BigDecimal getQuotaStus() {
    return quotaStus;
  }

  public void setQuotaStus(BigDecimal quotaStus) {
    this.quotaStus = quotaStus;
  }

  public int getReceivingMarketingMsgStatus() {
    return receivingMarketingMsgStatus;
  }

  public void setReceivingMarketingMsgStatus(int receivingMarketingMsgStatus) {
    this.receivingMarketingMsgStatus = receivingMarketingMsgStatus;
  }

  public int getIsHcAcInstallationFlag() {
    return isHcAcInstallationFlag;
  }

  public void setIsHcAcInstallationFlag(int isHcAcInstallationFlag) {
    this.isHcAcInstallationFlag = isHcAcInstallationFlag;
  }

  public String getAcBrnch() {
    return acBrnch;
  }

  public void setAcBrnch(String acBrnch) {
    this.acBrnch = acBrnch;
  }

  public int getAcBrnchId() {
    return acBrnchId;
  }

  public void setAcBrnchId(int acBrnchId) {
    this.acBrnchId = acBrnchId;
  }

  public int getCustCrcTokenIdStus() {
    return custCrcTokenIdStus;
  }

  public void setCustCrcTokenIdStus(int custCrcTokenIdStus) {
    this.custCrcTokenIdStus = custCrcTokenIdStus;
  }

  public int getIs3rdParty() {
    return Is3rdParty;
  }

  public void setIs3rdParty(int Is3rdParty) {
    this.Is3rdParty = Is3rdParty;
  }

  public int getVoucherValid() {
    return voucherValid;
  }

  public void setVoucherValid(int voucherValid) {
    this.voucherValid = voucherValid;
  }

  public String getVoucherCode() {
    return voucherCode;
  }

  public void setVoucherCode(String voucherCode) {
    this.voucherCode = voucherCode;
  }

  public int getVoucherType() {
    return voucherType;
  }

  public void setVoucherType(int voucherType) {
    this.voucherType = voucherType;
  }

  public String getVoucherEmail() {
    return voucherEmail;
  }

  public void setVoucherEmail(String voucherEmail) {
    this.voucherEmail = voucherEmail;
  }

  public String getCustomerStatusCode() {
    return customerStatusCode;
  }

  public void setCustomerStatusCode(String customerStatusCode) {
    this.customerStatusCode = customerStatusCode;
  }

  public String getCustomerStatus() {
    return customerStatus;
  }

  public void setCustomerStatus(String customerStatus) {
    this.customerStatus = customerStatus;
  }

  public String getSrvType() {
	return srvType;
  }

  public void setSrvType(String srvType) {
	this.srvType = srvType;
  }

}
