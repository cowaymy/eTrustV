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

import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/services/as")
public class ASManagementListController {
	private static final Logger logger = LoggerFactory.getLogger(ASManagementListController.class);
	
	@Resource(name = "ASManagementListService")
	private ASManagementListService ASManagementListService;
	
	/**
	 * Services - AS  - AS Management List 메인 화면
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/initASManagementList.do")
	public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/as/ASManagementList";
	}
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchASManagementList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectASManagementList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params : {}", params);
		
		String[] asTypeList =  request.getParameterValues("asType");
		String[] asStatusList =  request.getParameterValues("asStatus");
		
		params.put("asTypeList",asTypeList);
		params.put("asStatusList",asStatusList);
		
		List<EgovMap> ASMList = ASManagementListService.selectASManagementList(params);
		
	
		logger.debug("ASMList : {}", ASMList);
		return ResponseEntity.ok(ASMList);
	}
	
	/**
	 * Services - AS  - ASReceiveEntry 메인화면
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ASReceiveEntryPop.do")
	public String initASReceiveEntry(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/as/ASReceiveEntryPop";
	}
	
	/**
	 * Services - AS  - ASReceiveEntry Order No search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchOrderNo.do")
	public ResponseEntity<EgovMap> selectOrderNo(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("params : {}", params);
		EgovMap basicInfo = ASManagementListService.selectOrderBasicInfo(params);
		logger.debug("basicInfo : {}", basicInfo);
		// 호출될 화면
		return ResponseEntity.ok(basicInfo);
	}
	
	/**
	 * Services - AS  - ASReceiveEntry Order No search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addASNo.do")
	public ResponseEntity<ReturnMessage> insertAddASNo(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		boolean success =false; 
		logger.debug("params : {}", params);
		success = ASManagementListService.insertASNo(params,sessionVO);
		
		// 호출될 화면
		return ResponseEntity.ok(message);
	}
	
	/**
	 * Services - AS  - ASReceiveEntry 메인화면
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ASNewResultPop.do")
	public String insertASResult(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/as/newASResultPop";
	}
	
}
