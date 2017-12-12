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

import com.coway.trust.biz.services.performanceMgmt.HappyCallPlanningService;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/performanceMgmt")
public class HappyCallPlanningController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(HappyCallPlanningController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Resource(name = "happyCallPlanningService")
	private HappyCallPlanningService happyCallPlanningService;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/happyCallPlanning.do")
	public String surveyMgmt(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		return "services/performanceMgmt/happyCallPlanning";
	}
	
	@RequestMapping(value = "/selectCallTypeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCallTypeList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		LOGGER.debug("params {}", params);
		List<EgovMap> selectCallTypeList = happyCallPlanningService.selectCallTypeList();
		LOGGER.debug("selectCallTypeList {}", selectCallTypeList);
		return ResponseEntity.ok(selectCallTypeList);
	}
	
//	@RequestMapping(value = "/selectSurveyStusList", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> selectSurveyStusList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
//		LOGGER.debug("params {}", params);
//		List<EgovMap> selectSurveyStusList = surveyMgmtService.selectSurveyStusList();
//		LOGGER.debug("selectSurveyStusList {}", selectSurveyStusList);
//		return ResponseEntity.ok(selectSurveyStusList);
//	}
//	
//	@RequestMapping(value = "/selectSurveyEventList", method = RequestMethod.GET) 
//	public ResponseEntity<List<EgovMap>> selectSurveyEventList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
//		List<EgovMap> selectSurveyEventList = null; 
//		selectSurveyEventList = surveyMgmtService.selectSurveyEventList(params);
//		return ResponseEntity.ok(selectSurveyEventList);
//	}
//	
//	@RequestMapping(value = "/surveyEventCreatePop.do")
//	public String surveyEventCreatePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
//		return "services/performanceMgmt/surveyEventCreatePop";
//	}
//	
//
//	@RequestMapping(value = "/saveSurveyEventCreate.do", method = RequestMethod.POST)
//	public  ResponseEntity<ReturnMessage> saveSurveyEventCreate(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
//
//		String dt = CommonUtils.getNowDate();	
//
//		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
//		String loginId = "";
//		if(sessionVO==null){
//			loginId="1000000000";			
//		}else{
//			loginId=String.valueOf(sessionVO.getUserId());
//		}
//		
//		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
//		
//		int cnt = 0;
//		
//		if (addList.size() > 0) {			
//			cnt = surveyMgmtService.addSurveyEventCreate(addList, loginId);
//		}
//		
//		model.addAttribute("searchDt", dt);
//
//		// 결과 만들기 예.
//		ReturnMessage message = new ReturnMessage();
//		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
//		return ResponseEntity.ok(message);
//	}
//	
//	
//	@RequestMapping(value = "/getCodeNameList.do", method = RequestMethod.GET)
//	public ResponseEntity<List<EgovMap>> getCodeNameList(@RequestParam Map<String, Object> params) {
//		Precondition.checkNotNull(params.get("codeId"),
//				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "codeId" }));
//
//		LOGGER.debug("codeId : {}", params.get("codeId"));
//
//		List<EgovMap> codeNameList = surveyMgmtService.getCodeNameList(params);
//		return ResponseEntity.ok(codeNameList);
//	}
//	
//	
//	@RequestMapping(value = "/saveSurveyEventTarget.do", method = RequestMethod.POST)
//	public  ResponseEntity<ReturnMessage> saveSurveyEventTarget(@RequestBody Map<String, Map<String, ArrayList<Object>>> params, Model model) {
//
//		String dt = CommonUtils.getNowDate();	
//
//		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
//		String loginId = "";
//		if(sessionVO==null){
//			loginId="1000000000";			
//		}else{
//			loginId=String.valueOf(sessionVO.getUserId());
//		}
//		
//		surveyMgmtService.addSurveyEventTarget(params, loginId);
//		
//		// 결과 만들기 예.
//		ReturnMessage message = new ReturnMessage();
//		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
//		return ResponseEntity.ok(message);
//	}

}
