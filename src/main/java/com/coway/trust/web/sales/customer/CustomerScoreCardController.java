package com.coway.trust.web.sales.customer;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.biz.sales.customer.CustomerScoreCardService;
import com.coway.trust.biz.sales.customer.CustomerVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/customer")
public class CustomerScoreCardController {

/*	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerScoreCardController.class);
*/
	@Resource(name = "customerScoreCardService")
	  private CustomerScoreCardService customerScoreCardService;



	/**
	 * Customer Score Card List
	 *
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/CustomerScoreCardList.do")
	public String CustomerScoreCardList(@ModelAttribute("customerVO") CustomerVO customerVO,
			@RequestParam Map<String, Object> params, ModelMap model) {

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
			HttpServletRequest request, ModelMap model) {


		List<EgovMap> customerScoreCardList = customerScoreCardService.customerScoreCardList(params);

		return ResponseEntity.ok(customerScoreCardList);
	}

}
