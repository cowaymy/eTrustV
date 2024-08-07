package com.coway.trust.biz.sales.customer;

import org.apache.commons.csv.CSVRecord;

public class RewardBulkUploadVO {
	private String custNRIC;
	private String rewardType;
	private String remark;
	private int rewardPoint;

	public static RewardBulkUploadVO create(CSVRecord CSVRecord) {
		RewardBulkUploadVO vo = new RewardBulkUploadVO();

		vo.setCustNRIC(CSVRecord.get(0).trim());
		vo.setRewardType(CSVRecord.get(1).trim());
		vo.setRemark(CSVRecord.get(2).trim());
		vo.setRewardPoint(Integer.parseInt(CSVRecord.get(3).trim()));
		return vo;
	}

	public String getCustNRIC() {
		return custNRIC;
	}

	public void setCustNRIC(String custNRIC) {
		this.custNRIC = custNRIC;
	}

	public String getRewardType() {
		return rewardType;
	}

	public void setRewardType(String rewardType) {
		this.rewardType = rewardType;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public int getRewardPoint() {
		return rewardPoint;
	}

	public void setRewardPoint(int rewardPoint) {
		this.rewardPoint = rewardPoint;
	}
}