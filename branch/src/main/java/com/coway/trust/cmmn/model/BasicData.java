package com.coway.trust.cmmn.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class BasicData {
	private String _$uid; // AUI grid에서 정의한 값.

	public String get_$uid() {
		return _$uid;
	}

	public void set_$uid(String _$uid) {
		this._$uid = _$uid;
	}

}
