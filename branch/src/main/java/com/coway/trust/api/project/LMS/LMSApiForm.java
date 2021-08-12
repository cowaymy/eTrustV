package com.coway.trust.api.project.LMS;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : LMSApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2020. 12. 17.    MY-KAHKIT   First creation
 * </pre>
 */
@ApiModel(value = "LMSApiForm", description = "LMSApiForm")
public class LMSApiForm {

	public static Map<String, Object> createCourseMap(Map<String, Object> lmsForm){
    Map<String, Object> params = new HashMap<>();
//    params.put("key", lmsForm.getKey());
//
//    params.put("courseTitle", lmsForm.getCourseTitle());
//    params.put("courseType", lmsForm.getCourseType());
//    params.put("courseCode", lmsForm.getCourseCode());
//    params.put("courseDesc", lmsForm.getCourseDesc());
//    params.put("courseLocation", lmsForm.getCourseLocation());
//    params.put("courseStartDt", lmsForm.getCourseStartDt());
//    params.put("courseEndDt", lmsForm.getCourseEndDt());
//    params.put("courseStatus", lmsForm.getCourseStatus());
//    params.put("courseLimit", lmsForm.getCourseLimit());
//    params.put("courseCloseDt", lmsForm.getCourseCloseDt());
//    params.put("isMember", lmsForm.getIsMember());
//    params.put("MemberType", lmsForm.getMemberType());

    return params;
	}

	public static Map<String, Object> createCourseAttendMap(LMSApiForm lmsForm){
    Map<String, Object> params = new HashMap<>();
    params.put("key", lmsForm.getKey());

//    for
    params.put("courseCode", lmsForm.getCourseCode());
    params.put("username", lmsForm.getUsername());
    params.put("shirtSize", lmsForm.getShirtSize());

    return params;
	}

	public static Map<String, Object> createAttendResultMap(LMSApiForm lmsForm){
    Map<String, Object> params = new HashMap<>();
    params.put("key", lmsForm.getKey());

    params.put("username", lmsForm.getUsername());
    params.put("courseCode", lmsForm.getCourseCode());
    params.put("traningResult", lmsForm.getTrainingResult());
    params.put("cdpPoint", lmsForm.getCdpPoint());
    params.put("attendDay", lmsForm.getAttendDay());

    return params;
	}

	private String key;
	private String courseTitle;
	private String courseType;
	private String courseCode;
	private String courseDesc;
	private String courseLocation;
	private String courseStartDt;
	private String courseEndDt;
	private String courseStatus;
	private String courseLimit;
	private String courseCloseDt;
	private String isMember;
	private String memberType;

	private String username;
	private String shirtSize;

	private String trainingResult;
	private int cdpPoint;
	private int AttendDay;


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


	public String getCourseStatus() {
		return courseStatus;
	}


	public void setCourseStatus(String courseStatus) {
		this.courseStatus = courseStatus;
	}


	public String getCourseLimit() {
		return courseLimit;
	}


	public void setCourseLimit(String courseLimit) {
		this.courseLimit = courseLimit;
	}


	public String getCourseCloseDt() {
		return courseCloseDt;
	}


	public void setCourseCloseDt(String courseCloseDt) {
		this.courseCloseDt = courseCloseDt;
	}


	public String getUsername() {
		return username;
	}


	public void setUsername(String username) {
		this.username = username;
	}


	public String getShirtSize() {
		return shirtSize;
	}


	public void setShirtSize(String shirtSize) {
		this.shirtSize = shirtSize;
	}


	public String getTrainingResult() {
		return trainingResult;
	}


	public void setTrainingResult(String trainingResult) {
		this.trainingResult = trainingResult;
	}


	public int getCdpPoint() {
		return cdpPoint;
	}


	public void setCdpPoint(int cdpPoint) {
		this.cdpPoint = cdpPoint;
	}


	public int getAttendDay() {
		return AttendDay;
	}


	public void setAttendDay(int attendDay) {
		AttendDay = attendDay;
	}

	public String getIsMember() {
		return isMember;
	}

	public void setIsMember(String isMember) {
		this.isMember = isMember;
	}

	public String getMemberType() {
		return memberType;
	}

	public void setMemberType(String memberType) {
		this.memberType = memberType;
	}


//public static Map<String, Object> createAddrMap(LMSApiForm lmsForm){
//    Map<String, Object> params = new HashMap<>();
//    params.put("key", lmsForm.getKey());
//    params.put("state", lmsForm.getState());
//    params.put("postcode", lmsForm.getPostcode());
//    params.put("area", lmsForm.getArea());
//    params.put("city", lmsForm.getCity());
//    return params;
//  }


}
