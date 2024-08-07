package com.coway.trust.api.project.LMS;

import java.util.HashMap;
import java.util.Map;

import org.jsoup.helper.StringUtil;

import antlr.StringUtils;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : LMSApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2021. 08. 19.    MY-HLTANG   First creation
 * </pre>
 */
@ApiModel(value = "LMSApiForm", description = "LMSApiForm")
public class LMSApiForm {

	private String key;
	private String courseTitle;
	private String courseType;
	private String courseCode;
	private String courseDesc;
	private String courseLocation;
	private String courseStartDt;
	private String courseEndDt;
	private int courseStatus;
	private int courseLimit;
	private String courseCloseDt;
	private String isMember;
	private int memberType;

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getCourseTitle() {
		return courseTitle;
	}

	public void setCourseTitle(String courseTitle) {
		this.courseTitle = courseTitle;
	}

	public String getCourseType() {
		return courseType;
	}

	public void setCourseType(String courseType) {
		this.courseType = courseType;
	}

	public String getCourseCode() {
		return courseCode;
	}

	public void setCourseCode(String courseCode) {
		this.courseCode = courseCode;
	}

	public String getCourseDesc() {
		return courseDesc;
	}

	public void setCourseDesc(String courseDesc) {
		this.courseDesc = courseDesc;
	}

	public String getCourseLocation() {
		return courseLocation;
	}

	public void setCourseLocation(String courseLocation) {
		this.courseLocation = courseLocation;
	}

	public String getCourseStartDt() {
		return courseStartDt;
	}

	public void setCourseStartDt(String courseStartDt) {
		this.courseStartDt = courseStartDt;
	}

	public String getCourseEndDt() {
		return courseEndDt;
	}

	public void setCourseEndDt(String courseEndDt) {
		this.courseEndDt = courseEndDt;
	}

	public int getCourseStatus() {
		return courseStatus;
	}

	public void setCourseStatus(int courseStatus) {
		this.courseStatus = courseStatus;
	}

	public int getCourseLimit() {
		return courseLimit;
	}

	public void setCourseLimit(int courseLimit) {
		this.courseLimit = courseLimit;
	}

	public String getCourseCloseDt() {
		return courseCloseDt;
	}

	public void setCourseCloseDt(String courseCloseDt) {
		this.courseCloseDt = courseCloseDt;
	}

	public String getIsMember() {
		return isMember;
	}

	public void setIsMember(String isMember) {
		this.isMember = isMember;
	}

	public int getMemberType() {
		return memberType;
	}

	public void setMemberType(int memberType) {
		this.memberType = memberType;
	}



}
