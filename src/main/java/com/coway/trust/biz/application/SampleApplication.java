package com.coway.trust.biz.application;

import java.util.Map;

public interface SampleApplication {

	void saveMultiService(Map<String, Object> params);
	
	boolean sendEmailAndProcess(Map<String, Object> params);
}
