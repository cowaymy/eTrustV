package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("otherPaymentMapper")
public interface OtherPaymentMapper {


	/**
	 * Bank Statement List  조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap>selectBankStatementList(Map<String, Object> params);

	EgovMap getMemVaNo(Map<String, Object> params);
}
