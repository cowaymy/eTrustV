package com.coway.trust.api.project.ChatBot;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.ChatbotSurveyMgmtApiService;
import com.coway.trust.util.SFTPUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "ChatbotSurveyMgmtApiController",description = "ChatbotSurveyMgmtApiController")
@RestController(value = "ChatbotSurveyMgmtApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/cbt")
public class ChatbotSurveyMgmtApiController{

	private static final Logger LOGGER = LoggerFactory.getLogger(ChatbotSurveyMgmtApiController.class);



	@Resource(name = "chatbotSurveyMgmtApiService")
	private ChatbotSurveyMgmtApiService chatbotSurveyMgmtApiService;

	@ApiOperation(value = "/hcSurveyResult", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/hcSurveyResult", method = RequestMethod.POST)
	public ResponseEntity<Map<String,Object>> hcSurveyResult(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
		LOGGER.debug("already into chatbot api");
		return ResponseEntity.ok(chatbotSurveyMgmtApiService.hcSurveyResult(request, params));
	}
}
