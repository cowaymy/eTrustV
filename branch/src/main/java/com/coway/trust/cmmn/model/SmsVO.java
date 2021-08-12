package com.coway.trust.cmmn.model;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.util.CommonUtils;

public class SmsVO {

	public SmsVO(int userId, int smsType) {
		this.userId = userId;
		this.smsType = smsType;
	}

	private List<SmsVO> smsVOList;

	private int userId;
	private String userName;
	private int priority = 1;
	private int expireDayAdd = 1;
	private int smsType;
	private int retryNo;
	private String refNo;
	private String remark;
	private int stusId;
	private String stusCode;
	private int bulkUploadId;
	private int vendorId;

	private String message;
	private String mobile;
	private List<String> mobiles;

	public List<SmsVO> getSmsVOList() {
		return smsVOList;
	}

	public void setSalesOrderLogVOList(List<SmsVO> smsVOList) {
		this.smsVOList = smsVOList;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
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

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
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

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;

	}

	public int getStusId() {
		return stusId;
	}

	public void setStusId(int stusId) {
		this.stusId = stusId;
	}

	public String getStusCode() {
		return stusCode;
	}

	public void setStusCode(String stusCode) {
		this.stusCode = stusCode;
	}

	public void setBulkUploadId(int bulkUploadId) {
		this.bulkUploadId = bulkUploadId;
	}

	public int getVendorId() {
		return vendorId;
	}

	public void setVendorId(int vendorId) {
		this.vendorId = vendorId;
	}

}
