package com.coway.trust.web.organization.training;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.organization.training.TrainingService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.web.eAccounting.budget.BudgetController;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/organization/training") 
public class TrainingController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(BudgetController.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Value("${web.resource.upload.file}")
	private String uploadDir;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@Autowired
	private TrainingService trainingService;
	
	@RequestMapping(value = "/trainingCourse.do")
	public String trainingCourse (@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> courseStatusList = trainingService.selectCourseStatusList();
		
		model.addAttribute("courseStatusList", new Gson().toJson(courseStatusList));
		
		return "organization/training/trainingCourse";
	}
	
	@RequestMapping(value = "/selectCourseStatusList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCourseStatusList(Model model) {
		
		List<EgovMap> courseStatusList = trainingService.selectCourseStatusList();
		
		return ResponseEntity.ok(courseStatusList);
	}
	
	@RequestMapping(value = "/selectCourseTypeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCourseTypeList(Model model) {
		
		List<EgovMap> courseTypeList = trainingService.selectCourseTypeList();
		
		return ResponseEntity.ok(courseTypeList);
	}
	
	@RequestMapping(value = "/selectCourseList.do")
	public ResponseEntity<List<EgovMap>> selectCourseList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		List<EgovMap> courseList = trainingService.selectCourseList(params);
		
		return ResponseEntity.ok(courseList);
	}
	
	@RequestMapping(value = "/courseViewPop.do")
	public String courseViewPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap courseInfo = trainingService.selectCourseInfo(params);
		List<EgovMap> attendeeList = trainingService.selectAttendeeList(params);
		
		model.addAttribute("courseInfo", courseInfo);
		model.addAttribute("attendeeList", new Gson().toJson(attendeeList));
		return "organization/training/trainingViewCoursePop";
	}
	
	@RequestMapping(value = "/selectAttendeeList.do")
	public ResponseEntity<List<EgovMap>> selectAttendeeList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> attendeeList = trainingService.selectAttendeeList(params);
		
		return ResponseEntity.ok(attendeeList);
	}
	
	@RequestMapping(value = "/courseNewPop.do")
	public String courseNewPop(ModelMap model) {
		return "organization/training/trainingNewCoursePop";
	}
	
	@RequestMapping(value = "/selectBranchByMemberId.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectBranchByMemberId(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap result = trainingService.selectBranchByMemberId(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateCourseForLimitStatus.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCourseForLimitStatus(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		trainingService.updateCourseForLimitStatus(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateAttendee.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateAttendee(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		trainingService.updateAttendee(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/attendeePop.do")
	public String attendeePop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("memTypeYN", params.get("memTypeYN"));
		model.addAttribute("btnFlag", params.get("btnFlag"));
		
		return "organization/training/trainingAttendeeRegistrationPop";
	}
	
	@RequestMapping(value = "/getUploadMemList")   
	public ResponseEntity<List<EgovMap>> getUploadMemList (@RequestParam Map<String, Object> params, @RequestParam(value = "nricArray[]") String[] nricArray) throws Exception{
		List<EgovMap> memList = null;
		
		params.put("nricArray", nricArray);
		
		memList = trainingService.getUploadMemList(params);
		
		return ResponseEntity.ok(memList);
	}
	
	@RequestMapping(value = "/insertCourseAttendee.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertCourseAttendee(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		int coursId = trainingService.selectNextCoursId();
		
		params.put("coursId", coursId);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		trainingService.insertCourse(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updateCourseAttendee.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCourseAttendee(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		trainingService.updateCourse(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/courseResultPop.do")
	public String courseResultPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		EgovMap courseInfo = trainingService.selectCourseInfo(params);
		List<EgovMap> attendeeList = trainingService.selectAttendeeList(params);
		
		model.addAttribute("courseInfo", new Gson().toJson(courseInfo));
		model.addAttribute("attendeeList", new Gson().toJson(attendeeList));
		return "organization/training/trainingCourseResultPop";
	}
	
	@RequestMapping(value = "/courseRequest.do")
	public String courseRequest (@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> courseStatusList = trainingService.selectCourseStatusList();
		
		model.addAttribute("courseStatusList", new Gson().toJson(courseStatusList));
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String getUserMemId = sessionVO.getMemId();
		params.put("memId", getUserMemId);
		
		LOGGER.debug("MEM_Id =================================>>  " + sessionVO.getMemId());
		
		EgovMap memInfo = trainingService.getMemCodeForCourse(params);
		if(memInfo != null){
			model.addAttribute("coursMemCode", memInfo.get("memCode"));
		}else{
			model.addAttribute("coursMemCode", "NO");
		}
		
		
		return "organization/training/trainingCourseRequest";
	}
	
	@RequestMapping(value = "/insertAttendee.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertAttendee(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String userNric = trainingService.selectLoginUserNric(sessionVO.getUserId());
		
		params.put("coursId", params.get("coursId"));
		params.put("coursDMemName", sessionVO.getUserFullname());
		params.put("coursDMemNric", userNric);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		trainingService.insertAttendee(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/deleteAttendee.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteAttendee(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		int memId = trainingService.selectLoginUserMemId(sessionVO.getUserId());
		
		params.put("coursId", params.get("coursId"));
		params.put("coursMemId", memId);
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		trainingService.deleteAttendee(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/applicantLog.do")
	public String applicantLog (ModelMap model) {
		return "organization/training/trainingApplicantLog";
	}
	
	@RequestMapping(value = "/selectApplicantLog.do")
	public ResponseEntity<List<EgovMap>> selectApplicantLog(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());
		
		List<EgovMap> courseList = trainingService.selectApplicantLog(params);
		
		return ResponseEntity.ok(courseList);
	}
	
	
	@RequestMapping(value = "/chkNewAttendList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> chkNewAttendList (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{
		
		LOGGER.debug("in  chkNewAttendList ");
		
		LOGGER.debug("params =====================================>>  " + params.toString());
		LOGGER.debug("coursId =====================================>>  " + params.get("memTypeYN"));
		params.put("userId", sessionVO.getUserId());
		
		List<EgovMap> chkList = trainingService.chkNewAttendList(params);
		
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(chkList);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    
    	return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/selectCourseRequestList.do")
	public ResponseEntity<List<EgovMap>> selectCourseRequestList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
        if(params.get("memberCode") != null && params.get("memberCode") != ""){
        	params.put("userId", params.get("memberCode"));
        	EgovMap memInfo = trainingService.selectMemInfo(params);
        	params.put("memberId", memInfo.get("memId"));
        }
		
		List<EgovMap> requestList = trainingService.selectCourseRequestList(params);
		
		return ResponseEntity.ok(requestList);
	}
	
	
	@RequestMapping(value = "/selectMyAttendeeList.do")
	public ResponseEntity<List<EgovMap>> selectMyAttendeeList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String getUserName = sessionVO.getUserName();
		params.put("userId", getUserName);
		
		EgovMap memInfo = trainingService.selectMemInfo(params);
		if(memInfo != null){
			params.put("coursMemId", memInfo.get("memId"));
		}else{
			params.put("coursMemId", 0);
		}
		
		List<EgovMap> attendeeList = trainingService.selectMyAttendeeList(params);
		
		return ResponseEntity.ok(attendeeList);
	}
	
	@RequestMapping(value = "/registerCourseReq.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> registerCourseReq(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		String userNric = trainingService.selectLoginUserNric(sessionVO.getUserId());
		
		params.put("coursId", params.get("coursId"));
		params.put("userId", sessionVO.getUserId());
		
		trainingService.registerCourseReq(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/cancelCourseReq.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> cancelCourseReq(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		
		LOGGER.debug("params =====================================>>  " + params);
		
//		String userNric = trainingService.selectLoginUserNric(sessionVO.getUserId());
		
		params.put("coursId", params.get("coursId"));
		params.put("userId", sessionVO.getUserId());
		
		trainingService.cancelCourseReq(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}

}
