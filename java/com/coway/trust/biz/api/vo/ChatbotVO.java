package com.coway.trust.biz.api.vo;

import java.io.Serializable;
import java.util.Map;

import com.coway.trust.util.BeanConverter;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


@JsonIgnoreProperties(ignoreUnknown = true)
public class ChatbotVO implements Serializable{
	private SurveyCategoryVO surveyCategory;
	private SurveyTargetQuesVO surveyTargetQues;
	private SurveyTargetAnsVO surveyTargetAns;

	@SuppressWarnings("unchecked")
	public static ChatbotVO create(Map<String, Object> egvoMap) {
		return BeanConverter.toBean(egvoMap, ChatbotVO.class);
	}

	public SurveyCategoryVO getSurveyCategory() {
		return surveyCategory;
	}
	public void setSurveyCategory(SurveyCategoryVO surveyCategory) {
		this.surveyCategory = surveyCategory;
	}

	public SurveyTargetQuesVO getSurveyTargetQues() {
		return surveyTargetQues;
	}
	public void setSurveyTargetQues(SurveyTargetQuesVO surveyTargetQues) {
		this.surveyTargetQues = surveyTargetQues;
	}

	public SurveyTargetAnsVO getSurveyTargetAns() {
		return surveyTargetAns;
	}
	public void setSurveyTargetAns(SurveyTargetAnsVO surveyTargetAns) {
		this.surveyTargetAns = surveyTargetAns;
	}
}
