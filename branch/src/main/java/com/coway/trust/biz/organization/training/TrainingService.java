package com.coway.trust.biz.organization.training;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TrainingService {
	
	List<EgovMap> selectCourseList(Map<String, Object> params);
	
	List<EgovMap> selectCourseStatusList();
	
	List<EgovMap> selectCourseTypeList();
	
	List<EgovMap> selectAttendeeList(Map<String, Object> params);
	
	EgovMap selectBranchByMemberId(Map<String, Object> params);
	
	void updateCourseForLimitStatus(Map<String, Object> params);
	
	void updateAttendee(Map<String, Object> params);
	
	int selectNextCoursId();
	
	void insertCourse(Map<String, Object> params);
	
	void insertAttendee(Map<String, Object> params);
	
	void deleteAttendee(Map<String, Object> params);
	
	List<EgovMap> getUploadMemList(Map<String, Object> params);
	
	EgovMap selectCourseInfo(Map<String, Object> params);
	
	void updateCourse(Map<String, Object> params);
	
	String selectLoginUserNric(int userId);
	
	int selectLoginUserMemId(int userId);
	
	List<EgovMap> selectApplicantLog(Map<String, Object> params);
	
	List<EgovMap> chkNewAttendList(Map<String, Object> params);
	
	List<EgovMap> selectCourseRequestList(Map<String, Object> params);

	EgovMap selectMemInfo(Map<String, Object> params);
	
	List<EgovMap> selectMyAttendeeList(Map<String, Object> params);
	
	void registerCourseReq(Map<String, Object> params);
	
	void cancelCourseReq(Map<String, Object> params);
	
	EgovMap getMemCodeForCourse(Map<String, Object> params);
}
