package com.coway.trust.biz.payment.billing.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ProductLostBillingService{
	/**
	 * RentalProductLostPenalty 정보 조회
	 * @param
	 * @return
	 */
	List<EgovMap> selectRentalProductLostPenalty(String param);
	
	/**
	 * ZRLocationId 가져오기
	 * @param
	 * @return
	 */
	String getZRLocationId(String param);
	
	/**
	 * RSCertificationId 가져오기
	 * @param
	 * @return
	 */
	String getRSCertificateId(String param);
	
	/**
	 * createBill
	 * @param
	 * @return
	 */
	String doSaveProductLostPenalty(Map<String, Object> ledger, Map<String, Object> orderbill, Map<String, Object> invoiceM, Map<String, Object>invoiceD);
	
	/**
	 * DocNumber얻어옴
	 * @param
	 * @return
	 */
	String getDocNumberForProductLost(String param);
	
	/**
	 * ledger저장
	 * @param
	 * @return
	 */
	void insertLedger(Map<String, Object> ledger); 
	
	/**
	 * orderBill저장
	 * @param
	 * @return
	 */
	void insertOrderBill(Map<String, Object> orderbill); 
	
	/**
	 * invoice Master저장
	 * @param
	 * @return
	 */
	void insertInvoiceM(Map<String, Object> invoiceM); 
	
	/**
	 * invoice Detail 저장
	 * @param
	 * @return
	 */
	void insertInvoiceD(Map<String, Object> invoiceD); 
} 
