package com.coway.trust.web.services.performanceMgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.performanceMgmt.SurveyMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.Precondition;

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
	
	@RequestMapping(value = "/surveyEventCreatePop.do")
	public String surveyEventCreatePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		return "services/performanceMgmt/surveyEventCreatePop";
	}
	

	@RequestMapping(value = "/saveSurveyEventCreate.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage> saveSurveyEventCreate(@RequestBody Map<String, ArrayList<Object>> params, Model model) {

		String dt = CommonUtils.getNowDate();	

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";			
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}
		
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		
		int cnt = 0;
		
		if (addList.size() > 0) {			
			cnt = surveyMgmtService.addSurveyEventCreate(addList, loginId);
		}
		
		model.addAttribute("searchDt", dt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/getCodeNameList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getCodeNameList(@RequestParam Map<String, Object> params) {
		Precondition.checkNotNull(params.get("codeId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "codeId" }));

		LOGGER.debug("codeId : {}", params.get("codeId"));

		List<EgovMap> codeNameList = surveyMgmtService.getCodeNameList(params);
		return ResponseEntity.ok(codeNameList);
	}
	
	
	@RequestMapping(value = "/saveSurveyEventTarget.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage> saveSurveyEventTarget(@RequestBody Map<String, Map<String, ArrayList<Object>>> params, Model model) {

		String dt = CommonUtils.getNowDate();	

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";			
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}
		
		LOGGER.debug("params ======================================================={}", params);
		
		surveyMgmtService.addSurveyEventTarget(params, loginId);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/selectEvtMemIdList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectEvtMemIdList(@RequestParam Map<String, Object> params) {
		Precondition.checkNotNull(params.get("memId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "memId" }));

		LOGGER.debug("memId : {}", params.get("memId"));

		List<EgovMap> memIdList = surveyMgmtService.selectEvtMemIdList(params);
		return ResponseEntity.ok(memIdList);
	}

	
	@RequestMapping(value = "/selectSalesOrdNotList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSalesOrdNotList(@RequestParam(value = "salesOrdNo[]") String[] salesOrdNo , @RequestParam Map<String, Object> params) throws Exception{
		
		//param Setting
		params.put("salesOrdNo", salesOrdNo);
		LOGGER.debug("salesOrdNo : {}", params.get("salesOrdNo"));
		List<EgovMap> filterList = null;
		filterList = surveyMgmtService.selectSalesOrdNotList(params);

		return ResponseEntity.ok(filterList);
		
	}
	
	@RequestMapping(value = "/selectSalesOrdNotList2.do")
	//public ResponseEntity<EgovMap> selectSalesOrdNotList(@RequestParam(value = "salesOrdNo[]") String[] salesOrdNo , @RequestParam Map<String, Object> params) throws Exception{
	public ResponseEntity<EgovMap> selectSalesOrdNotList2( @RequestParam Map<String, Object> params){
		
		LOGGER.debug("params : {}", params.get("salesOrdNo"));
		String son = null;
		if(params.get("salesOrdNo")!=null){
			son = params.get("salesOrdNo").toString();
		}
		//EgovMap filterList = new EgovMap();
		EgovMap filterList = null;
		filterList = surveyMgmtService.selectSalesOrdNotList2(params);
		if(filterList==null&&son.length()>0){
			
			System.out.println(son);
			filterList = new EgovMap();
			filterList.put("salesOrdNo", son);
			filterList.put("name", null);
		}
		LOGGER.debug("filterList : {}", filterList);
		return ResponseEntity.ok(filterList);
		
	}
	
	@RequestMapping(value = "/surveyEventDisplayPop.do")
	public String surveyEventDisplayPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		model.addAttribute("popEvtTypeDesc", params.get("popEvtTypeDesc").toString());
		model.addAttribute("popMemCode", params.get("popMemCode").toString());
		model.addAttribute("popCodeDesc", params.get("popCodeDesc").toString());
		model.addAttribute("popEvtDt", params.get("popEvtDt").toString());
		model.addAttribute("popEvtId", params.get("popEvtId").toString());
		
		return "services/performanceMgmt/surveyEventDisplayPop";
	}
	
	@RequestMapping(value = "/selectSurveyEventDisplayInfoList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectSurveyEventDisplayInfoList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		List<EgovMap> selectSurveyEventDisplayInfoList = null; 
		LOGGER.debug("params =====================================>>  " + params);
		selectSurveyEventDisplayInfoList = surveyMgmtService.selectSurveyEventDisplayInfoList(params);
		return ResponseEntity.ok(selectSurveyEventDisplayInfoList);
	}
	
	@RequestMapping(value = "/selectSurveyEventDisplayQList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectSurveyEventDisplayQList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		List<EgovMap> selectSurveyEventDisplayQList = null; 
		selectSurveyEventDisplayQList = surveyMgmtService.selectSurveyEventDisplayQList(params);
		return ResponseEntity.ok(selectSurveyEventDisplayQList);
	}
	
	@RequestMapping(value = "/selectSurveyEventDisplayTargetList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectSurveyEventDisplayTargetList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		List<EgovMap> selectSurveyEventDisplayTargetList = null; 
		selectSurveyEventDisplayTargetList = surveyMgmtService.selectSurveyEventDisplayTargetList(params);
		return ResponseEntity.ok(selectSurveyEventDisplayTargetList);
	}
	
	@RequestMapping(value = "/surveyEventEditPop.do")
	public String surveyEventEditPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		model.addAttribute("popEvtTypeDesc", params.get("popEvtTypeDesc").toString());
		model.addAttribute("popMemCode", params.get("popMemCode").toString());
		model.addAttribute("popCodeDesc", params.get("popCodeDesc").toString());
		model.addAttribute("popEvtDt", params.get("popEvtDt").toString());
		model.addAttribute("popEvtId", params.get("popEvtId").toString());
		
		return "services/performanceMgmt/surveyEventEditPop";
	}
	
	@RequestMapping(value = "/saveEditedSurveyEventTarget.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage> saveEditedSurveyEventTarget(@RequestBody Map<String, Map<String, ArrayList<Object>>> params, Model model) {

		String dt = CommonUtils.getNowDate();	

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";			
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}
		
		LOGGER.debug("Edited params ======================================================={}", params);
		
		surveyMgmtService.addEditedSurveyEventTarget(params, loginId);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	

}
