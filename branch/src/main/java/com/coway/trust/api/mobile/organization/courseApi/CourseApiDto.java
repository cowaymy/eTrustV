package com.coway.trust.api.mobile.organization.courseApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

/**
 * @ClassName : CourseApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "CourseApiDto", description = "CourseApiDto")
public class CourseApiDto {



	@SuppressWarnings("unchecked")
	public static CourseApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, CourseApiDto.class);
	}



	public static Map<String, Object> createMap(CourseApiDto param){
		Map<String, Object> params = new HashMap<>();
		params.put("coursCode", param.getCoursCode());
		params.put("coursName", param.getCoursName());
		params.put("coursLocation", param.getCoursLocation());
		params.put("coursTypeName", param.getCoursTypeName());
		params.put("coursLimit", param.getCoursLimit());
		params.put("coursJoinCnt", param.getCoursJoinCnt());
		params.put("coursFromDate", param.getCoursFromDate());
		params.put("coursToDate", param.getCoursToDate());
		params.put("coursClsDt", param.getCoursClsDt());
		params.put("coursStatus", param.getCoursStatus());
		params.put("coursId", param.getCoursId());
		params.put("memId", param.getMemId());
		params.put("nric", param.getNric());
		params.put("name", param.getName());
		params.put("saveFlag", param.getSaveFlag());
		params.put("coursItmId", param.getCoursItmId());
		return params;
	}



	private String coursCode;
	private String coursName;
	private String coursTypeName;
	private String coursLocation;
    private int coursJoinCnt;
	private int coursLimit;
	private String coursFromDate;
	private String coursToDate;
	private String coursClsDt;
	private int coursId;
    private String coursStatus;
	private int memId;
	private String nric;
	private String name;
	private String saveFlag;
	private int coursItmId;



	public String getCoursCode() {
		return coursCode;
	}

	public void setCoursCode(String coursCode) {
		this.coursCode = coursCode;
	}

	public String getCoursName() {
		return coursName;
	}

	public void setCoursName(String coursName) {
		this.coursName = coursName;
	}

	public String getCoursTypeName() {
		return coursTypeName;
	}

	public void setCoursTypeName(String coursTypeName) {
		this.coursTypeName = coursTypeName;
	}

	public String getCoursLocation() {
		return coursLocation;
	}

	public void setCoursLocation(String coursLocation) {
		this.coursLocation = coursLocation;
	}

	public int getCoursLimit() {
		return coursLimit;
	}

	public void setCoursLimit(int coursLimit) {
		this.coursLimit = coursLimit;
	}

	public int getCoursJoinCnt() {
		return coursJoinCnt;
	}

	public void setCoursJoinCnt(int coursJoinCnt) {
		this.coursJoinCnt = coursJoinCnt;
	}

	public String getCoursFromDate() {
		return coursFromDate;
	}

	public void setCoursFromDate(String coursFromDate) {
		this.coursFromDate = coursFromDate;
	}

	public String getCoursToDate() {
		return coursToDate;
	}

	public void setCoursToDate(String coursToDate) {
		this.coursToDate = coursToDate;
	}

	public String getCoursStatus() {
		return coursStatus;
	}

	public void setCoursStatus(String coursStatus) {
		this.coursStatus = coursStatus;
	}

	public int getCoursId() {
		return coursId;
	}

	public void setCoursId(int coursId) {
		this.coursId = coursId;
	}

	public int getMemId() {
		return memId;
	}

	public void setMemId(int memId) {
		this.memId = memId;
	}

	public String getNric() {
		return nric;
	}

	public void setNric(String nric) {
		this.nric = nric;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSaveFlag() {
		return saveFlag;
	}

	public void setSaveFlag(String saveFlag) {
		this.saveFlag = saveFlag;
	}

	public int getCoursItmId() {
		return coursItmId;
	}

	public void setCoursItmId(int coursItmId) {
		this.coursItmId = coursItmId;
	}

	public String getCoursClsDt() {
		return coursClsDt;
	}

	public void setCoursClsDt(String coursClsDt) {
		this.coursClsDt = coursClsDt;
	}
}
