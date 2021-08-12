package com.coway.trust.api.mobile.sales.customerApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : CustomerApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 16.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "CustomerApiForm", description = "CustomerApiForm")
public class CustomerApiForm {



    public static CustomerApiForm create(Map<String, Object> customerMap) {
        return BeanConverter.toBean(customerMap, CustomerApiForm.class);
    }



	public static Map<String, Object> createMap(CustomerApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("typeId", vo.getTypeId());
		params.put("selectType", vo.getSelectType());
		params.put("selectKeyword", vo.getSelectKeyword());
        params.put("custId", vo.getCustId());
        params.put("custAddId", vo.getCustAddId());
        params.put("memId", vo.getMemId());
		return params;
	}



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


    /*SAL0029D --ASIS_DB : WebDB ASIS_SCHEMA : dbo ASIS_TABLE : Customer*/
//    private int custId;                                                         // ASIS_COLUMN : CustomerID
    private String name;                                                        // ASIS_COLUMN : Name
    private String nric;                                                        // ASIS_COLUMN : NRIC
    private int nation;                                                         // ASIS_COLUMN : Nationality
    private String dob;                                                         // ASIS_COLUMN : DOB
    private String gender;                                                      // ASIS_COLUMN : Gender
    private int raceId;                                                         // ASIS_COLUMN : RaceID
    private String email;                                                       // ASIS_COLUMN : Email
    private String rem;                                                         // ASIS_COLUMN : Remark
    private int stusCodeId;                                                     // ASIS_COLUMN : StatusCodeID
    private int updUserId;                                                      // ASIS_COLUMN : Updator
//  private Date updDt;                                                         // ASIS_COLUMN : Updated
    private String renGrp;                                                      // ASIS_COLUMN : RenGrp
    private int pstTerms;                                                       // ASIS_COLUMN : PSTTerms
    private int idOld;                                                          // ASIS_COLUMN : IDOld
    private int crtUserId;                                                      // ASIS_COLUMN : Creator
//  private Date crtDt;                                                         // ASIS_COLUMN : Created
//    private int typeId;                                                         // ASIS_COLUMN : TypeID
    private String pasSportExpr;                                                // ASIS_COLUMN : PassportExpire
    private String visaExpr;                                                    // ASIS_COLUMN : VisaExpire
    private String custVaNo;                                                    // ASIS_COLUMN : CustVano
    private int corpTypeId;                                                     // ASIS_COLUMN : CorpTypeID
    private String gstRgistNo;                                                  // ASIS_COLUMN : GSTRegistrationNo
    private String ctosDt;                                                      // ASIS_COLUMN : CTOSDate
    private int ficoScre;                                                       // ASIS_COLUMN : FicoScore
    private String oldIc;                                                       //Old IC



    /*SAL0027D -- ASIS_DB : WebDB ASIS_SCHEMA : dbo ASIS_TABLE : CustContact*/
    private int custCntcId;                                                     // ASIS_COLUMN : CustContactID
//  private int custId;                                                         // ASIS_COLUMN : CustID
    private String contactName;                                                 // ASIS_COLUMN : Name
    private int contactCustInitial;                                             // ASIS_COLUMN : Initial
    private String contactNric;                                                 // ASIS_COLUMN : NRIC
    private String contactPos;                                                  // ASIS_COLUMN : Pos
    private String contactTelM1;                                                // ASIS_COLUMN : TelM1
    private String contactTelM2;                                                // ASIS_COLUMN : TelM2
    private String contactTelO;                                                 // ASIS_COLUMN : TelO
    private String contactTelR;                                                 // ASIS_COLUMN : TelR
    private String contactTelf;                                                 // ASIS_COLUMN : TelF
    private String contactDob;                                                  // ASIS_COLUMN : DOB
    private String contactGender;                                               // ASIS_COLUMN : Gender
    private int contactRaceId;                                                  // ASIS_COLUMN : RaceID
    private String contactEmail;                                                // ASIS_COLUMN : Email
    private int contactStusCodeId;                                              // ASIS_COLUMN : StatusCodeID
//  private Date updDt;                                                         // ASIS_COLUMN : Updated
//  private int updUserId;                                                      // ASIS_COLUMN : Updator
    private int contactIdOld;                                                   // ASIS_COLUMN : IDOld
    private String contactDept;                                                 // ASIS_COLUMN : Dept
    private int contactDcm;                                                     // ASIS_COLUMN : Dcm
//  private Date crtDt;                                                         // ASIS_COLUMN : Created
//  private int crtUserId;                                                      // ASIS_COLUMN : Creator
    private String contactExt;                                                  // ASIS_COLUMN : Ext



