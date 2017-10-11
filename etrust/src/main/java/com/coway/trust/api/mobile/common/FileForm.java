package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class FileForm {

	public static Map<String, Object> createMap(FileForm fileForm) {
		Map<String, Object> map = BeanConverter.toMap(fileForm);
		return map;
	}
}
