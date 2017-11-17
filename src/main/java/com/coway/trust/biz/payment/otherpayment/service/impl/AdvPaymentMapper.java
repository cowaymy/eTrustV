package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("advPaymentMapper")
public interface AdvPaymentMapper {

	/**
	 * Payment 임시정보 등록하기
	 * @return
	 */
	void insertTmpPaymentInfo(Map<String, Object> params);
	
	/**
	 * Payment 임시정보 등록하기
	 * @return
	 */
	void insertTmpPaymentOnlineInfo(Map<String, Object> params);
	
	/**
	 * Payment Billing 임시정보 등록하기
	 * @return
	 */
	void insertTmpBillingInfo(Map<String, Object> params);
	
}
