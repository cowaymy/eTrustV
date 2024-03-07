package com.coway.trust.biz.payment.eMandate.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EMandateEnrollmentService {

	EgovMap checkValidCustomer (Map<String, Object> params);

	/**
	 *
	 * @author HQIT-HUIDING
	 * Jul 14, 2023
	 */
	Map<String, Object> enrollCustomer(Map<String, Object> params) throws Exception;

	/**
	 *
	 * @author HQIT-HUIDING
	 * Jul 17, 2023
	 */
	void rtnRespMsg(Map<String, Object> param);

	/**
	 *
	 *
	 * @author HQIT-HUIDING
	 * Jul 24, 2023
	 */
	Map<String, Object> enrollRespond (Map<String, Object> params) throws Exception;

	/**
	 *
	 * @author HQIT-HUIDING
	 * Aug 24, 2023
	 */
	Map<String, Object> getEnrollInfoByPaymentId(String paymentId);
}
