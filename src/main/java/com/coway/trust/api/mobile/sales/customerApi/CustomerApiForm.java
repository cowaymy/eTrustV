package com.coway.trust.api.mobile.sales.customerApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

/**
 * @ClassName : CustomerApiForm.java
 * @Description : TO-DO Class Description
 * @History
 *
 *          <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 16.    KR-JAEMJAEM:)   First creation
 * 2024. 05. 02.    MY-ONGHC         Add SST Registration No & TIN No
 *          </pre>
 */
@ApiModel(value = "CustomerApiForm", description = "CustomerApiForm")
public class CustomerApiForm {
  public static CustomerApiForm create( Map<String, Object> customerMap ) {
    return BeanConverter.toBean( customerMap, CustomerApiForm.class );
  }

  public static Map<String, Object> createMap( CustomerApiForm vo ) {
    Map<String, Object> params = new HashMap<>();
    params.put( "typeId", vo.getTypeId() );
    params.put( "selectType", vo.getSelectType() );
    params.put( "selectKeyword", vo.getSelectKeyword() );
    params.put( "custId", vo.getCustId() );
    params.put( "custAddId", vo.getCustAddId() );
    params.put( "memId", vo.getMemId() );
    return params;
  }

  /* SAL0029D */
  // private Date updDt;
  // private Date crtDt;
  // private int typeId;
  private int typeId;

  private String selectType;

  private String selectKeyword;

  private int custId;

  private int custAddId;

  private String regId;

  private String yymmdd;

  private String yyyymmdd;

  private String ddmmyyyy;

  private int memId;

  private String name;

  private String nric;

  private int nation;

  private String dob;

  private String gender;

  private int raceId;

  private String email;

  private String rem;

  private int stusCodeId;

  private int updUserId;

  private String renGrp;

  private int pstTerms;

  private int idOld;

  private int crtUserId;

  private String pasSportExpr;

  private String visaExpr;

  private String custVaNo;

  private int corpTypeId;

  private String gstRgistNo;

  private String ctosDt;

  private int ficoScre;

  private String oldIc;

  private String sstRegNo;

  private String tinNo;

  private int receivingMarketingMsgStatus;

  /* SAL0027D */
  // private int custId;
  // private Date updDt;
  // private int updUserId;
  // private Date crtDt;
  // private int crtUserId;
  private int custCntcId;

  private String contactName;

  private int contactCustInitial;

  private String contactNric;

  private String contactPos;

  private String contactTelM1;

  private String contactTelM2;

  private String contactTelO;

  private String contactTelR;

  private String contactTelf;

  private String contactDob;

  private String contactGender;

  private int contactRaceId;

  private String contactEmail;

  private int contactStusCodeId;

  private int contactIdOld;

  private String contactDept;

  private int contactDcm;

  private String contactExt;

  /* SAL0026D */
  private int custCareCntId;
  // private int custId;

  private String careCntName;

  private int careCntCustInitial;

  private String careCntTelM;

  private String careCntTelO;

  private String careCntTelR;

  private String careCntExt;

  private String careCntEmail;

  private int careCntStusCodeId;
  // private int crtUserId;
  // private Date crtDt;
  // private int updUserId;
  // private Date updDt;

  private String careCntTelf;

  /* SAL0023D */
  // private int custAddId;
  // private int custId;
  // private int updUserId;
  // private Date updDt;
  // private int crtUserId;
  // private Date crtDt;
  private String addressNric;

  private String addressTel;

  private String addressFax;

  private int addressStusCodeId;

  private String addressRem;

  private int addressIdOld;

  private int addressSoId;

  private int addressIdcm;

  private String addressAreaId;

  private String addressAddrDtl;

  private String addressStreet;

  private String addressAdd1;

  private String addressAdd2;

  private String addressAdd3;

  private String addressAdd4;

  private int addressPostcodeid;

  private String addressPostcode;

  private int addressAreaid;

  private String addressArea;

  private int addressAtateid;

  private int addressCountryid;

  public int getTypeId() {
    return typeId;
  }

