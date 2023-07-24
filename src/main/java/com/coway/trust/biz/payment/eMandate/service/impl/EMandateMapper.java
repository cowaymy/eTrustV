package com.coway.trust.biz.payment.eMandate.service.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * eMandate - paperless
 * @author HQIT-HUIDING
 * Jul 13, 2023
 */
@Mapper("eMandateMapper")
public interface EMandateMapper {

	int checkOrderWithConditions(Map<String, Object> params);
	EgovMap getNextPaymentId(Map<String, Object> params);
	int insertDDRequest (Map<String, Object> params);
}
