package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("paymentListMapper")
public interface PaymentListMapper {

	
	/**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */		
	List<EgovMap> selectGroupPaymentList(Map<String, Object> params);	
	
	/**
	 * Payment List 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */		
	List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params);
	
	/**
	 * Payment List - Request DCF 정보 조회 
	 * @param params
	 * @param model
	 * @return
	 */	
    EgovMap selectReqDcfInfo(Map<String, Object> params);
	
	/**
	 * Payment List - Request DCF
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */		
	void requestDCF(Map<String, Object> params);	
	
	/**
	 * Payment List - Group Payment Rev Status 변경
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */		
	void updateGroupPaymentRevStatus(Map<String, Object> params);
	
	/**
	 * Payment List - Request DCF 리스트 조회 
	 * @param params
	 * @param model
	 * @return
	 */	
	List<EgovMap> selectRequestDCFList(Map<String, Object> params);
	
	/**
	 * Payment List - Approval / Reject DCF
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */		
	void updateStatusDCF(Map<String, Object> params);
	
	/**
	 * Payment List - Approval DCF 처리 
	 * @param params
	 * @param model
	 * @return
	 */
	void approvalDCF(Map<String, Object> params);
	
}
