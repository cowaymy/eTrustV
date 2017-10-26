package com.coway.trust.biz.payment.document.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface FinanceMgmtService
{
	/**
	 * selectReceiveList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectReceiveList(Map<String, Object> params);
	
	/**
	 * CreditCardList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCreditCardList(Map<String, Object> params);
	
	/**
	 * paymentItemList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDocItemPaymentItem(Map<String, Object> params);
	
	/**
	 * PaymentItem에 대한 Log 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectLogItemPaymentItem(Map<String, Object> params);
	
	/**
	 * BatchId에 의한 PayDoc조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPayDocBatchById(Map<String, Object> params);
	
	/**
	 * paymentItem2List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDocItemPaymentItem2(Map<String, Object> params);
	
	/**
	 * PayDocList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectPayDocumentDetail(Map<String, Object> params);
	
	/**
	 * PayDocList 저장
	 * @param params
	 * @return
	 */
	Map<String, Object> savePayDoc(List<Map<String, Object>> list, String remark);
	
	/**
	 * PayDocDetail 업데이트
	 * @param params
	 * @return
	 */
	void updatePayDocDetail(Map<String, Object> params);
	
	/**
	 * Log에 저장
	 * @param params
	 * @return
	 */
	void insertPaymentDocLog(Map<String, Object> params);
	
	/**
	 * PayDoc 타입별 누적 갯수 조회
	 * @param params
	 * @return
	 */
	int countPayDocDetail(Map<String, Object> params);
	
	/**
	 *  PayDocMaster 업데이트
	 * @param params
	 * @return
	 */
	void updatePayDocMaster(Map<String, Object> params);

}
