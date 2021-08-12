package com.coway.trust.web.sales.customer;

import org.apache.commons.csv.CSVRecord;

public class LoyaltyHpRawDataVO {

	private String salesOrdNo;
	private String hpCode;
	private String startDate;
	private String endDate;

	public static LoyaltyHpRawDataVO create(CSVRecord CSVRecord) {
		LoyaltyHpRawDataVO vo = new LoyaltyHpRawDataVO();
		vo.setSalesOrdNo(CSVRecord.get(0));
		vo.setHpCode(CSVRecord.get(1));
		vo.setStartDate(CSVRecord.get(2));
		vo.setEndDate(CSVRecord.get(3));

		return vo;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getHpCode() {
		return hpCode;
	}

	public void setHpCode(String hpCode) {
		this.hpCode = hpCode;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

}
