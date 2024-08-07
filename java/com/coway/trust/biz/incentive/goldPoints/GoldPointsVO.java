package com.coway.trust.biz.incentive.goldPoints;

import org.apache.commons.csv.CSVRecord;

public class GoldPointsVO {

	private String memCode;
	private String memName;
	private String ptsDesc;
	private int ptsEarned;
	private String startDate;
	private String endDate;

	public static GoldPointsVO create(CSVRecord CSVRecord) {
		GoldPointsVO vo = new GoldPointsVO();

		vo.setMemCode(CSVRecord.get(0));
		vo.setMemName(CSVRecord.get(1));
		vo.setPtsDesc(CSVRecord.get(2));
		vo.setPtsEarned(Integer.parseInt(CSVRecord.get(3)));
		vo.setStartDate(CSVRecord.get(4));
		vo.setEndDate(CSVRecord.get(5));

		return vo;
	}

	public String getMemCode() {
		return memCode;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}

	public String getMemName() {
		return memName;
	}

	public void setMemName(String memName) {
		this.memName = memName;
	}

	public String getPtsDesc() {
		return ptsDesc;
	}

	public void setPtsDesc(String ptsDesc) {
		this.ptsDesc = ptsDesc;
	}

	public int getPtsEarned() {
		return ptsEarned;
	}

	public void setPtsEarned(int ptsEarned) {
		this.ptsEarned = ptsEarned;
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
