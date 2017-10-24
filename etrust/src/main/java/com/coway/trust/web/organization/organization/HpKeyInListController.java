package com.coway.trust.web.organization.organization;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.organization.organization.HpKeyInListService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller 
@RequestMapping(value = "/organization")
public class HpKeyInListController {
	
	private static final Logger logger = LoggerFactory.getLogger(HpKeyInListController.class);

	@Resource(name = "hpKeyInListService")
	private HpKeyInListService hpKeyInListService;
	
	@Resource(name = "commonService")
	private CommonService commonService;
	
	@RequestMapping(value = "/hpKeyInList.do")
	public String inithpKeyInList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		
		List<EgovMap> reqPersonComboList = hpKeyInListService.reqPersonComboList();
		List<EgovMap> branchComboList = hpKeyInListService.branchComboList();
		
		model.addAttribute("reqPersonComboList", reqPersonComboList);
		model.addAttribute("branchComboList", branchComboList);
		
		
		return "organization/organization/hPkeyInListing";
	}

}
