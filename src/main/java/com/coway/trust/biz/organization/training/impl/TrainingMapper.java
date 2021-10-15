package com.coway.trust.biz.organization.training.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("trainingMapper")
public interface TrainingMapper {

	List<EgovMap> selectCourseList(Map<String, Object> params);

	List<EgovMap> selectCourseStatusList();

	List<EgovMap> selectCourseTypeList();

	List<EgovMap> selectAttendeeList(Map<String, Object> params);

	EgovMap selectBranchByMemberId(Map<String, Object> params);

	void updateCourse(Map<String, Object> params);

	void updateAttendee(Map<String, Object> params);

	void inactiveAttendee(Map<String, Object> params);

	int selectNextCoursId();

	void insertCourse(Map<String, Object> params);

	void insertAttendee(Map<String, Object> params);

	void deleteAttendee(Map<String, Object> params);

	List<EgovMap> getUploadMemList(Map<String, Object> params);

	EgovMap selectCourseInfo(Map<String, Object> params);

	String selectLoginUserNric(int userId);

	int selectLoginUserMemId(int userId);

	List<EgovMap> selectApplicantLog(Map<String, Object> params);

	int courseNricDup(Map<String, Object> params);

	List<EgovMap> selectCourseRequestList(Map<String, Object> params);

	EgovMap selectMemInfo(Map<String, Object> params);

	List<EgovMap> selectMyAttendeeList(Map<String, Object> params);

	void registerCourseReq(Map<String, Object> params);

	void cancelCourseReq(Map<String, Object> params);

	EgovMap getMemCodeForCourse(Map<String, Object> params);

	void updateRookie(Map<String, Object> params);

	EgovMap selectCourseTypeById(Map<String, Object> params);
}
