package com.coway.trust.biz.payment.common.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("commonPopupPaymentMapper")
public interface CommonPopupPaymentMapper {	
	
	/**
	 * Payment - Invoice Search Pop-up 리스트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectCommonSearchInvoicePop(Map<String, Object> params);
	
	/**
	 * Payment - Rental Membership Search Pop-up 리스트 조회
	 * @param 
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectCommonContractSearchPop(Map<String, Object> params);
	
}
