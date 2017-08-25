package com.coway.trust.cmmn.model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.coway.trust.AppConstants;
import com.coway.trust.util.CommonUtils;

public class SmsVO {
	private String message;
	private List<String> mobiles;

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public List<String> getMobiles() {
		if (this.mobiles == null) {
			return Collections.emptyList();
		}
		return mobiles;
	}

	public void setMobiles(List<String> mobiles) {
		if (this.mobiles == null) {
			this.mobiles = new ArrayList<>();
		}
		this.mobiles = mobiles;
	}

	/**
	 * mobile : 0101112222|!|0101112222|!|0101112222 같이 다건 처리 가능.(단, 구분자를 AppConstants.DEFAULT_DELIMITER를 사용해야 함.)
	 * 
	 * @param mobile
	 */
	public void setMobile(String mobile) {
		if (this.mobiles == null) {
			this.mobiles = new ArrayList<>();
		}

		String[] mobileArray = CommonUtils.getDelimiterValues(mobile);
		if (mobileArray.length > 0) {
			this.mobiles.addAll(Arrays.asList(mobileArray));
		} else {
			this.mobiles.add(mobile);
		}
	}
}
