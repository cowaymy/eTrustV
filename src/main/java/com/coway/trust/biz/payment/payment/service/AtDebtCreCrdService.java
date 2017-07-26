package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AtDebtCreCrdService
{

	
	/**
	 * selectEnrollmentList(Master Grid) 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectEnrollmentList(Map<String, Object> params);
    
    /**
	 * 글 상세조회를 한다. EnrollInfo
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 
	 * @exception Exception
	 */
	EgovMap selectViewEnrollment(Map<String, Object> params);
	
	/**
	 * SearchPayment Order List(Master Grid) 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectViewEnrollmentList(Map<String, Object> params);
    
    /**
   	 * Save Enroll
   	 * 
   	 * @param pstRequestVO
   	 *            
   	 * @return 
   	 * @exception Exception
   	 */
    Map<String, Object> saveEnroll(Map<String, Object> param);
    
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
      String saveNewEnrollment(List<Object> gridList, Map<String, Object> formList);
   
}
