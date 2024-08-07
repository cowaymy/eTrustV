package com.coway.trust.biz.payment.reconciliation.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ReconciliationForPosService {
	
	List<EgovMap> selectPosKeyInList(Map<String, Object> paramMap);
	List<EgovMap> selectBankStateMatchList(Map<String, Object> paramMap);
	
   void savePosKeyPaymentMapping(Map<String, Object> params);
}
