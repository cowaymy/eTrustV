package com.coway.trust.api.callcenter.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class FileForm {

	@ApiModelProperty(value = "userId (int)")
	private int userId;
	@ApiModelProperty(value = "file sub path (ex : sales)")
	private String subPath;

	public static Map<String, Object> createMap(FileForm fileForm) {
		Map<String, Object> map = BeanConverter.toMap(fileForm);
		return map;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getSubPath() {
		return subPath;
	}

	public void setSubPath(String subPath) {
		this.subPath = subPath;
	}
}
