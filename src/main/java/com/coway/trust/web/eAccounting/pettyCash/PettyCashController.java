package com.coway.trust.web.eAccounting.pettyCash;

import java.io.File;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.pettyCash.PettyCashService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.EgovFormBasedFileVo;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/pettyCash")
public class PettyCashController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);
	
	@Autowired
	private PettyCashService pettyCashService;
	
	@Value("${app.name}")
	private String appName;

	@Value("${web.resource.upload.file}")
	private String uploadDir;
	
	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private FileApplication fileApplication;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/pettyCashCustodian.do")
	public String pettyCashCustodian(ModelMap model) {
		return "eAccounting/pettyCash/pettyCashCustodianManagement";
	}
	
	@RequestMapping(value = "/selectPettyCashList.do")
	public ResponseEntity<List<EgovMap>> selectPettyCashList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovMap> pettyCashList = pettyCashService.selectPettyCashList(params);
		
		return ResponseEntity.ok(pettyCashList);
	}
	
	@RequestMapping(value = "/newCustodianPop.do")
	public String newCustodianPop(ModelMap model, SessionVO session) {
		String userNric = pettyCashService.selectUserNric(session.getUserId());
		model.addAttribute("userId", session.getUserId());
		model.addAttribute("userNric", userNric);
		return "eAccounting/pettyCash/pettyCashNewCustodianPop";
	}
	
	@RequestMapping(value = "/newRegistMsgPop.do")
	public String newRegistMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/newCustodianRegistMsgPop";
	}
	
	@RequestMapping(value = "/insertCustodian.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertCustodian(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {
		
		LOGGER.debug("params =====================================>>  " + params);
		
		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "pettyCash", AppConstants.UPLOAD_MAX_FILE_SIZE);
		
		LOGGER.debug("list.size : {}", list.size());
		
		params.put(CommonConstants.USER_ID, sessionVO.getUserId());
		
		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {
			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}

		params.put("attachmentList", list);
		
		// TODO insert
		pettyCashService.insertCustodian(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/newCompletedMsgPop.do")
	public String newCompletedMsgPop(ModelMap model, SessionVO session) {
		return "eAccounting/pettyCash/newCustodianCompletedMsgPop";
	}
}
