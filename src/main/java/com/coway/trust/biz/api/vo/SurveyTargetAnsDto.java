package com.coway.trust.biz.api.vo;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SurveyTargetAnsDto implements Serializable{
	private int tmplId;
	private int survId;
	private int tmplAnswSeq;
	private int tmplType;
	private String tmplAnswOpt1;
	private String tmplAnswOpt2;
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

	public String getTmplAnswOpt1() {
		return tmplAnswOpt1;
	}
	public void setTmplAnswOpt1(String tmplAnswOpt1) {
		this.tmplAnswOpt1 = tmplAnswOpt1;
	}

	public String getTmplAnswOpt2() {
		return tmplAnswOpt2;
	}
	public void setTmplAnswOpt2(String tmplAnswOpt2) {
		if(tmplAnswOpt2.isEmpty()){
			tmplAnswOpt2 = "";
		}

		this.tmplAnswOpt2 = tmplAnswOpt2;
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
