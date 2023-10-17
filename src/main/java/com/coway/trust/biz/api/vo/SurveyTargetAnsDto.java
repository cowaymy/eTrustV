package com.coway.trust.biz.api.vo;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SurveyTargetAnsDto implements Serializable{
	private int tmplId;
	private int survId;
	private int tmplAnswSeq;
	private int tmplType;
	private String tmplAnwsOpt1;
	private String tmplAnwsOpt2;
	private String tmplRem;
	private String useYn;

	@SuppressWarnings("unchecked")
	public static SurveyTargetAnsDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, SurveyTargetAnsDto.class);
	}

	public int getTmplId() {
		return tmplId;
	}
	public void setTmplId(int tmplId) {
		this.tmplId = tmplId;
	}

	public int getSurvId() {
		return survId;
	}
	public void setSurvId(int survId) {
		this.survId = survId;
	}

	public int getTmplAnswSeq() {
		return tmplAnswSeq;
	}
	public void setTmplAnswSeq(int tmplAnswSeq) {
		this.tmplAnswSeq = tmplAnswSeq;
	}

	public int getTmplType() {
		return tmplType;
	}
	public void setTmplType(int tmplType) {
		this.tmplType = tmplType;
	}

	public String getTmplAnwsOpt1() {
		return tmplAnwsOpt1;
	}
	public void setTmplAnwsOpt1(String tmplAnwsOpt1) {
		this.tmplAnwsOpt1 = tmplAnwsOpt1;
	}

	public String getTmplAnwsOpt2() {
		return tmplAnwsOpt2;
	}
	public void setTmplAnwsOpt2(String tmplAnwsOpt2) {
		if(tmplAnwsOpt2.isEmpty()){
			tmplAnwsOpt2 = "";
		}

		this.tmplAnwsOpt2 = tmplAnwsOpt2;
	}

	public String getTmplRem() {
		return tmplRem;
	}
	public void setTmplRem(String tmplRem) {
		this.tmplRem = tmplRem;
	}

	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
}
