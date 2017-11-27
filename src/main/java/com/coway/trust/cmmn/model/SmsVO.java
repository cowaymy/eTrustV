package com.coway.trust.cmmn.model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.coway.trust.util.CommonUtils;

public class SmsVO {

	public SmsVO(int userId, int smsType) {
		this.userId = userId;
		this.smsType = smsType;
	}

	private int userId;
	private int priority = 1;
	private int expireDayAdd = 1;
	private int smsType;
	private int retryNo;
	private String remark;

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
	 * @param mobiles
	 */
	public void setMobiles(String mobiles) {
		if (this.mobiles == null) {
			this.mobiles = new ArrayList<>();
		}

		String[] mobileArray = CommonUtils.getDelimiterValues(mobiles);
		if (mobileArray.length > 0) {
			this.mobiles.addAll(Arrays.asList(mobileArray));
		} else {
			this.mobiles.add(mobiles);
		}
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getPriority() {
		return priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	public int getExpireDayAdd() {
		return expireDayAdd;
	}

	public void setExpireDayAdd(int expireDayAdd) {
		this.expireDayAdd = expireDayAdd;
	}

	public int getSmsType() {
		return smsType;
	}

	public void setSmsType(int smsType) {
		this.smsType = smsType;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public int getRetryNo() {
		return retryNo;
	}

	public void setRetryNo(int retryNo) {
		this.retryNo = retryNo;
	}
}
