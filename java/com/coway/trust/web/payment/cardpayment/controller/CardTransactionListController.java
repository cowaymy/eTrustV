package com.coway.trust.web.payment.cardpayment.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.coway.trust.biz.payment.cardpayment.service.CardTransactionListService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CardTransactionListController.java
 * @Description : Card Transaction Raw Data List Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 30.   KR-OHK        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/payment")
public class CardTransactionListController {

	private static final Logger logger = LoggerFactory.getLogger(CardTransactionListController.class);

	@Autowired
	private CardTransactionListService cardTransactionListService;

	@RequestMapping(value = "/initCardTransactionListList.do")
	public String initCardTransactionListList(ModelMap model) throws Exception {
		return "payment/cardpayment/cardTransactionList";
	}

	@RequestMapping(value = "/selectCardTransactionList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCardTransactionList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> requestList = cardTransactionListService.selectCardTransactionList(params);

		return ResponseEntity.ok(requestList);
	}
}
