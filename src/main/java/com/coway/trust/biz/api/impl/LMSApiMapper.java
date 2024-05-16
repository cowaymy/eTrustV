package com.coway.trust.biz.api.impl;


import java.util.List;

/**************************************
 * Date                Author         Description
 * -------------       -----------      -------------
 * 2021. 08. 19.    MY-HLTANG   First creation
 ***************************************/

import java.util.Map;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("LMSApiMapper")
public interface LMSApiMapper {

	EgovMap selectCourseId(Map<String, Object> params);

	EgovMap selectActiveMemberByMemId(Map<String, Object> params);

	List<EgovMap> selectMemIdByCourse(Map<String, Object> params);

	EgovMap selectCourseByMem(Map<String, Object> params);

	EgovMap selectAplicantId(Map<String, Object> params);

	void registerCourse(Map<String, Object> params);

	void updateAttendee(Map<String, Object> params);

	EgovMap selectDocNoMap(Map<String, Object> params);

	int cntCourseCheck(Map<String, Object> params);

	void updateRookieForHp(Map<String, Object> params);

	void updateMemSupplimentFlag(Map<String, Object> params);
}
