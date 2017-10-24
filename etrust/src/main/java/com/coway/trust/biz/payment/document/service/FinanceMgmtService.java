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

}
