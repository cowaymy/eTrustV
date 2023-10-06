package com.coway.trust.biz.api.vo;

import java.io.Serializable;
import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SurveyTargetAnsVO implements Serializable{
	private int totalRecord;
	private List<SurveyTargetAnsDto> data;

	@SuppressWarnings("unchecked")
	public static SurveyTargetAnsVO create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, SurveyTargetAnsVO.class);
	}

	public int getTotalRecord() {
		return totalRecord;
	}
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
	}

	public List<SurveyTargetAnsDto> getData() {
		return data;
	}
	public void setData(List<SurveyTargetAnsDto> data) {
		this.data = data;
	}
}
