package com.coway.trust.biz.payment.document.service;

import java.util.List;
import java.util.Map;
import com.coway.trust.cmmn.model.SessionVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AdminMgmtService
{

	/**
  	 * selectWaitingItemList 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectWaitingItemList(Map<String, Object> params);
	
	/**
  	 * selectReviewItemList 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectReviewItemList(Map<String, Object> params);
	
	/**
  	 * selectDocItemPayDetailList 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectDocItemPayDetailList(Map<String, Object> params);
	
	/**
  	 * saveConfirmSendWating
  	 * @param params
  	 * @return
  	 */
	String saveConfirmSendWating(List<Object> params, SessionVO sessionVO, List<Object> formList);
	
	/**
  	 * selectDocItemPayReviewDetailList 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectDocItemPayReviewDetailList(Map<String, Object> params);
	
	/**
  	 * selectLoadItemLog 조회
  	 * @param params
  	 * @return
  	 */
	List<EgovMap> selectLoadItemLog(Map<String, Object> params);
	
	/**
  	 * selectPaymentDocMs 조회
  	 * @param params
  	 * @return
  	 */
	EgovMap selectPaymentDocMs(Map<String, Object> params);
	
}
