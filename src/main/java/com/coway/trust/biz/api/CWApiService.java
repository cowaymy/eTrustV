package com.coway.trust.biz.api;

import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.api.project.CowayWorld.CWMemDetApiDto;

/**************************************
 * Author                  Date                    Remark
 * Tang Hui Ling        2021/10/27           API for Coway world
 ***************************************/

import com.coway.trust.api.project.LMS.LMSApiDto;
import com.coway.trust.api.project.LMS.LMSApiForm;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CWApiService {

	EgovMap memDetailsInfo(HttpServletRequest request,Map<String, Object> cwApiForm) throws Exception;
	/*EgovMap updateCourse(HttpServletRequest request,Map<String, Object> lmsApiForm) throws Exception;
	EgovMap updateCourseAttend(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception;
	EgovMap updateAttendResult(HttpServletRequest request,Map<String, Object> lmsApiForm) throws Exception;

	Map<String, Object> hpMemUpdatePay(Map<String, Object> params,SessionVO sessionVO) throws ParseException;

 	Map<String, Object> lmsMemberListInsert(Map<String, Object> params);
	Map<String, Object> lmsMemberListUpdate(Map<String, Object> params);
	Map<String, Object> lmsEHPMemberListInsert(Map<String, Object> params,String memberCode);
	Map<String, Object> lmsMemberListUpdateMemCode(Map<String, Object> params);
	Map<String, Object> lmsMemberListDeact(Map<String, Object> params);
	Map<String, Object> lmsMemberListRestore(Map<String, Object> params);
	Map<String, Object> lmsReqApi(Map<String, Object> params);*/
}
