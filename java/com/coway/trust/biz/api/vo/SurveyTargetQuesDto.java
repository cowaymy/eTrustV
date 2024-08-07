package com.coway.trust.biz.api.vo;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SurveyTargetQuesDto implements Serializable{
	private int survId;
	private int ctrlId;
	private String survQuesStr;
	private String survQuesEnd;
	private int survSeq;
	private String survQues1;
	private String survQues2;
	private String survQues3;
	private int survGdCatg;
	private int survGdId;
	private String survQuesYn;

	public static SurveyTargetQuesDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, SurveyTargetQuesDto.class);
	}

	public int getSurvId() {
		return survId;
	}
	public void setSurvId(int survId) {
		this.survId = survId;
	}

	public int getCtrlId() {
		return ctrlId;
	}
	public void setCtrlId(int ctrlId) {
		this.ctrlId = ctrlId;
	}

	public String getSurvQuesStr() {
		return survQuesStr;
	}
	public void setSurvQuesStr(String survQuesStr) {
		this.survQuesStr = survQuesStr;
	}

	public String getSurvQuesEnd() {
		return survQuesEnd;
	}
	public void setSurvQuesEnd(String survQuesEnd) {
		this.survQuesEnd = survQuesEnd;
	}

	public int getSurvSeq() {
		return survSeq;
	}
	public void setSurvSeq(int survSeq) {
		this.survSeq = survSeq;
	}

	public String getSurvQues1() {
		return survQues1;
	}
	public void setSurvQues1(String survQues1) {
		this.survQues1 = survQues1;
	}

	public String getSurvQues2() {
		return survQues2;
	}
	public void setSurvQues2(String survQues2) {
		this.survQues2 = survQues2;
	}

	public String getSurvQues3() {
		return survQues3;
	}
	public void setSurvQues3(String survQues3) {
		if(survQues3.isEmpty()){
			survQues3 = "";
		}
		this.survQues3 = survQues3;
	}

	public int getSurvGdCatg() {
		return survGdCatg;
	}
	public void setSurvGdCatg(int survGdCatg) {
		this.survGdCatg = survGdCatg;
	}

	public int getSurvGdId() {
		return survGdId;
	}
	public void setSurvGdId(int survGdId) {
		this.survGdId = survGdId;
	}

	public String getSurvQuesYn() {
		return survQuesYn;
	}
	public void setSurvQuesYn(String survQuesYn) {
		this.survQuesYn = survQuesYn;
	}
}
