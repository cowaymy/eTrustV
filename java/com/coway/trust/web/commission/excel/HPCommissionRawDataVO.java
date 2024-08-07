package com.coway.trust.web.commission.excel;

import org.apache.poi.ss.usermodel.Row;

public class HPCommissionRawDataVO {

	// 각 변수는 타입에 맞게 선언해 주세요~~~ ^^
	private String mcode;
	private String memberName;
	private String rank;
	private String nric;
	private String pi;
	private String pa;
	private String sgmAmt;
	private String mgrAmt;
	private String outinsAmt;
	private String bonus;
	private String renmgrAmt;
	private String rentalAmt;
	private String outplsAmt;
	private String membershipAmt;
	private String tbbAmt;
	private String adjustAmt;
	private String incentive;
	private String shiAmt;
	private String rentalmembershipAmt;
	private String rentalmembershipShiAmt;

	public static HPCommissionRawDataVO create(Row row) {
		HPCommissionRawDataVO vo = new HPCommissionRawDataVO();
		vo.setMcode(row.getCell(0).getStringCellValue());
		vo.setMemberName(row.getCell(1).getStringCellValue());

		//  나머지 컬럼들을 세팅해 줘야 합니다~~  ^^....

		return vo;
	}

	public String getMcode() {
		return mcode;
	}

	public void setMcode(String mcode) {
		this.mcode = mcode;
	}

	public String getMemberName() {
		return memberName;
	}

	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}

	public String getRank() {
		return rank;
	}

	public void setRank(String rank) {
		this.rank = rank;
	}

	public String getNric() {
		return nric;
	}

	public void setNric(String nric) {
		this.nric = nric;
	}

	public String getPi() {
		return pi;
	}

	public void setPi(String pi) {
		this.pi = pi;
	}

	public String getPa() {
		return pa;
	}

	public void setPa(String pa) {
		this.pa = pa;
	}

	public String getSgmAmt() {
		return sgmAmt;
	}

	public void setSgmAmt(String sgmAmt) {
		this.sgmAmt = sgmAmt;
	}

	public String getMgrAmt() {
		return mgrAmt;
	}

	public void setMgrAmt(String mgrAmt) {
		this.mgrAmt = mgrAmt;
	}

	public String getOutinsAmt() {
		return outinsAmt;
	}

	public void setOutinsAmt(String outinsAmt) {
		this.outinsAmt = outinsAmt;
	}

	public String getBonus() {
		return bonus;
	}

	public void setBonus(String bonus) {
		this.bonus = bonus;
	}

	public String getRenmgrAmt() {
		return renmgrAmt;
	}

	public void setRenmgrAmt(String renmgrAmt) {
		this.renmgrAmt = renmgrAmt;
	}

	public String getRentalAmt() {
		return rentalAmt;
	}

	public void setRentalAmt(String rentalAmt) {
		this.rentalAmt = rentalAmt;
	}

	public String getOutplsAmt() {
		return outplsAmt;
	}

	public void setOutplsAmt(String outplsAmt) {
		this.outplsAmt = outplsAmt;
	}

	public String getMembershipAmt() {
		return membershipAmt;
	}

	public void setMembershipAmt(String membershipAmt) {
		this.membershipAmt = membershipAmt;
	}

	public String getTbbAmt() {
		return tbbAmt;
	}

	public void setTbbAmt(String tbbAmt) {
		this.tbbAmt = tbbAmt;
	}

	public String getAdjustAmt() {
		return adjustAmt;
	}

	public void setAdjustAmt(String adjustAmt) {
		this.adjustAmt = adjustAmt;
	}

	public String getIncentive() {
		return incentive;
	}

	public void setIncentive(String incentive) {
		this.incentive = incentive;
	}

	public String getShiAmt() {
		return shiAmt;
	}

	public void setShiAmt(String shiAmt) {
		this.shiAmt = shiAmt;
	}

	public String getRentalmembershipAmt() {
		return rentalmembershipAmt;
	}

	public void setRentalmembershipAmt(String rentalmembershipAmt) {
		this.rentalmembershipAmt = rentalmembershipAmt;
	}

	public String getRentalmembershipShiAmt() {
		return rentalmembershipShiAmt;
	}

	public void setRentalmembershipShiAmt(String rentalmembershipShiAmt) {
		this.rentalmembershipShiAmt = rentalmembershipShiAmt;
	}
}
