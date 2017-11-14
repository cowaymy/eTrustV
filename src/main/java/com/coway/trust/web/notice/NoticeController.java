package com.coway.trust.web.notice;

import java.io.File;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.notice.NoticeService;
import com.coway.trust.biz.notice.NoticeVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/notice")
public class NoticeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(NoticeController.class);
	
	@Value("${app.name}")
	private String appName;
	
	@Value("${com.file.upload.path}")
	private String uploadDir;
	
//	@Value("${notice}")
//	private String fileViewPath;
	
	@Autowired
	private NoticeService noticeService;

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@Autowired
	private FileApplication fileApplication;
	
	
	@RequestMapping(value = "/selectCodeList" , method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> codeList = noticeService.selectCodeList(params);
		
		return ResponseEntity.ok(codeList);
	}
	
	@RequestMapping(value = "/noticeList.do")
	public String noticeList(@ModelAttribute("noticeVO") NoticeVO noticeVO)throws Exception{
		
		return "notice/noticeList";
	}
	
	@RequestMapping(value = "/noticeViewList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> noticeViewList(@RequestParam Map<String, Object> params, 
			@ModelAttribute("noticeVO") NoticeVO noticeVO)throws Exception{
				
		List<EgovMap> noticeList = noticeService.noticeList(params);
		
		return ResponseEntity.ok(noticeList);
	}
	

	@RequestMapping(value = "/createNoticePop.do")
	public String createNoticePop(Model model){
		LOGGER.info("@@@@@@@@ createNotice START @@@@@@@");
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		
		String loginName = null;
		loginName = sessionVO.getUserName();
		
		model.addAttribute("userName", loginName);
		
		return "notice/createNoticePop";
	}
	
//	@RequestMapping(value = "/getAttachmentFileInfo.do", method = RequestMethod.GET)
//	public ResponseEntity<Map<String, Object>> getAttachmentFileInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
//		
//		LOGGER.debug("params>>>>>>>>>>>>>>>>>>>>>>>>>" +params );
//		
//		Map<String, Object> fileInfo = noticeService.getAttachmentFileInfo(params);
//		fileInfo.put("fileViewPath", fileViewPath);
//		
//		return ResponseEntity.ok(fileInfo);
//	}
	
	

	@RequestMapping(value = "/insertNotice.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertNotice(@RequestBody Map<String, Object> params, Model model) throws Exception{
//		MultipartHttpServletRequest request	
		
		LOGGER.debug("params>>>>>>>>>>>>>>>>>>>>>>>>>" +params );
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		
//		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, 
//				File.separator + "notice", AppConstants.UPLOAD_MAX_FILE_SIZE);
//		
//		LOGGER.debug("list.size>>>>>>>>>>>>>>>>>>>>>>>>>" +list.size() );
//		
//		if(list.size() > 0){
//			fileApplication.businessAttach(AppConstants.FILE_WEB, FileVO.createList(list), params);
//		}
		
//		boolean result = false;
		int loginId;
		String loginName = null;
		
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
			loginName = sessionVO.getUserName();
		}
		
		params.put("userId", loginId);
		params.put("userName", loginName);
//		params.put("attachment", list);
		
		noticeService.insertNotice(params);
		
		ReturnMessage message = new ReturnMessage();
		
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
		
	}
	
	@RequestMapping(value = "/readNoticePop.do")
	public String readNoticePop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		LOGGER.debug("params >>>>>>>>>>>>>>>>>>>>>>>>>> " + params.toString());
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		
		String loginName = null;
		loginName = sessionVO.getUserName();
				
		
		EgovMap noticeInfo = noticeService.noticeInfo(params);
		
		noticeService.upViewCnt(params);
		
		model.addAttribute("noticeInfo", noticeInfo);
		model.addAttribute("userName", loginName);
				
		return "notice/readNoticePop";
	}
	
	@RequestMapping(value = "/deleteNotice.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteNotice(@RequestBody Map<String, Object> params) throws Exception{
		
		boolean result = noticeService.checkPassword(params);
		
		ReturnMessage message = new ReturnMessage();
		
		if(result){
			
			noticeService.deleteNotice(params);
			
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			
		}else{
			
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage("Password mismatch. Please try again."));

		}
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value ="/updateNotice.do" , method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateNotice(@RequestBody Map<String, Object> params) throws Exception{
		
		LOGGER.info("<<<<<<<<<<<<params>>>>>>>>>>>>" + params.toString());
		
		boolean result = noticeService.checkPassword(params);
		
		ReturnMessage message = new ReturnMessage();
		
		if(result){
			
			noticeService.updateNotice(params);
			
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			
		}else{
			
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage("Password mismatch. Please try again."));
		}

		return ResponseEntity.ok(message);
	}
	
	
}
