package com.coway.trust.biz.api.vo;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class SurveyTargetQuesVO implements Serializable{
	private int totalRecord;
	private List<SurveyTargetQuesDto> data;

	@SuppressWarnings("unchecked")
	public static SurveyTargetQuesVO create(Map<String, Object> egvoMap) {
		return BeanConverter.toBean(egvoMap, SurveyTargetQuesVO.class);
	}

	public int getTotalRecord() {
		return totalRecord;
	}
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
	}

	public List<SurveyTargetQuesDto> getData() {
		return data;
	}
	public void setData(List<SurveyTargetQuesDto> data) {
		this.data = data;
	}
}
