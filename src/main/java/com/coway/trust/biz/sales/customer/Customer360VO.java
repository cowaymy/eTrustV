package com.coway.trust.biz.sales.customer;

import java.io.Serializable;
import java.sql.Clob;
import java.util.Date;

public class Customer360VO implements Serializable {

	private static final long serialVersionUID = -1192921313821390794L;

	/** Customer List */
	private int custId;					// Customer ID
	private String name;				// Customer Name
	private String nric;					// NRIC
	private String rem;					// Remark
	private int typeId;					// Customer Type
	private String pasSportExpr;
	private String visaExpr;
	private String nation;				// Nationlity
	private String dob;					// DOB
	private String custVaNo;			// V.A Number
	private int corpTypeId;			// Company Type
	private String codeName;			// Company Type Name (CorpType)
	private String codeName1;		// Customer Type Name (Type)
	private int bankId;
	private String code;
	private String areaId;

	/** Customer Insert VO*/
	private String custName;
	private int getCustId;
	private int cmbNation;
	private String gender;
	private int cmbRace;
	private String email;
	private int cmbTypeId;
	private int cmbCorpTypeId;
	private String gstRgistNo;
	private int getCustAddrId;
	private String addrDtl;
	private String streetDtl;
	private int cmbPostCd;
	private int cmbArea;
	private int mstate;
	private String addrRem;
	private int getCustCntcId;
	private int getCustCareCntId;
	private int custInitial;
	private String telM1;
	private String telO;
	private String telF;
	private String telR;
	private String ext;
	private String asTelM;
	private String asTelO;
	private String asTelR;
	private String asTelF;
	private String asEmail;
	private String asCustName;
	private String asExt;
	private String accNo;
	private String accOwner;
	private int accTypeId;
	private int accBankId;
	private String accBankBrnch;
	private String accRem;
	private String oldNric;



