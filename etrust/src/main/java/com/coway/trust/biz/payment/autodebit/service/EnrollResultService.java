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
}
