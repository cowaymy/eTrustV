package com.coway.trust.biz.eAccounting.creditCard;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CreditCardService {
	
	List<EgovMap> selectCrditCardMgmtList(Map<String, Object> params);

}
