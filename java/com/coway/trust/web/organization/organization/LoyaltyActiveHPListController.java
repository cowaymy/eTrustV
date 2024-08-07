package com.coway.trust.web.organization.organization;

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

import com.coway.trust.biz.organization.organization.LoyaltyActiveHPListService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/organization")
public class LoyaltyActiveHPListController {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoyaltyActiveHPListController.class);

	@Resource(name = "loyaltyActiveHPListService")
	private LoyaltyActiveHPListService loyaltyActiveHPListService;

	@RequestMapping(value = "/loyaltyActiveHPList.do")
	public String loyaltyActiveHPList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "organization/organization/loyaltyActiveHPListing";
	}

	@RequestMapping(value = "/selectLoyaltyActiveHPList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLoyaltyActiveHPList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		LOGGER.debug("selectLoyaltyActiveHPList.do");
		LOGGER.debug("params :: " + params);

		List<EgovMap> loyaltyActiveHPList = null;
		loyaltyActiveHPList = loyaltyActiveHPListService.selectLoyaltyActiveHPList(params);

		return ResponseEntity.ok(loyaltyActiveHPList);
	}



}
