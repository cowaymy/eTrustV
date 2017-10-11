package com.coway.trust.biz.payment.autodebit.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EnrollService
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
	 * EnrollmentDetView 조회
	 * @param params
	 * @return
	 */
    List<EgovMap> selectEnrollmentDetView(Map<String, Object> params);
   
}
