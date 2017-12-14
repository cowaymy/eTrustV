package com.coway.trust.api.mobile.sales.courseList;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "CourseDto", description = "Course Dto")
public class CourseDto {
	
	@ApiModelProperty(value = "courseCode")
	private String courseCode;
	
	@ApiModelProperty(value = "courseName")
	private String courseName;
	
	@ApiModelProperty(value = "courseTypeName")
	private String courseTypeName;
	
	@ApiModelProperty(value = "courseLocation")
	private String courseLocation;
	
	@ApiModelProperty(value = "courseLimit")
	private int courseLimit;
	
	@ApiModelProperty(value = "courseJoinCnt")
	private int courseJoinCnt;
	
	@ApiModelProperty(value = "courseFromDate")
	private String courseFromDate;
	
	@ApiModelProperty(value = "courseToDate")
	private String courseToDate;
	
	@ApiModelProperty(value = "courseStatus")
	private String courseStatus;
	
	@ApiModelProperty(value = "courseId")
	private int courseId;
	

	public String getCourseCode() {
		return courseCode;
	}


	public void setCourseCode(String courseCode) {
		this.courseCode = courseCode;
	}


	public String getCourseName() {
		return courseName;
	}


	public void setCourseName(String courseName) {
		this.courseName = courseName;
	}


	public String getCourseTypeName() {
		return courseTypeName;
	}


	public void setCourseTypeName(String courseTypeName) {
		this.courseTypeName = courseTypeName;
	}


	public String getCourseLocation() {
		return courseLocation;
	}


	public void setCourseLocation(String courseLocation) {
		this.courseLocation = courseLocation;
	}


	public int getCourseLimit() {
		return courseLimit;
	}


	public void setCourseLimit(int courseLimit) {
		this.courseLimit = courseLimit;
	}


	public int getCourseJoinCnt() {
		return courseJoinCnt;
	}


	public void setCourseJoinCnt(int courseJoinCnt) {
		this.courseJoinCnt = courseJoinCnt;
	}


	public String getCourseFromDate() {
		return courseFromDate;
	}


	public void setCourseFromDate(String courseFromDate) {
		this.courseFromDate = courseFromDate;
	}


	public String getCourseToDate() {
		return courseToDate;
	}


	public void setCourseToDate(String courseToDate) {
		this.courseToDate = courseToDate;
	}


	public String getCourseStatus() {
		return courseStatus;
	}


	public void setCourseStatus(String courseStatus) {
		this.courseStatus = courseStatus;
	}


	public int getCourseId() {
		return courseId;
	}


	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}


	public static CourseDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, CourseDto.class);
	}
}
