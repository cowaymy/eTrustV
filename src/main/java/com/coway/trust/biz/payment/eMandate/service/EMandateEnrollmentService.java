package com.coway.trust.biz.payment.eMandate.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface EMandateEnrollmentService {

	int checkValidCustomer (Map<String, Object> params);

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


}
