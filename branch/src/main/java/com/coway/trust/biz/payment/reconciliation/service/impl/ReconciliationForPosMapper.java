package com.coway.trust.biz.payment.reconciliation.service.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.payment.reconciliation.service.ReconciliationListVO;
import com.coway.trust.biz.payment.reconciliation.service.ReconciliationSearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ReconciliationForPosMapper")
public interface ReconciliationForPosMapper {
	
	
	
	List<EgovMap> selectPosKeyInList(Map<String, Object> paramMap);
	List<EgovMap> selectBankStateMatchList(Map<String, Object> paramMap);

	void mappingGroupPayment(Map<String, Object> params);
	void mappingBankStatement(Map<String, Object> params);
	
	List<EgovMap> selectMappedData(Map<String, Object> paramMap);
	void insertPosPaymentMatchIF(Map<String, Object> paramMap);
}
