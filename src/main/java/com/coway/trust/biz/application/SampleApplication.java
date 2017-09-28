package com.coway.trust.biz.application;

import java.util.Map;

import com.coway.trust.cmmn.model.SmsResult;

public interface SampleApplication {

	void saveMultiService(Map<String, Object> params);

	boolean sendEmailAndProcess(Map<String, Object> params);

	SmsResult sendSmsAndProcess(Map<String, Object> params);
}
