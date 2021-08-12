package com.coway.trust.biz.payment.cardpayment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CardTransactionListService.java
 * @Description : Card Transaction Raw Data List Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-OHK        First creation
 * </pre>
 */
public interface CardTransactionListService {

	List<EgovMap> selectCardTransactionList(Map<String, Object> params);

}