	public String getOldNric() {
		return oldNric;
	}
	public void setOldNric(String oldNric) {
		this.oldNric = oldNric;
	}
	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
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
	public String getRem() {
		return rem;
	}
	public void setRem(String rem) {
		this.rem = rem;
	}
	public int getTypeId() {
		return typeId;
	}
	public void setTypeId(int typeId) {
		this.typeId = typeId;
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
	public String getNation() {
		return nation;
	}
	public void setNation(String nation) {
		this.nation = nation;
	}
	public String getDob() {
		return dob;
	}
	public void setDob(String dob) {
		this.dob = dob;
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
	public String getCodeName() {
		return codeName;
	}
	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}
	public String getCodeName1() {
		return codeName1;
	}
	public void setCodeName1(String codeName1) {
		this.codeName1 = codeName1;
	}
	public int getBankId() {
		return bankId;
	}
	public void setBankId(int bankId) {
		this.bankId = bankId;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}

	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public int getGetCustId() {
		return getCustId;
	}
	public void setGetCustId(int getCustId) {
		this.getCustId = getCustId;
	}
	public int getCmbNation() {
		return cmbNation;
	}
	public void setCmbNation(int cmbNation) {
		this.cmbNation = cmbNation;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public int getCmbRace() {
		return cmbRace;
	}
	public void setCmbRace(int cmbRace) {
		this.cmbRace = cmbRace;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getCmbTypeId() {
		return cmbTypeId;
	}
	public void setCmbTypeId(int cmbTypeId) {
		this.cmbTypeId = cmbTypeId;
	}
	public int getCmbCorpTypeId() {
		return cmbCorpTypeId;
	}
	public void setCmbCorpTypeId(int cmbCorpTypeId) {
		this.cmbCorpTypeId = cmbCorpTypeId;
	}
	public String getGstRgistNo() {
		return gstRgistNo;
	}
	public void setGstRgistNo(String gstRgistNo) {
		this.gstRgistNo = gstRgistNo;
	}
	public int getGetCustAddrId() {
		return getCustAddrId;
	}
	public void setGetCustAddrId(int getCustAddrId) {
		this.getCustAddrId = getCustAddrId;
	}
	public String getAddrDtl() {
		return addrDtl;
	}
	public void setAddrDtl(String addrDtl) {
		this.addrDtl = addrDtl;
	}
	public int getCmbPostCd() {
		return cmbPostCd;
	}
	public void setCmbPostCd(int cmbPostCd) {
		this.cmbPostCd = cmbPostCd;
	}
	public int getCmbArea() {
		return cmbArea;
	}
	public void setCmbArea(int cmbArea) {
		this.cmbArea = cmbArea;
	}
	public int getMstate() {
		return mstate;
	}
	public void setMstate(int mstate) {
		this.mstate = mstate;
	}
	public String getAddrRem() {
		return addrRem;
	}
	public void setAddrRem(String addrRem) {
		this.addrRem = addrRem;
	}
	public int getGetCustCntcId() {
		return getCustCntcId;
	}
	public void setGetCustCntcId(int getCustCntcId) {
		this.getCustCntcId = getCustCntcId;
	}
	public int getGetCustCareCntId() {
		return getCustCareCntId;
	}
	public void setGetCustCareCntId(int getCustCareCntId) {
		this.getCustCareCntId = getCustCareCntId;
	}
	public int getCustInitial() {
		return custInitial;
	}
	public void setCustInitial(int custInitial) {
		this.custInitial = custInitial;
	}
	public String getTelM1() {
		return telM1;
	}
	public void setTelM1(String telM1) {
		this.telM1 = telM1;
	}
	public String getTelO() {
		return telO;
	}
	public void setTelO(String telO) {
		this.telO = telO;
	}
	public String getTelF() {
		return telF;
	}
	public void setTelF(String telF) {
		this.telF = telF;
	}
	public String getTelR() {
		return telR;
	}
	public void setTelR(String telR) {
		this.telR = telR;
	}
	public String getExt() {
		return ext;
	}
	public void setExt(String ext) {
		this.ext = ext;
	}
	public String getAsTelM() {
		return asTelM;
	}
	public void setAsTelM(String asTelM) {
		this.asTelM = asTelM;
	}
	public String getAsTelO() {
		return asTelO;
	}
	public void setAsTelO(String asTelO) {
		this.asTelO = asTelO;
	}
	public String getAsTelR() {
		return asTelR;
	}
	public void setAsTelR(String asTelR) {
		this.asTelR = asTelR;
	}
	public String getAsTelF() {
		return asTelF;
	}
	public void setAsTelF(String asTelF) {
		this.asTelF = asTelF;
	}
	public String getAsEmail() {
		return asEmail;
	}
	public void setAsEmail(String asEmail) {
		this.asEmail = asEmail;
	}
	public String getAsCustName() {
		return asCustName;
	}
	public void setAsCustName(String asCustName) {
		this.asCustName = asCustName;
	}
	public String getAsExt() {
		return asExt;
	}
	public void setAsExt(String asExt) {
		this.asExt = asExt;
	}
	public String getAccNo() {
		return accNo;
	}
	public void setAccNo(String accNo) {
		this.accNo = accNo;
	}
	public String getAccOwner() {
		return accOwner;
	}
	public void setAccOwner(String accOwner) {
		this.accOwner = accOwner;
	}
	public int getAccTypeId() {
		return accTypeId;
	}
	public void setAccTypeId(int accTypeId) {
		this.accTypeId = accTypeId;
	}
	public int getAccBankId() {
		return accBankId;
	}
	public void setAccBankId(int accBankId) {
		this.accBankId = accBankId;
	}
	public String getAccBankBrnch() {
		return accBankBrnch;
	}
	public void setAccBankBrnch(String accBankBrnch) {
		this.accBankBrnch = accBankBrnch;
	}
	public String getAccRem() {
		return accRem;
	}
	public void setAccRem(String accRem) {
		this.accRem = accRem;
	}
	public String getAreaId() {
		return areaId;
	}
	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}
	public String getStreetDtl() {
		return streetDtl;
	}
	public void setStreetDtl(String streetDtl) {
		this.streetDtl = streetDtl;
	}

}
