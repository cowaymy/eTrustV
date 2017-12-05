package com.coway.trust.web.services.performanceMgmt;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.performanceMgmt.SurveyMgmtService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/performanceMgmt")
public class SurveyMgmtController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SurveyMgmtController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Resource(name = "surveyMgmtService")
	private SurveyMgmtService surveyMgmtService;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/surveyMgmt.do")
	public String surveyMgmt(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		return "services/performanceMgmt/surveyMgmt";
	}
	
	@RequestMapping(value = "/selectMemberTypeList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMemberTypeList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		LOGGER.debug("params {}", params);
		List<EgovMap> selectMemberTypeList = surveyMgmtService.selectMemberTypeList();
		LOGGER.debug("selectMemberTypeList {}", selectMemberTypeList);
		return ResponseEntity.ok(selectMemberTypeList);
	}
	
	@RequestMapping(value = "/selectSurveyStusList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSurveyStusList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		LOGGER.debug("params {}", params);
		List<EgovMap> selectSurveyStusList = surveyMgmtService.selectSurveyStusList();
		LOGGER.debug("selectSurveyStusList {}", selectSurveyStusList);
		return ResponseEntity.ok(selectSurveyStusList);
	}
	
	@RequestMapping(value = "/selectSurveyEventList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectSurveyEventList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		List<EgovMap> selectSurveyEventList = null; 
		selectSurveyEventList = surveyMgmtService.selectSurveyEventList(params);
		return ResponseEntity.ok(selectSurveyEventList);
	}

}
