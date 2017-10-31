package com.coway.trust.biz.eAccounting.creditCard.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("creditCardMapper")
public interface CreditCardMapper {
	
	List<EgovMap> selectCrditCardMgmtList(Map<String, Object> params);

}
