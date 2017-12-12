package com.coway.trust.web.services.tagMgmt;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.web.services.servicePlanning.MileageCalculationController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/tagMgmt")
public class TagMgmtController {
	
	private static final Logger logger = LoggerFactory.getLogger(MileageCalculationController.class);

	@Resource(name = "tagMgmtService")
	TagMgmtService tagMgmtService;
	
	
	@RequestMapping(value = "/tagManagement.do")
	public String viewTagMangement (@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);
		// 호출될 화면
		return "services/tagMgmt/tagMgmtList";
	}
	
	@RequestMapping(value = "/tagLogRegistPop.do")
	public String viewTagLogRegistPop (@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);
		// 호출될 화면
		return "services/tagMgmt/tagLogListPop";
	}
	
	
	
	@RequestMapping(value = "/selectTagStatus")
	 ResponseEntity<List<EgovMap>> getTagStatus(@RequestParam Map<String, Object> params) {
		logger.debug("paramsJINMU {}", params);
		List<EgovMap> notice = tagMgmtService.getTagStatus(params);
		logger.debug("paramsJINMU {}", notice );
		return ResponseEntity.ok(notice);
	}
	
	
	
	
	
}
