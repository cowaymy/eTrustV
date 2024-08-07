package com.coway.trust.web.common;

import com.coway.trust.cmmn.model.BasicData;

public class CommStatusGridData extends BasicData {
	private int checkFlag;
	private int stusCodeId;
	private int seqNo;
	private String code;
	private String codeName;	
	private String codeDisab;  // category code management

	public int getCheckFlag() {
		return checkFlag;
	}

	public void setCheckFlag(int checkFlag) {
		this.checkFlag = checkFlag;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getCodeName() {
		return codeName;
	}

	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}

	public String getCodeDisab() {
		return codeDisab;
	}

	public void setCodeDisab(String codeDisab) {
		this.codeDisab = codeDisab;
	}

	public int getSeqNo() {
		return seqNo;
	}

	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}
	
	
}