  public void setTypeId( int typeId ) {
    this.typeId = typeId;
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

  public int getCustAddId() {
    return custAddId;
  }

  public void setCustAddId( int custAddId ) {
    this.custAddId = custAddId;
  }

  public int getCustId() {
    return custId;
  }

  public void setCustId( int custId ) {
    this.custId = custId;
  }

  public String getRegId() {
    return regId;
  }

  public void setRegId( String regId ) {
    this.regId = regId;
  }

  public String getName() {
    return name;
  }

  public void setName( String name ) {
    this.name = name;
  }

  public String getNric() {
    return nric;
  }

  public void setNric( String nric ) {
    this.nric = nric;
  }

  public int getNation() {
    return nation;
  }

  public void setNation( int nation ) {
    this.nation = nation;
  }

  public String getDob() {
    return dob;
  }

  public void setDob( String dob ) {
    this.dob = dob;
  }

  public String getGender() {
    return gender;
  }

  public void setGender( String gender ) {
    this.gender = gender;
  }

  public int getRaceId() {
    return raceId;
  }

  public void setRaceId( int raceId ) {
    this.raceId = raceId;
  }

  public String getEmail() {
    return email;
  }

  public void setEmail( String email ) {
    this.email = email;
  }

  public String getRem() {
    return rem;
  }

  public void setRem( String rem ) {
    this.rem = rem;
  }

  public int getStusCodeId() {
    return stusCodeId;
  }

  public void setStusCodeId( int stusCodeId ) {
    this.stusCodeId = stusCodeId;
  }

  public int getUpdUserId() {
    return updUserId;
  }

  public void setUpdUserId( int updUserId ) {
    this.updUserId = updUserId;
  }

  public String getRenGrp() {
    return renGrp;
  }

  public void setRenGrp( String renGrp ) {
    this.renGrp = renGrp;
  }

  public int getPstTerms() {
    return pstTerms;
  }

  public void setPstTerms( int pstTerms ) {
    this.pstTerms = pstTerms;
  }

  public int getIdOld() {
    return idOld;
  }

  public void setIdOld( int idOld ) {
    this.idOld = idOld;
  }

  public int getCrtUserId() {
    return crtUserId;
  }

  public void setCrtUserId( int crtUserId ) {
    this.crtUserId = crtUserId;
  }

  public String getPasSportExpr() {
    return pasSportExpr;
  }

  public void setPasSportExpr( String pasSportExpr ) {
    this.pasSportExpr = pasSportExpr;
  }

  public String getVisaExpr() {
    return visaExpr;
  }

  public void setVisaExpr( String visaExpr ) {
    this.visaExpr = visaExpr;
  }

  public String getCustVaNo() {
    return custVaNo;
  }

  public void setCustVaNo( String custVaNo ) {
    this.custVaNo = custVaNo;
  }

  public int getCorpTypeId() {
    return corpTypeId;
  }

  public void setCorpTypeId( int corpTypeId ) {
    this.corpTypeId = corpTypeId;
  }

  public String getGstRgistNo() {
    return gstRgistNo;
  }

  public void setGstRgistNo( String gstRgistNo ) {
    this.gstRgistNo = gstRgistNo;
  }

  public String getCtosDt() {
    return ctosDt;
  }

  public void setCtosDt( String ctosDt ) {
    this.ctosDt = ctosDt;
  }

  public int getFicoScre() {
    return ficoScre;
  }

  public void setFicoScre( int ficoScre ) {
    this.ficoScre = ficoScre;
  }

  public String getOldIc() {
    return oldIc;
  }

  public void setOldIc( String oldIc ) {
    this.oldIc = oldIc;
  }

  public String getSstRegNo() {
    return sstRegNo;
  }

  public void setSstRegNo( String sstRegNo ) {
    this.sstRegNo = sstRegNo;
  }

  public String getTinNo() {
    return tinNo;
  }

  public void setTinNo( String tinNo ) {
    this.tinNo = tinNo;
  }

  public int getCustCntcId() {
    return custCntcId;
  }

  public void setCustCntcId( int custCntcId ) {
    this.custCntcId = custCntcId;
  }

  public String getContactName() {
    return contactName;
  }

  public void setContactName( String contactName ) {
    this.contactName = contactName;
  }

  public int getContactCustInitial() {
    return contactCustInitial;
  }

  public void setContactCustInitial( int contactCustInitial ) {
    this.contactCustInitial = contactCustInitial;
  }

  public String getContactNric() {
    return contactNric;
  }

  public void setContactNric( String contactNric ) {
    this.contactNric = contactNric;
  }

  public String getContactPos() {
    return contactPos;
  }

  public void setContactPos( String contactPos ) {
    this.contactPos = contactPos;
  }

  public String getContactTelM1() {
    return contactTelM1;
  }

  public void setContactTelM1( String contactTelM1 ) {
    this.contactTelM1 = contactTelM1;
  }

  public String getContactTelM2() {
    return contactTelM2;
  }

  public void setContactTelM2( String contactTelM2 ) {
    this.contactTelM2 = contactTelM2;
  }

  public String getContactTelO() {
    return contactTelO;
  }

  public void setContactTelO( String contactTelO ) {
    this.contactTelO = contactTelO;
  }

  public String getContactTelR() {
    return contactTelR;
  }

  public void setContactTelR( String contactTelR ) {
    this.contactTelR = contactTelR;
  }

  public String getContactTelf() {
    return contactTelf;
  }

  public void setContactTelf( String contactTelf ) {
    this.contactTelf = contactTelf;
  }

  public String getContactDob() {
    return contactDob;
  }

  public void setContactDob( String contactDob ) {
    this.contactDob = contactDob;
  }

  public String getContactGender() {
    return contactGender;
  }

  public void setContactGender( String contactGender ) {
    this.contactGender = contactGender;
  }

  public int getContactRaceId() {
    return contactRaceId;
  }

  public void setContactRaceId( int contactRaceId ) {
    this.contactRaceId = contactRaceId;
  }

  public String getContactEmail() {
    return contactEmail;
  }

  public void setContactEmail( String contactEmail ) {
    this.contactEmail = contactEmail;
  }

  public int getContactStusCodeId() {
    return contactStusCodeId;
  }

  public void setContactStusCodeId( int contactStusCodeId ) {
    this.contactStusCodeId = contactStusCodeId;
  }

  public int getContactIdOld() {
    return contactIdOld;
  }

  public void setContactIdOld( int contactIdOld ) {
    this.contactIdOld = contactIdOld;
  }

  public String getContactDept() {
    return contactDept;
  }

  public void setContactDept( String contactDept ) {
    this.contactDept = contactDept;
  }

  public int getContactDcm() {
    return contactDcm;
  }

  public void setContactDcm( int contactDcm ) {
    this.contactDcm = contactDcm;
  }

  public String getContactExt() {
    return contactExt;
  }

  public void setContactExt( String contactExt ) {
    this.contactExt = contactExt;
  }

  public int getCustCareCntId() {
    return custCareCntId;
  }

  public void setCustCareCntId( int custCareCntId ) {
    this.custCareCntId = custCareCntId;
  }

  public String getCareCntName() {
    return careCntName;
  }

  public void setCareCntName( String careCntName ) {
    this.careCntName = careCntName;
  }

  public int getCareCntCustInitial() {
    return careCntCustInitial;
  }

  public void setCareCntCustInitial( int careCntCustInitial ) {
    this.careCntCustInitial = careCntCustInitial;
  }

  public String getCareCntTelM() {
    return careCntTelM;
  }

  public void setCareCntTelM( String careCntTelM ) {
    this.careCntTelM = careCntTelM;
  }

  public String getCareCntTelO() {
    return careCntTelO;
  }

  public void setCareCntTelO( String careCntTelO ) {
    this.careCntTelO = careCntTelO;
  }

  public String getCareCntTelR() {
    return careCntTelR;
  }

  public void setCareCntTelR( String careCntTelR ) {
    this.careCntTelR = careCntTelR;
  }

  public String getCareCntExt() {
    return careCntExt;
  }

  public void setCareCntExt( String careCntExt ) {
    this.careCntExt = careCntExt;
  }

  public String getCareCntEmail() {
    return careCntEmail;
  }

  public void setCareCntEmail( String careCntEmail ) {
    this.careCntEmail = careCntEmail;
  }

  public int getCareCntStusCodeId() {
    return careCntStusCodeId;
  }

  public void setCareCntStusCodeId( int careCntStusCodeId ) {
    this.careCntStusCodeId = careCntStusCodeId;
  }

  public String getCareCntTelf() {
    return careCntTelf;
  }

  public void setCareCntTelf( String careCntTelf ) {
    this.careCntTelf = careCntTelf;
  }

  public String getAddressNric() {
    return addressNric;
  }

  public void setAddressNric( String addressNric ) {
    this.addressNric = addressNric;
  }

  public String getAddressTel() {
    return addressTel;
  }

  public void setAddressTel( String addressTel ) {
    this.addressTel = addressTel;
  }

  public String getAddressFax() {
    return addressFax;
  }

  public void setAddressFax( String addressFax ) {
    this.addressFax = addressFax;
  }

  public int getAddressStusCodeId() {
    return addressStusCodeId;
  }

  public void setAddressStusCodeId( int addressStusCodeId ) {
    this.addressStusCodeId = addressStusCodeId;
  }

  public String getAddressRem() {
    return addressRem;
  }

  public void setAddressRem( String addressRem ) {
    this.addressRem = addressRem;
  }

  public int getAddressIdOld() {
    return addressIdOld;
  }

  public void setAddressIdOld( int addressIdOld ) {
    this.addressIdOld = addressIdOld;
  }

  public int getAddressSoId() {
    return addressSoId;
  }

  public void setAddressSoId( int addressSoId ) {
    this.addressSoId = addressSoId;
  }

  public int getAddressIdcm() {
    return addressIdcm;
  }

  public void setAddressIdcm( int addressIdcm ) {
    this.addressIdcm = addressIdcm;
  }

  public String getAddressAreaId() {
    return addressAreaId;
  }

  public void setAddressAreaId( String addressAreaId ) {
    this.addressAreaId = addressAreaId;
  }

  public String getAddressAddrDtl() {
    return addressAddrDtl;
  }

  public void setAddressAddrDtl( String addressAddrDtl ) {
    this.addressAddrDtl = addressAddrDtl;
  }

  public String getAddressStreet() {
    return addressStreet;
  }

  public void setAddressStreet( String addressStreet ) {
    this.addressStreet = addressStreet;
  }

  public String getAddressAdd1() {
    return addressAdd1;
  }

  public void setAddressAdd1( String addressAdd1 ) {
    this.addressAdd1 = addressAdd1;
  }

  public String getAddressAdd2() {
    return addressAdd2;
  }

  public void setAddressAdd2( String addressAdd2 ) {
    this.addressAdd2 = addressAdd2;
  }

  public String getAddressAdd3() {
    return addressAdd3;
  }

  public void setAddressAdd3( String addressAdd3 ) {
    this.addressAdd3 = addressAdd3;
  }

  public String getAddressAdd4() {
    return addressAdd4;
  }

  public void setAddressAdd4( String addressAdd4 ) {
    this.addressAdd4 = addressAdd4;
  }

  public int getAddressPostcodeid() {
    return addressPostcodeid;
  }

  public void setAddressPostcodeid( int addressPostcodeid ) {
    this.addressPostcodeid = addressPostcodeid;
  }

  public String getAddressPostcode() {
    return addressPostcode;
  }

  public void setAddressPostcode( String addressPostcode ) {
    this.addressPostcode = addressPostcode;
  }

  public int getAddressAreaid() {
    return addressAreaid;
  }

  public void setAddressAreaid( int addressAreaid ) {
    this.addressAreaid = addressAreaid;
  }

  public String getAddressArea() {
    return addressArea;
  }

  public void setAddressArea( String addressArea ) {
    this.addressArea = addressArea;
  }

  public int getAddressAtateid() {
    return addressAtateid;
  }

  public void setAddressAtateid( int addressAtateid ) {
    this.addressAtateid = addressAtateid;
  }

  public int getAddressCountryid() {
    return addressCountryid;
  }

  public void setAddressCountryid( int addressCountryid ) {
    this.addressCountryid = addressCountryid;
  }

  public String getYyyymmdd() {
    return yyyymmdd;
  }

  public void setYyyymmdd( String yyyymmdd ) {
    this.yyyymmdd = yyyymmdd;
  }

  public String getYymmdd() {
    return yymmdd;
  }

  public void setYymmdd( String yymmdd ) {
    this.yymmdd = yymmdd;
  }

  public String getDdmmyyyy() {
    return ddmmyyyy;
  }

  public void setDdmmyyyy( String ddmmyyyy ) {
    this.ddmmyyyy = ddmmyyyy;
  }

  public int getMemId() {
    return memId;
  }

  public void setMemId( int memId ) {
    this.memId = memId;
  }

  public int getReceivingMarketingMsgStatus() {
    return receivingMarketingMsgStatus;
  }

  public void setReceivingMarketingMsgStatus( int receivingMarketingMsgStatus ) {
    this.receivingMarketingMsgStatus = receivingMarketingMsgStatus;
  }
}
