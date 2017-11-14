package com.coway.trust.web.notice;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.notice.NoticeService;
import com.coway.trust.biz.notice.NoticeVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/notice")
public class NoticeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(NoticeController.class);

	private static final String NOTICE_SUB_PATH = "notice";

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@Autowired
	private NoticeService noticeService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private FileApplication fileApplication;

	@RequestMapping(value = "/selectCodeList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeList(@RequestParam Map<String, Object> params) {

		List<EgovMap> codeList = noticeService.selectCodeList(params);

		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/noticeList.do")
	public String noticeList(@ModelAttribute("noticeVO") NoticeVO noticeVO) throws Exception {

		return "notice/noticeList";
	}

	@RequestMapping(value = "/noticeViewList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> noticeViewList(@RequestParam Map<String, Object> params,
			@ModelAttribute("noticeVO") NoticeVO noticeVO) throws Exception {

		List<EgovMap> noticeList = noticeService.getNoticeList(params);

		return ResponseEntity.ok(noticeList);
	}

	@RequestMapping(value = "/createNoticePop.do")
	public String createNoticePop(Model model, SessionVO sessionVO) {
		LOGGER.info("@@@@@@@@ createNotice START @@@@@@@");
		model.addAttribute("userName", sessionVO.getUserName());
		return "notice/createNoticePop";
	}

	@RequestMapping(value = "/insertNotice.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertNotice(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		List<EgovFormBasedFileVo> files = EgovFileUploadUtil.uploadFiles(request, uploadDir, NOTICE_SUB_PATH,
				AppConstants.UPLOAD_MAX_FILE_SIZE);

		params.put("userId", sessionVO.getUserId());
		params.put("userName", sessionVO.getUserName());

		fileApplication.noticeAttach(FileType.WEB, FileVO.createList(files), params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/updateNotice.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateNotice(MultipartHttpServletRequest request,
			@RequestParam Map<String, Object> params, SessionVO sessionVO) throws Exception {

		LOGGER.info("<<<<<<<<<<<<params>>>>>>>>>>>>" + params.toString());
		boolean result = noticeService.checkPassword(params);

		ReturnMessage message = new ReturnMessage();
		if (result) {

			List<EgovFormBasedFileVo> files = EgovFileUploadUtil.uploadFiles(request, uploadDir, NOTICE_SUB_PATH,
					AppConstants.UPLOAD_MAX_FILE_SIZE);

			params.put("userId", sessionVO.getUserId());
			params.put("userName", sessionVO.getUserName());

			fileApplication.updateNoticeAttach(FileVO.createList(files), params);
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage("Password mismatch. Please try again."));
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/readNoticePop.do")
	public String readNoticePop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		EgovMap noticeInfo = noticeService.getNoticeInfo(params);
		params.put("atchFileGrpId", noticeInfo.get("atchFileGrpId"));
		List<EgovMap> files = noticeService.getAttachmentFileInfo(params);
		noticeService.updateViewCnt(params);
		model.addAttribute("noticeInfo", noticeInfo);
		model.addAttribute("userName", sessionVO.getUserName());
		model.addAttribute("files", files);
		return "notice/readNoticePop";
	}

	@RequestMapping(value = "/deleteNotice.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteNotice(@RequestBody Map<String, Object> params) {
		boolean result = noticeService.checkPassword(params);
		ReturnMessage message = new ReturnMessage();

		if (result) {
			noticeService.deleteNotice(params);
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		} else {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage("Password mismatch. Please try again."));
		}

		return ResponseEntity.ok(message);
	}

}
