package com.coway.trust.biz.payment.refund.service;

import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface RefundService {
	
	List<EgovMap> selectRefundList(Map<String, Object> params);
	
	EgovMap selectRefundInfo(Map<String, Object> params);
	
	List<EgovMap> selectCodeList(Map<String, Object> params);
	
	List<EgovMap> selectBankCode();
	

}
