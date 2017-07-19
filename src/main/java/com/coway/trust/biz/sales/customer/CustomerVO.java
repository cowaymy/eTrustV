package com.coway.trust.biz.sales.customer;

import java.io.Serializable;
import java.sql.Clob;
import java.util.Date;

public class CustomerVO implements Serializable {

	private static final long serialVersionUID = -1192921313821390794L;

	/** Customer List */
	private int custId;					// Customer ID
	private String name;				// Customer Name
	private String nric;					// NRIC
	private Clob rem;					// Remark
	private int typeId;					// Customer Type
	private String pasSportExpr;
	private String visaExpr;
	private String nation;				// Nationlity
	private Date dob;					// DOB
	private String custVaNo;			// V.A Number
	private int corpTypeId;			// Company Type
	private String codeName;			// Company Type Name (CorpType)
	private String codeName1;		// Customer Type Name (Type)
	
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
	public Clob getRem() {
		return rem;
	}
	public void setRem(Clob rem) {
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
	public Date getDob() {
		return dob;
	}
	public void setDob(Date dob) {
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
	
	
}
