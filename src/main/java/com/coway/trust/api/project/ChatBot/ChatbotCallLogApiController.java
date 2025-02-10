package com.coway.trust.api.project.ChatBot;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.ChatbotCallLogApiService;
import com.coway.trust.biz.api.vo.chatbotCallLog.CallLogAppointmentReqForm;
import com.coway.trust.biz.api.vo.chatbotCallLog.CallLogAppointmentRespDto;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "ChatbotCallLogApiController",description = "ChatbotCallLogApiController")
@RestController(value = "ChatbotCallLogApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/cbt")
public class ChatbotCallLogApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ChatbotCallLogApiController.class);

    @Resource(name = "chatbotCallLogApiService")
	private ChatbotCallLogApiService chatbotCallLogApiService;

	@ApiOperation(value = "/reconfirmCustDtl", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/reconfirmCustDtl", method = RequestMethod.POST)
	public ResponseEntity<CallLogAppointmentRespDto> reconfirmCustDtl(HttpServletRequest request, @RequestBody CallLogAppointmentReqForm params) throws Exception {
		return ResponseEntity.ok(chatbotCallLogApiService.reconfirmCustomerDetail(params, request));
	}

	@ApiOperation(value = "/getApptDateDtl", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/getApptDateDtl", method = RequestMethod.POST)
	public CallLogAppointmentRespDto getApptDateDtl(HttpServletRequest request, @RequestBody CallLogAppointmentReqForm params) throws Exception {
		return chatbotCallLogApiService.getAppointmentDateDetail(params,request);
	}

	@ApiOperation(value = "/confirmAppt", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/confirmAppt", method = RequestMethod.POST)
	public ResponseEntity<CallLogAppointmentRespDto> confirmAppt(HttpServletRequest request, @RequestBody CallLogAppointmentReqForm params) throws Exception {
		return ResponseEntity.ok(chatbotCallLogApiService.confirmAppointment(params, request));
	}
}
