package com.coway.trust.web.services.tagMgmt;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.tagMgmt.TagMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
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
		logger.debug("paramsJINMU1 {}", params);
		EgovMap tagMgmtDetail = tagMgmtService.getDetailTagStatus(params);
		model.addAttribute("tagMgmtDetail" , tagMgmtDetail );
		logger.debug("paramsJINMU1 {}", tagMgmtDetail );
		
		List<EgovMap> remarks = tagMgmtService.getTagRemark(params);
		model.addAttribute("remarks" , remarks );
		return "services/tagMgmt/tagLogListPop";
	}
	
	
	
	@RequestMapping(value = "/selectTagStatus")
	 ResponseEntity<List<EgovMap>> getTagStatus(@RequestParam Map<String, Object> params) {
		logger.debug("paramsJINMU {}", params);
		List<EgovMap> notice = tagMgmtService.getTagStatus(params);
		logger.debug("paramsJINMU {}", notice );
		return ResponseEntity.ok(notice);
	}
	

	@RequestMapping(value = "/getRemarkResults.do")
	 ResponseEntity<List<EgovMap>> getRemarks(@RequestParam Map<String, Object> params) {
		logger.debug("paramsJINMU4 {}", params);
		List<EgovMap>  remarks= tagMgmtService.getTagRemark(params);
		logger.debug("paramsJINMU5 {}", remarks);
		return ResponseEntity.ok(remarks);
	}
	
	@RequestMapping(value = "/addRemarkResult.do" , method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> addRemarkResult (@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO)  throws ParseException {
		ReturnMessage message = new ReturnMessage();	
		logger.debug("paramsJINMU3 {}", params);
		
		int remarkResult =	tagMgmtService.addRemarkResult(params, sessionVO );
		
		if(remarkResult == 2){
			message.setMessage("success");
		}
		else{
			message.setMessage("fail");
		}

		
		
		return ResponseEntity.ok(message);
		
		
		
}
	
	
}
