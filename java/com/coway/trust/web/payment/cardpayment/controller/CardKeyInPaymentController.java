package com.coway.trust.web.payment.cardpayment.controller;

import java.util.Map;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.biz.payment.cardpayment.service.CardStatementService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

@Controller
@RequestMapping(value = "/payment")
public class CardKeyInPaymentController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CardKeyInPaymentController.class);

	@Resource(name = "cardStatementService")
	private CardStatementService cardStatementService;

	/******************************************************
	 *  Card Key-IN Payment
	 *****************************************************/
	/**
	 *  Credit Card Key-IN Payment 초기화 화면
	 * @param params
	 * @param model
	 * @return
	 */
  @RequestMapping(value = "/initCardKeyInPayment.do")
  public String initCardKeyInPayment(@RequestParam Map<String, Object> params, ModelMap model) {
    
    String currentDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
    
    model.put("currentDay", currentDay);
    return "payment/cardpayment/cardKeyInPayment";
  }

  @RequestMapping(value = "/customerCreditCardSearchPop.do")
  public String customerCreditCardSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
    
    int custId = cardStatementService.getCustId(params);
    
    model.put("callPrgm", params.get("callPrgm"));
    model.put("custId", custId);
    
    return "sales/customer/customerCreditCardSearchPop";
  }

}
