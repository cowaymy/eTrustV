package com.coway.trust.web.sales.customer;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.customer.ExpiredCustomerService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/customer")
public class ExpiredCustomerController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ExpiredCustomerController.class);

	@Resource(name = "expiredCustomerService")
	private ExpiredCustomerService expiredCustomerService;

	@RequestMapping(value="/expiredCustomerListing.do")
	public String getExpiredCustomerList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		return "sales/customer/expiredCustomerListing";
	}

	@RequestMapping(value="/selectExpiredCustomerList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectExpiredCustomerJsonList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		LOGGER.debug("selectExpiredCustomerList.do");
		LOGGER.debug("params :: " + params);

		String[] arrRentStus = request.getParameterValues("rentStus");
		String[] arrExpMth = request.getParameterValues("expMth");

		if(arrRentStus != null && !CommonUtils.containsEmpty(arrRentStus)) {
			params.put("arrRentStus", arrRentStus);
		}

		if(arrExpMth != null && !CommonUtils.containsEmpty(arrExpMth)) {
			params.put("arrExpMth", arrExpMth);
		}

		List<EgovMap> expiredCustomerList = null;
		expiredCustomerList = expiredCustomerService.selectExpiredCustomerList(params);

		return ResponseEntity.ok(expiredCustomerList);
	}

}
