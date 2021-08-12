package com.coway.trust.web.mobile.login;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.web.mobile.MobileConstants;

@Controller(value = "mobileCommonController")
@RequestMapping(value = MobileConstants.MOBILE_WEB + "/common")
public class CommonController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonController.class);

	@RequestMapping(value = "/main.do")
	public String login(@RequestParam Map<String, Object> params, ModelMap model) {
		LOGGER.debug("/m/common/main.do....");
		return "mobile/main";
	}
}
