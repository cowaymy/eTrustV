package com.coway.trust.biz.payment.autodebit.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EnrollResultService
{

    /**
  	 * Search Enrollment Result List(Master Grid) 조회
  	 * @param params
  	 * @return
  	 */
      List<EgovMap> selectEnrollmentResultrList(Map<String, Object> params);

      /**
  	 * Search Enrollment Info(Master Grid) & Item조회
  	 * @param params
  	 * @return
  	 */
      Map<String, Object> selectEnrollmentInfo(int params);

      /**
     	 * Enrollment저장
     	 * @param params
     	 * @return
     	 */
     // String saveNewEnrollment(List<Object> gridList, Map<String, Object> formList);

      public List<EgovMap> saveNewEnrollment(EnrollmentUpdateMVO enrollMaster, List<EnrollmentUpdateDVO> enrollDList, int updateType);

	/**
	 *
	 * @author HQIT-HUIDING
	 * Oct 25, 2023
	 */
	List<EgovMap> saveNewEnrollment(EnrollmentUpdateMVO enrollMaster, List<EnrollmentUpdateDVO> enrollDList, int updateType, String ddType);

	/**
	 *
	 * @author HQ-HUIDING
	 * Jan 24, 2024
	 */
	EgovMap selectBankCode(String bankCode);

	List<EgovMap> selectAutoDebitDeptUserId(Map<String, Object> params);
	List<EgovMap> selectDdaCsv(Map<String, Object> params);
	List<EgovMap> selectDdaCsvDailySeqCount(Map<String, Object> params);
}
