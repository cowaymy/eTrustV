package com.coway.trust.biz.incentive.goldPoints;

import org.apache.commons.csv.CSVRecord;

public class RedemptionItemVO {

	private String itemCode;
	private String itemCategory;
	private String itemDesc;
	private int goldPtsPerUnit;
	private String startDate;
	private String endDate;

	public static RedemptionItemVO create(CSVRecord CSVRecord) {
		RedemptionItemVO vo = new RedemptionItemVO();

		vo.setItemCode(CSVRecord.get(0));
		vo.setItemCategory(CSVRecord.get(1));
		vo.setItemDesc(CSVRecord.get(2));
		vo.setGoldPtsPerUnit(Integer.parseInt(CSVRecord.get(3)));
		vo.setStartDate(CSVRecord.get(4));
		vo.setEndDate(CSVRecord.get(5));

		return vo;
	}

	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode;
	}
	public String getItemCategory() {
		return itemCategory;
	}
	public void setItemCategory(String itemCategory) {
		this.itemCategory = itemCategory;
	}
	public String getItemDesc() {
		return itemDesc;
	}
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}
	public int getGoldPtsPerUnit() {
		return goldPtsPerUnit;
	}
	public void setGoldPtsPerUnit(int goldPtsPerUnit) {
		this.goldPtsPerUnit = goldPtsPerUnit;
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
