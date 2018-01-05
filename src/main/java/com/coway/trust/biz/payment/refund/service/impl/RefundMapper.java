package com.coway.trust.biz.payment.refund.service.impl;

import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("refundMapper")
public interface RefundMapper {
	
	List<EgovMap> selectRefundList(Map<String, Object> params);
	
	EgovMap selectRefundInfo(Map<String, Object> params);
	
	List<EgovMap> selectRefundItem(Map<String, Object> params);
	
	List<EgovMap> selectCodeList(Map<String, Object> params);
	
	List<EgovMap> selectBankCode();
	

}
