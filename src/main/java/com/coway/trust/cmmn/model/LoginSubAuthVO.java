package com.coway.trust.cmmn.model;

import java.io.Serializable;

public class LoginSubAuthVO  implements Serializable {

	private int userId;
	private String authCode;
	private String authDivCode;
	private String authDivName;

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getAuthCode() {
		return authCode;
	}

	public void setAuthCode(String authCode) {
		this.authCode = authCode;
	}

	public String getAuthDivCode() {
		return authDivCode;
	}

	public void setAuthDivCode(String authDivCode) {
		this.authDivCode = authDivCode;
	}

	public String getAuthDivName() {
		return authDivName;
	}

	public void setAuthDivName(String authDivName) {
		this.authDivName = authDivName;
	}
}
