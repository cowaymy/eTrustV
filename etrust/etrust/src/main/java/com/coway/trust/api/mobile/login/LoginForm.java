package com.coway.trust.api.mobile.login;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "LoginForm", description = "LoginForm")
public class LoginForm {

	@ApiModelProperty(value = "사용자 Name", required = true)
	private String userName;
	@ApiModelProperty(value = "사용자 pw", required = true)
	private String userPw;
	@ApiModelProperty(value = "휴대폰 번호")
	private String deviceNumber;
	@ApiModelProperty(value = "휴대폰 번호 체크 여부")
	private boolean checkDeviceNumber;
	@ApiModelProperty(value = "device 고유번호")
	private String deviceImei;
	@ApiModelProperty(value = "앱 버전")
	private String appVersion;

	public static Map<String, Object> createMap(LoginForm loginForm) {
		Map<String, Object> params = new HashMap<>();
		params.put(LoginConstants.P_USER_ID, loginForm.getUserName());
		params.put(LoginConstants.P_USER_PW, loginForm.getUserPw());
		if (loginForm.isCheckDeviceNumber()) {
			params.put(LoginConstants.P_USER_MOBILE_NO, loginForm.getDeviceNumber());
		}
		params.put(LoginConstants.P_DEVICE_IMEI, loginForm.getDeviceImei());
		params.put(LoginConstants.P_APP_VERSION, loginForm.getAppVersion());
		return params;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPw() {
		return userPw;
	}

	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}

	public String getDeviceNumber() {
		return deviceNumber;
	}

	public void setDeviceNumber(String deviceNumber) {
		this.deviceNumber = deviceNumber;
	}

	public boolean isCheckDeviceNumber() {
		return checkDeviceNumber;
	}

	public void setCheckDeviceNumber(boolean checkDeviceNumber) {
		this.checkDeviceNumber = checkDeviceNumber;
	}

	public String getDeviceImei() {
		return deviceImei;
	}

	public void setDeviceImei(String deviceImei) {
		this.deviceImei = deviceImei;
	}

	public String getAppVersion() {
		return appVersion;
	}

	public void setAppVersion(String appVersion) {
		this.appVersion = appVersion;
	}
}
