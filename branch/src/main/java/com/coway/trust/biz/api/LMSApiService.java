package com.coway.trust.biz.api;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2019/04/11           API for customer portal
 *
 ***************************************/

import com.coway.trust.api.project.LMS.LMSApiDto;
import com.coway.trust.api.project.LMS.LMSApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LMSApiService {

  EgovMap insertCourse(HttpServletRequest request,Map<String, Object> lmsApiForm) throws Exception;
  EgovMap updateCourse(HttpServletRequest request,Map<String, Object> lmsApiForm) throws Exception;
  EgovMap updateCourseAttend(HttpServletRequest request, Map<String, Object> lmsApiForm) throws Exception;
  EgovMap updateAttendResult(HttpServletRequest request,Map<String, Object> lmsApiForm) throws Exception;

}
