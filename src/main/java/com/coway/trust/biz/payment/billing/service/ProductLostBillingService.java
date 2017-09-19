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
	
}
