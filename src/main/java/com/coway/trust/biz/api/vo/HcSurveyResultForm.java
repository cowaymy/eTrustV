package com.coway.trust.biz.api.vo;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HcSurveyResultForm", description = "HcSurveyResultForm")
public class HcSurveyResultForm {

	@ApiModelProperty(value = "fileName")
	private String fileName;

	public Map createMap(HcSurveyResultForm hcSurveyResultForm) {
		return BeanConverter.toMap(hcSurveyResultForm);
	}

	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
}
