package com.coway.trust.web.services.tagMgmt;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.web.services.servicePlanning.MileageCalculationController;

@Controller
@RequestMapping(value = "/services/tagMgmt")
public class TagMgmtListController {
	
	private static final Logger logger = LoggerFactory.getLogger(MileageCalculationController.class);

	@RequestMapping(value = "/tagManagement.do")
	public String viewTagMangement (@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);
		// 호출될 화면
		return "services/tagMgmt/tagMgmtList";
	}
	
	@RequestMapping(value = "/tagLogRegist.do")
	public String viewTagLogRegist (@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);
		// 호출될 화면
		return "services/tagMgmt/tagLogList";
	}
	
	
	
	
	
}
