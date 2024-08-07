package com.coway.trust.biz.api;

import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 *
 ***************************************/

import com.coway.trust.api.project.LMS.LMSApiDto;
import com.coway.trust.api.project.LMS.LMSApiForm;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LMSApiService {

	EgovMap insertCourse(HttpServletRequest request,Map<String, Object> lmsApiForm) throws Exception;
	EgovMap updateCourse(HttpServletRequest request,Map<String, Object> lmsApiForm) throws Exception;
	EgovMap updateCourseAttend(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception;
	EgovMap updateAttendResult(HttpServletRequest request,Map<String, Object> lmsApiForm) throws Exception;

	Map<String, Object> hpMemUpdatePay(Map<String, Object> params,SessionVO sessionVO) throws ParseException;

 	Map<String, Object> lmsMemberListInsert(Map<String, Object> params);
	Map<String, Object> lmsMemberListUpdate(Map<String, Object> params);
	Map<String, Object> lmsEHPMemberListInsert(Map<String, Object> params,String memberCode);
	Map<String, Object> lmsMemberListUpdateMemCode(Map<String, Object> params);
	Map<String, Object> lmsMemberListDeact(Map<String, Object> params);
	Map<String, Object> lmsMemberListRestore(Map<String, Object> params);
	Map<String, Object> lmsReqApi(Map<String, Object> params);
}