    /*SAL0026D -- ASIS_DB : WebDB ASIS_SCHEMA : dbo ASIS_TABLE : CustCareContact*/
    private int custCareCntId;                                                  // ASIS_COLUMN : CustCareCntID
//  private int custId;                                                         // ASIS_COLUMN : CustID
    private String careCntName;                                                 // ASIS_COLUMN : Name
    private int careCntCustInitial;                                             // ASIS_COLUMN : Initial
    private String careCntTelM;                                                 // ASIS_COLUMN : TelM
    private String careCntTelO;                                                 // ASIS_COLUMN : TelO
    private String careCntTelR;                                                 // ASIS_COLUMN : TelR
    private String careCntExt;                                                  // ASIS_COLUMN : Ext
    private String careCntEmail;                                                // ASIS_COLUMN : Email
    private int careCntStusCodeId;                                              // ASIS_COLUMN : StatusCodeID
//  private int crtUserId;                                                      // ASIS_COLUMN : Creator
//  private Date crtDt;                                                         // ASIS_COLUMN : Created
//  private int updUserId;                                                      // ASIS_COLUMN : Updator
//  private Date updDt;                                                         // ASIS_COLUMN : Updated
    private String careCntTelf;                                                 // ASIS_COLUMN : TelF



    /*SAL0023D -- ASIS_DB : WebDB ASIS_SCHEMA : dbo ASIS_TABLE : CustAddress*/
//    private int custAddId;                                                      // ASIS_COLUMN : CustAddID
//  private int custId;                                                         // ASIS_COLUMN : CustomerID
    private String addressNric;                                                 // ASIS_COLUMN : NRIC
    private String addressTel;                                                  // ASIS_COLUMN : Tel
    private String addressFax;                                                  // ASIS_COLUMN : Fax
    private int addressStusCodeId;                                              // ASIS_COLUMN : StatusCodeID
    private String addressRem;                                                  // ASIS_COLUMN : Remark
//  private int updUserId;                                                      // ASIS_COLUMN : Updator
//  private Date updDt;                                                         // ASIS_COLUMN : Updated
    private int addressIdOld;                                                   // ASIS_COLUMN : IDOld
    private int addressSoId;                                                    // ASIS_COLUMN : SOID
    private int addressIdcm;                                                    // ASIS_COLUMN : IDcm
//  private int crtUserId;                                                      // ASIS_COLUMN : Creator
//  private Date crtDt;                                                         // ASIS_COLUMN : Created
    private String addressAreaId;                                               //Area ID
    private String addressAddrDtl;                                              //Address Detail
    private String addressStreet;                                               //Street
    private String addressAdd1;                                                 // ASIS_COLUMN : Add1
    private String addressAdd2;                                                 // ASIS_COLUMN : Add2
    private String addressAdd3;                                                 // ASIS_COLUMN : Add3
    private String addressAdd4;                                                 // ASIS_COLUMN : Add4
    private int addressPostcodeid;                                              //
    private String addressPostcode;                                             //
    private int addressAreaid;                                                  //
    private String addressArea;                                                 // ASIS_COLUMN : Area
    private int addressAtateid;                                                 //
    private int addressCountryid;                                               //



