package com.coway.trust.biz.payment.cardpayment.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CardTransactionListMapper.java
 * @Description : Card Transaction Raw Data List Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-OHK        First creation
 * </pre>
 */
@Mapper("cardTransactionListMapper")
public interface CardTransactionListMapper {

	List<EgovMap> selectCardTransactionList(Map<String, Object> params);

}
