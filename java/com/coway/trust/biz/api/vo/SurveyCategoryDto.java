package com.coway.trust.biz.api.vo;

import java.io.Serializable;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SurveyCategoryDto implements Serializable{
	private int ctrlId;
	private String ctrlCode;
	private String ctrlNm;
	private int ctrlType;
	private String ctrlRem;
	private String ctrlStrYyyymm;
	private String ctrlEndYyyymm;
	private String ctrlUseYn;

	@SuppressWarnings("unchecked")
	public static SurveyCategoryDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, SurveyCategoryDto.class);
	}

	public int getCtrlId() {
		return ctrlId;
	}
	public void setCtrlId(int ctrlId) {
		this.ctrlId = ctrlId;
	}

	public String getCtrlCode() {
		return ctrlCode;
	}
	public void setCtrlCode(String ctrlCode) {
		this.ctrlCode = ctrlCode;
	}

	public String getCtrlNm() {
		return ctrlNm;
	}
	public void setCtrlNm(String ctrlNm) {
		this.ctrlNm = ctrlNm;
	}

	public int getCtrlType() {
		return ctrlType;
	}
	public void setCtrlType(int ctrlType) {
		this.ctrlType = ctrlType;
	}

	public String getCtrlRem() {
		return ctrlRem;
	}
	public void setCtrlRem(String ctrlRem) {
		this.ctrlRem = ctrlRem;
	}

	public String getCtrlStrYyyymm() {
		return ctrlStrYyyymm;
	}
	public void setCtrlStrYyyymm(String ctrlStrYyyymm) {
		this.ctrlStrYyyymm = ctrlStrYyyymm;
	}

	public String getCtrlEndYyyymm() {
		return ctrlEndYyyymm;
	}
	public void setCtrlEndYyyymm(String ctrlEndYyyymm) {
		this.ctrlEndYyyymm = ctrlEndYyyymm;
	}

	public String getCtrlUseYn() {
		return ctrlUseYn;
	}
	public void setCtrlUseYn(String ctrlUseYn) {
		this.ctrlUseYn = ctrlUseYn;
	}
}