    public int getTypeId() {
        return typeId;
    }
    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }
    public String getSelectType() {
        return selectType;
    }
    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }
    public String getSelectKeyword() {
        return selectKeyword;
    }
    public void setSelectKeyword(String selectKeyword) {
        this.selectKeyword = selectKeyword;
    }
    public int getCustAddId() {
        return custAddId;
    }
    public void setCustAddId(int custAddId) {
        this.custAddId = custAddId;
    }
    public int getCustId() {
        return custId;
    }
    public void setCustId(int custId) {
        this.custId = custId;
    }
    public String getRegId() {
        return regId;
    }
    public void setRegId(String regId) {
        this.regId = regId;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getNric() {
        return nric;
    }
    public void setNric(String nric) {
        this.nric = nric;
    }
    public int getNation() {
        return nation;
    }
    public void setNation(int nation) {
        this.nation = nation;
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
    public int getRaceId() {
        return raceId;
    }
    public void setRaceId(int raceId) {
        this.raceId = raceId;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getRem() {
        return rem;
    }
    public void setRem(String rem) {
        this.rem = rem;
    }
    public int getStusCodeId() {
        return stusCodeId;
    }
    public void setStusCodeId(int stusCodeId) {
        this.stusCodeId = stusCodeId;
    }
    public int getUpdUserId() {
        return updUserId;
    }
    public void setUpdUserId(int updUserId) {
        this.updUserId = updUserId;
    }
    public String getRenGrp() {
        return renGrp;
    }
    public void setRenGrp(String renGrp) {
        this.renGrp = renGrp;
    }
    public int getPstTerms() {
        return pstTerms;
    }
    public void setPstTerms(int pstTerms) {
        this.pstTerms = pstTerms;
    }
    public int getIdOld() {
        return idOld;
    }
    public void setIdOld(int idOld) {
        this.idOld = idOld;
    }
    public int getCrtUserId() {
        return crtUserId;
    }
    public void setCrtUserId(int crtUserId) {
        this.crtUserId = crtUserId;
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
    public String getCustVaNo() {
        return custVaNo;
    }
    public void setCustVaNo(String custVaNo) {
        this.custVaNo = custVaNo;
    }
    public int getCorpTypeId() {
        return corpTypeId;
    }
    public void setCorpTypeId(int corpTypeId) {
        this.corpTypeId = corpTypeId;
    }
    public String getGstRgistNo() {
        return gstRgistNo;
    }
    public void setGstRgistNo(String gstRgistNo) {
        this.gstRgistNo = gstRgistNo;
    }
    public String getCtosDt() {
        return ctosDt;
    }
    public void setCtosDt(String ctosDt) {
        this.ctosDt = ctosDt;
    }
    public int getFicoScre() {
        return ficoScre;
    }
    public void setFicoScre(int ficoScre) {
        this.ficoScre = ficoScre;
    }
    public String getOldIc() {
        return oldIc;
    }
    public void setOldIc(String oldIc) {
        this.oldIc = oldIc;
    }
    public int getCustCntcId() {
        return custCntcId;
    }
    public void setCustCntcId(int custCntcId) {
        this.custCntcId = custCntcId;
    }
    public String getContactName() {
        return contactName;
    }
    public void setContactName(String contactName) {
        this.contactName = contactName;
    }
    public int getContactCustInitial() {
        return contactCustInitial;
    }
    public void setContactCustInitial(int contactCustInitial) {
        this.contactCustInitial = contactCustInitial;
    }
    public String getContactNric() {
        return contactNric;
    }
    public void setContactNric(String contactNric) {
        this.contactNric = contactNric;
    }
    public String getContactPos() {
        return contactPos;
    }
    public void setContactPos(String contactPos) {
        this.contactPos = contactPos;
    }
    public String getContactTelM1() {
        return contactTelM1;
    }
    public void setContactTelM1(String contactTelM1) {
        this.contactTelM1 = contactTelM1;
    }
    public String getContactTelM2() {
        return contactTelM2;
    }
    public void setContactTelM2(String contactTelM2) {
        this.contactTelM2 = contactTelM2;
    }
    public String getContactTelO() {
        return contactTelO;
    }
    public void setContactTelO(String contactTelO) {
        this.contactTelO = contactTelO;
    }
    public String getContactTelR() {
        return contactTelR;
    }
    public void setContactTelR(String contactTelR) {
        this.contactTelR = contactTelR;
    }
    public String getContactTelf() {
        return contactTelf;
    }
    public void setContactTelf(String contactTelf) {
        this.contactTelf = contactTelf;
    }
    public String getContactDob() {
        return contactDob;
    }
    public void setContactDob(String contactDob) {
        this.contactDob = contactDob;
    }
    public String getContactGender() {
        return contactGender;
    }
    public void setContactGender(String contactGender) {
        this.contactGender = contactGender;
    }
    public int getContactRaceId() {
        return contactRaceId;
    }
    public void setContactRaceId(int contactRaceId) {
        this.contactRaceId = contactRaceId;
    }
    public String getContactEmail() {
        return contactEmail;
    }
    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }
    public int getContactStusCodeId() {
        return contactStusCodeId;
    }
    public void setContactStusCodeId(int contactStusCodeId) {
        this.contactStusCodeId = contactStusCodeId;
    }
    public int getContactIdOld() {
        return contactIdOld;
    }
    public void setContactIdOld(int contactIdOld) {
        this.contactIdOld = contactIdOld;
    }
    public String getContactDept() {
        return contactDept;
    }
    public void setContactDept(String contactDept) {
        this.contactDept = contactDept;
    }
    public int getContactDcm() {
        return contactDcm;
    }
    public void setContactDcm(int contactDcm) {
        this.contactDcm = contactDcm;
    }
    public String getContactExt() {
        return contactExt;
    }
    public void setContactExt(String contactExt) {
        this.contactExt = contactExt;
    }
    public int getCustCareCntId() {
        return custCareCntId;
    }
    public void setCustCareCntId(int custCareCntId) {
        this.custCareCntId = custCareCntId;
    }
    public String getCareCntName() {
        return careCntName;
    }
    public void setCareCntName(String careCntName) {
        this.careCntName = careCntName;
    }
    public int getCareCntCustInitial() {
        return careCntCustInitial;
    }
    public void setCareCntCustInitial(int careCntCustInitial) {
        this.careCntCustInitial = careCntCustInitial;
    }
    public String getCareCntTelM() {
        return careCntTelM;
    }
    public void setCareCntTelM(String careCntTelM) {
        this.careCntTelM = careCntTelM;
    }
    public String getCareCntTelO() {
        return careCntTelO;
    }
    public void setCareCntTelO(String careCntTelO) {
        this.careCntTelO = careCntTelO;
    }
    public String getCareCntTelR() {
        return careCntTelR;
    }
    public void setCareCntTelR(String careCntTelR) {
        this.careCntTelR = careCntTelR;
    }
    public String getCareCntExt() {
        return careCntExt;
    }
    public void setCareCntExt(String careCntExt) {
        this.careCntExt = careCntExt;
    }
    public String getCareCntEmail() {
        return careCntEmail;
    }
    public void setCareCntEmail(String careCntEmail) {
        this.careCntEmail = careCntEmail;
    }
    public int getCareCntStusCodeId() {
        return careCntStusCodeId;
    }
    public void setCareCntStusCodeId(int careCntStusCodeId) {
        this.careCntStusCodeId = careCntStusCodeId;
    }
    public String getCareCntTelf() {
        return careCntTelf;
    }
    public void setCareCntTelf(String careCntTelf) {
        this.careCntTelf = careCntTelf;
    }
    public String getAddressNric() {
        return addressNric;
    }
    public void setAddressNric(String addressNric) {
        this.addressNric = addressNric;
    }
    public String getAddressTel() {
        return addressTel;
    }
    public void setAddressTel(String addressTel) {
        this.addressTel = addressTel;
    }
    public String getAddressFax() {
        return addressFax;
    }
    public void setAddressFax(String addressFax) {
        this.addressFax = addressFax;
    }
    public int getAddressStusCodeId() {
        return addressStusCodeId;
    }
    public void setAddressStusCodeId(int addressStusCodeId) {
        this.addressStusCodeId = addressStusCodeId;
    }
    public String getAddressRem() {
        return addressRem;
    }
    public void setAddressRem(String addressRem) {
        this.addressRem = addressRem;
    }
    public int getAddressIdOld() {
        return addressIdOld;
    }
    public void setAddressIdOld(int addressIdOld) {
        this.addressIdOld = addressIdOld;
    }
    public int getAddressSoId() {
        return addressSoId;
    }
    public void setAddressSoId(int addressSoId) {
        this.addressSoId = addressSoId;
    }
    public int getAddressIdcm() {
        return addressIdcm;
    }
    public void setAddressIdcm(int addressIdcm) {
        this.addressIdcm = addressIdcm;
    }
    public String getAddressAreaId() {
        return addressAreaId;
    }
    public void setAddressAreaId(String addressAreaId) {
        this.addressAreaId = addressAreaId;
    }
    public String getAddressAddrDtl() {
        return addressAddrDtl;
    }
    public void setAddressAddrDtl(String addressAddrDtl) {
        this.addressAddrDtl = addressAddrDtl;
    }
    public String getAddressStreet() {
        return addressStreet;
    }
    public void setAddressStreet(String addressStreet) {
        this.addressStreet = addressStreet;
    }
    public String getAddressAdd1() {
        return addressAdd1;
    }
    public void setAddressAdd1(String addressAdd1) {
        this.addressAdd1 = addressAdd1;
    }
    public String getAddressAdd2() {
        return addressAdd2;
    }
    public void setAddressAdd2(String addressAdd2) {
        this.addressAdd2 = addressAdd2;
    }
    public String getAddressAdd3() {
        return addressAdd3;
    }
    public void setAddressAdd3(String addressAdd3) {
        this.addressAdd3 = addressAdd3;
    }
    public String getAddressAdd4() {
        return addressAdd4;
    }
    public void setAddressAdd4(String addressAdd4) {
        this.addressAdd4 = addressAdd4;
    }
    public int getAddressPostcodeid() {
        return addressPostcodeid;
    }
    public void setAddressPostcodeid(int addressPostcodeid) {
        this.addressPostcodeid = addressPostcodeid;
    }
    public String getAddressPostcode() {
        return addressPostcode;
    }
    public void setAddressPostcode(String addressPostcode) {
        this.addressPostcode = addressPostcode;
    }
    public int getAddressAreaid() {
        return addressAreaid;
    }
    public void setAddressAreaid(int addressAreaid) {
        this.addressAreaid = addressAreaid;
    }
    public String getAddressArea() {
        return addressArea;
    }
    public void setAddressArea(String addressArea) {
        this.addressArea = addressArea;
    }
    public int getAddressAtateid() {
        return addressAtateid;
    }
    public void setAddressAtateid(int addressAtateid) {
        this.addressAtateid = addressAtateid;
    }
    public int getAddressCountryid() {
        return addressCountryid;
    }
    public void setAddressCountryid(int addressCountryid) {
        this.addressCountryid = addressCountryid;
    }
    public String getYyyymmdd() {
        return yyyymmdd;
    }
    public void setYyyymmdd(String yyyymmdd) {
        this.yyyymmdd = yyyymmdd;
    }
    public String getYymmdd() {
        return yymmdd;
    }
    public void setYymmdd(String yymmdd) {
        this.yymmdd = yymmdd;
    }
    public String getDdmmyyyy() {
        return ddmmyyyy;
    }
    public void setDdmmyyyy(String ddmmyyyy) {
        this.ddmmyyyy = ddmmyyyy;
    }
    public int getMemId() {
        return memId;
    }
    public void setMemId(int memId) {
        this.memId = memId;
    }
}
