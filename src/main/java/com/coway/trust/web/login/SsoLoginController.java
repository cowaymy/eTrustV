package com.coway.trust.web.login;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;

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
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.login.LoginHistory;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.biz.login.SsoLoginService;
import com.coway.trust.biz.logistics.survey.SurveyService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.Precondition;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.util.Calendar;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/login")
public class SsoLoginController {

	private static final Logger LOGGER = LoggerFactory.getLogger(SsoLoginController.class);

	@Autowired
	private SsoLoginService ssoLoginService;

	@Autowired
	private SurveyService surveyService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@RequestMapping(value = "/selectSSOcredential.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectSSOcredential(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("SearchUserID : {}", params.get("userIdFindPopTxt"));

		LoginVO loginVO = ssoLoginService.selectSSOcredential(params);

		ReturnMessage message = new ReturnMessage();

		if (loginVO == null || loginVO.getUserId() == 0) {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_NOT_EXIST, new Object[] { "ID" }));
		} else {
			message.setData(loginVO);
		}

		return ResponseEntity.ok(message);
	}

}
