package com.coway.trust.web.organization.organization;

import org.apache.commons.csv.CSVRecord;

public class GroupRawDataVO {

	private String fromTrans;
	private String toTrans;
	private String memberCode;
	private String memberLevel;
	private String transDate;
	private String memberCodeTo;
	private String groupMemberType;

	public static GroupRawDataVO create(CSVRecord CSVRecord) {
		GroupRawDataVO vo = new GroupRawDataVO();
		vo.setFromTrans(CSVRecord.get(0));
		vo.setMemberCode(CSVRecord.get(1));
		vo.setToTrans(CSVRecord.get(2));
		vo.setMemberLevel(CSVRecord.get(3));
		vo.setTransDate(CSVRecord.get(4));
		vo.setMemberCodeTo(CSVRecord.get(5));
		vo.setGroupMemberType(CSVRecord.get(6));

		return vo;
	}

	public String getFromTrans() {
		return fromTrans;
	}

	public void setFromTrans(String fromTrans) {
		this.fromTrans = fromTrans;
	}

	public String getToTrans() {
		return toTrans;
	}

	public void setToTrans(String toTrans) {
		this.toTrans = toTrans;
	}

	public String getMemberCode() {
		return memberCode;
	}

	public void setMemberCode(String memberCode) {
		this.memberCode = memberCode;
	}

	public String getMemberLevel() {
		return memberLevel;
	}

	public void setMemberLevel(String memberLevel) {
		this.memberLevel = memberLevel;
	}

	public String getTransDate() {
		return transDate;
	}

	public void setTransDate(String transDate) {
		this.transDate = transDate;
	}

	public String getMemberCodeTo() {
		return memberCodeTo;
	}

	public void setMemberCodeTo(String memberCodeTo) {
		this.memberCodeTo = memberCodeTo;
	}

	public String getGroupMemberType() {
		return groupMemberType;
	}

	public void setGroupMemberType(String groupMemberType) {
		this.groupMemberType = groupMemberType;
	}

}
