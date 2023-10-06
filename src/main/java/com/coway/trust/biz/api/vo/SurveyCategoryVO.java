package com.coway.trust.biz.api.vo;

import java.io.Serializable;
import java.util.List;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class SurveyCategoryVO implements Serializable{
	private int totalRecord;
	private List<SurveyCategoryDto> data;

	@SuppressWarnings("unchecked")
	public static SurveyCategoryVO create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, SurveyCategoryVO.class);
	}

	public int getTotalRecord() {
		return totalRecord;
	}
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
	}

	public List<SurveyCategoryDto> getData() {
		return data;
	}
	public void setData(List<SurveyCategoryDto> data) {
		this.data = data;
	}
}
