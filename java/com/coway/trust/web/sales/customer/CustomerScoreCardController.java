package com.coway.trust.web.sales.customer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.biz.sales.customer.CustomerScoreCardService;
import com.coway.trust.biz.sales.customer.Customer360ScoreCardService;
import com.coway.trust.biz.sales.customer.CustomerVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.biz.sales.customer.Customer360VO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/customer")
public class CustomerScoreCardController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerScoreCardController.class);

	@Resource(name = "customerScoreCardService")
	  private CustomerScoreCardService customerScoreCardService;

	@Resource(name = "customer360ScoreCardService")
    private Customer360ScoreCardService customer360ScoreCardService;

	/**
	 * Customer Score Card List
	 *
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/CustomerScoreCardList.do")
	public String CustomerScoreCardList(@ModelAttribute("customerVO") CustomerVO customerVO,
			@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {

		params.put("memId", sessionVO.getMemId());
		String memType = customerScoreCardService.getMemType(params);
		model.addAttribute("memType", memType);


		return "sales/customer/CustomerScoreCardList";
	}
	/**
	 * Customer Score Card List Search
	 *
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerScoreCardList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> CustomerScoreCardJsonList(@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model,SessionVO sessionVO) {

		List<EgovMap> customerScoreCardList = customerScoreCardService.customerScoreCardList(params);

		return ResponseEntity.ok(customerScoreCardList);
	}

// 360° Enhancement
    @RequestMapping(value = "/Customer360ScoreCardList.do")
    public String Customer360ScoreCardList(@ModelAttribute("customer360VO") CustomerVO customerVO,
            @RequestParam Map<String, Object> params, ModelMap model) {

        return "sales/customer/Customer360ScoreCardList";
    }
    @RequestMapping(value = "/customer360ScoreCardList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> Customer360ScoreCardJsonList(@RequestParam Map<String, Object> params,
            HttpServletRequest request, ModelMap model) {

        List<EgovMap> customer360ScoreCardList = customer360ScoreCardService.customer360ScoreCardList(params);

        return ResponseEntity.ok(customer360ScoreCardList);
    }
// 360° Enhancement

}
