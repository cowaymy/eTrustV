package com.coway.trust.cmmn.model;

import java.util.ArrayList;
import java.util.List;

import com.coway.trust.AppConstants;

public class SmsVO {
	private String message;
	private List<String> mobiles = new ArrayList<>();

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public List<String> getMobiles() {
		return mobiles;
	}

	public void setMobiles(List<String> mobiles) {
		this.mobiles = mobiles;
	}

	/**
	 * mobile : 0101112222|!|0101112222|!|0101112222 같이 다건 처리 가능.(단, 구분자를 AppConstants.DEFAULT_DELIMITER를 사용해야 함.)
	 * 
	 * @param mobile
	 */
	public void setMobile(String mobile) {

		if (mobile.split(AppConstants.DEFAULT_DELIMITER).length > 0) {

		} else {
			this.mobiles.add(mobile);
		}
	}
}
