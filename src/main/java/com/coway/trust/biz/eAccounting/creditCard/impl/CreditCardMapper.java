package com.coway.trust.biz.eAccounting.creditCard.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("creditCardMapper")
public interface CreditCardMapper {
	
	List<EgovMap> selectCrditCardMgmtList(Map<String, Object> params);
	
	List<EgovMap> selectBankCode();
	
	int selectNextCrditCardSeq();
	
	void insertCreditCard(Map<String, Object> params);
	
	String selectNextIfKey();
	
	int selectNextSeq(String ifKey);
	
	void insertCrditCardInterface(Map<String, Object> params);
	
	EgovMap selectCrditCardInfo(Map<String, Object> params);
	
	void updateCreditCard(Map<String, Object> params);
	
	void removeCreditCard(Map<String, Object> params);
	
	List<EgovMap> selectReimbursementList(Map<String, Object> params);

}
