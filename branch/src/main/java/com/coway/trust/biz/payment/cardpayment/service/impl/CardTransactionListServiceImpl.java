package com.coway.trust.biz.payment.cardpayment.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.payment.cardpayment.service.CardTransactionListService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CardTransactionListServiceImpl.java
 * @Description : Card Transaction Raw Data List Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-OHK        First creation
 * </pre>
 */
@Service("cardTransactionListService")
public class CardTransactionListServiceImpl implements CardTransactionListService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CardTransactionListServiceImpl.class);

	@Resource(name = "cardTransactionListMapper")
	private CardTransactionListMapper cardTransactionListMapper;

	@Override
	public List<EgovMap> selectCardTransactionList(Map<String, Object> params) {
		return cardTransactionListMapper.selectCardTransactionList(params);
	}

}
