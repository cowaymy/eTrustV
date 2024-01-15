package com.coway.trust.api.project.ChatBot;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.ChatbotInboundApiService;
import com.coway.trust.biz.api.vo.chatbotInbound.GetOtdReqForm;
import com.coway.trust.biz.api.vo.chatbotInbound.GetPayModeReqForm;
import com.coway.trust.biz.api.vo.chatbotInbound.OrderListReqForm;
import com.coway.trust.biz.api.vo.chatbotInbound.VerifyCustIdentityReqForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "ChatbotInboundApiController",description = "ChatbotInboundApiController")
@RestController(value = "ChatbotInboundApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/cbt")
public class ChatbotInboundApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ChatbotInboundApiController.class);

	@Resource(name="chatbotInboundApiService")
	private ChatbotInboundApiService chatbotInboundApiService;

	@ApiOperation(value = "/verifyCustIdentity", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/verifyCustIdentity", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> verifyCustIdentity(HttpServletRequest request, @ModelAttribute VerifyCustIdentityReqForm params) throws Exception {
		return ResponseEntity.ok(chatbotInboundApiService.verifyCustIdentity(request, params));
	}

	@ApiOperation(value = "/", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/getOrderList", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getOrderList(HttpServletRequest request,@ModelAttribute OrderListReqForm params) throws Exception {
		return ResponseEntity.ok(chatbotInboundApiService.getOrderList(request, params));
	}

	@ApiOperation(value = "/", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/sendStatement", method = RequestMethod.POST)
	public ResponseEntity<EgovMap> sendStatement(HttpServletRequest request,@RequestParam Map<String, Object> params) throws Exception {
		return ResponseEntity.ok(chatbotInboundApiService.sendStatement(request, params));
	}

	@ApiOperation(value = "/getPaymentMode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/getPaymentMode", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getPaymentMode(HttpServletRequest request,@ModelAttribute GetPayModeReqForm params) throws Exception {
		return ResponseEntity.ok(chatbotInboundApiService.getPaymentMode(request, params));
	}

	@ApiOperation(value = "/getOtd", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/getOtd", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getOtd(HttpServletRequest request,@ModelAttribute GetOtdReqForm params) throws Exception {
		return ResponseEntity.ok(chatbotInboundApiService.getOtd(request, params));
	}

}
