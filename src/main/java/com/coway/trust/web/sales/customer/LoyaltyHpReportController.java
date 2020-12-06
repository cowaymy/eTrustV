package com.coway.trust.web.sales.customer;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value = "/sales/customer")
public class LoyaltyHpReportController {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoyaltyHpReportController.class);

	@RequestMapping(value = "/loyaltyHpReport.do")
	public String loyaltyHpReport(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);

		model.addAttribute("today", today);

		return "sales/customer/loyaltyHpReport";
	}

}
