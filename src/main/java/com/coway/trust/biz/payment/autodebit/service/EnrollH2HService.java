package com.coway.trust.biz.payment.autodebit.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EnrollH2HService {

	List<EgovMap> selectEnrollmentH2H(Map<String, Object> params);

	List<EgovMap> selectEnrollmentH2HById(Map<String, Object> params);

	List<EgovMap> selectEnrollmentH2HListById(Map<String, Object> params);

	List<EgovMap> selectH2HEnrollmentSubListById(Map<String, Object> params);

	Map<String, Object> generateNewEEnrollment(Map<String, Object> param);

	Map<String, Object> deactivateEEnrollmentStatus(Map<String, Object> param);

}
