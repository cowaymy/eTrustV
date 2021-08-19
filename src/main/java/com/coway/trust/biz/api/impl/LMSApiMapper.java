package com.coway.trust.biz.api.impl;


/**************************************
 * Author                  Date                    Remark
 * Chew Kah Kit        2020/12/16           API for Common
 ***************************************/

import java.util.Map;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("LMSApiMapper")
public interface LMSApiMapper {

	EgovMap selectCourseId(Map<String, Object> params);

	EgovMap selectMemId(Map<String, Object> params);

	EgovMap selectAplicantId(Map<String, Object> params);

	void registerCourse(Map<String, Object> params);

	void updateAttendee(Map<String, Object> params);

	EgovMap selectDocNoMap(Map<String, Object> params);

}
