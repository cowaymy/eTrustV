package com.coway.trust.web.services.as;

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

import com.coway.trust.biz.services.as.CompensationService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/services/compensation")

public class CompensationController {
	private static final Logger logger = LoggerFactory.getLogger(CompensationController.class);
	
	@Resource(name = "CompensationService")
	private CompensationService compensationService;

	
	@RequestMapping(value = "/compensationList.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		// 호출될 화면
		return "services/as/compensationList";
	}

	@RequestMapping(value = "/compensationCreatePop.do")
	public String createPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		logger.debug("======================================================================================");
		logger.debug("===============================compensationPop==========================================");
		logger.debug("======================================================================================");
		 
		return "services/as/compensationCreatePop";
	}
		
	
	@RequestMapping(value = "/selCompensation.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selInhouseList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("selCompensation in.............");
		logger.debug("params : {}", params);
		
		List<EgovMap> mList = null;
		//List<EgovMap> mList = compensationService.selCompensationList(params);
		
	
		logger.debug("mList : {}", mList);
		return ResponseEntity.ok(mList);
	}
	
	
}
