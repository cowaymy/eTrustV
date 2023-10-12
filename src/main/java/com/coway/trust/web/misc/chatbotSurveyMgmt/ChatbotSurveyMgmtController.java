package com.coway.trust.web.misc.chatbotSurveyMgmt;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.ChatbotSurveyMgmtApiService;
import com.coway.trust.biz.api.vo.ChatbotVO;
import com.coway.trust.biz.misc.chatbotSurveyMgmt.ChatbotSurveyMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/misc/chatbotSurveyMgmt")
public class ChatbotSurveyMgmtController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ChatbotSurveyMgmtController.class);

	@Resource(name = "chatbotSurveyMgmtService")
	private ChatbotSurveyMgmtService chatbotSurveyMgmtService;

	@Autowired
    private MessageSourceAccessor messageAccessor;

	@Autowired
	private ChatbotSurveyMgmtApiService chatbotSurveyMgmtApiService;

	@RequestMapping(value = "/initChatbotSurveyMgmt.do")
	public String initChatbotSurveyMgmt(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO){
		return "misc/chatbotSurveyMgmt/chatbotSurveyMgmtList";
	}

	@RequestMapping(value = "/selectChatbotSurveyType", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectChatbotSurveyType(@RequestParam Map<String, Object> params) {

        LOGGER.debug("==================== selectChatbotSurveyType ====================");
        LOGGER.debug("params {}", params);

        List<EgovMap> surveyType = chatbotSurveyMgmtService.selectChatbotSurveyType(params);
        LOGGER.debug("params {}", params);
        return ResponseEntity.ok(surveyType);
    }

	@RequestMapping(value = "/selectChatbotSurveyMgmtList", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectChatbotSurveyMgmtList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {


        LOGGER.debug("=============== selectChatbotSurveyMgmtList ===============");
		LOGGER.debug("params =====================================>>  " + params);
		String finalStartDt = null;
		String finalEndDt = null;

		if(CommonUtils.nvl(params.get("surveyFrDt")).equals("") == false){
    		String[] startDt = params.get("surveyFrDt").toString().split("/");
    		finalStartDt = startDt[0] != "" ? startDt[1] + startDt[0] : null;
		}
		params.put("surveyStartDt", finalStartDt);


		if(CommonUtils.nvl(params.get("surveyToDt")).equals("") == false){
    		String[] endDt = params.get("surveyToDt").toString().split("/");
    		finalEndDt = endDt[0] != ""  ? endDt[1] + endDt[0] : null;
		}
		params.put("surveyEndDt", finalEndDt);

		List<EgovMap> surveyMgmtList =  chatbotSurveyMgmtService.selectChatbotSurveyMgmtList(params);

        // 데이터 리턴.
        return ResponseEntity.ok(surveyMgmtList);
    }

	@RequestMapping(value = "/initChatbotSurveyMgmtEdit.do")
	public String initChatbotSurveyMgmtEdit(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("==================== initChatbotSurveyMgmtEdit ====================");
	    LOGGER.debug("params {}", params);

		model.put("ctrlId", params.get("ctrlId").toString());
		model.put("ctrlType", params.get("ctrlType").toString());
		model.put("ctrlRem", params.get("ctrlRem").toString());

		return "misc/chatbotSurveyMgmt/chatbotSurveyMgmtListEditPop";
	}

	@RequestMapping(value = "/selectChatbotSurveyDesc", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectChatbotSurveyDesc(@RequestParam Map<String, Object> params) {

        LOGGER.debug("==================== selectChatbotSurveyDesc ====================");
        LOGGER.debug("params {}", params);

        List<EgovMap> surveyDesc = chatbotSurveyMgmtService.selectChatbotSurveyDesc(params);
        return ResponseEntity.ok(surveyDesc);
    }

	@RequestMapping(value = "/selectChatbotSurveyMgmtEdit.do", method = RequestMethod.POST)
    public ResponseEntity<List<EgovMap>> selectChatbotSurveyMgmtEdit(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) {

        List<EgovMap> surveyMgmtItmList = null;

        LOGGER.debug("=============== selectChatbotSurveyMgmtEdit ===============");
		LOGGER.debug("params =====================================>>  " + params);
		surveyMgmtItmList =  chatbotSurveyMgmtService.selectChatbotSurveyMgmtEdit(params);

        // 데이터 리턴.
        return ResponseEntity.ok(surveyMgmtItmList);
    }

	@RequestMapping(value = "/saveSurveyDetail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSurveyDetail(@RequestBody Map<String, Object> params, SessionVO sessionVO) {

		LOGGER.debug("=============== saveSurveyDetail ===============");
		LOGGER.debug("params =====================================>>  " + params);

		chatbotSurveyMgmtService.saveSurveyDetail(params,sessionVO);
		// 데이터 리턴.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(params);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/pushSurveyQues.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> pushSurveyQues(@RequestBody Map<String, Object> params, HttpServletRequest request) throws Exception {

		LOGGER.debug("=============== pushSurveyQues ===============");
		LOGGER.debug("params =====================================>>  " + params);

		Map<String, Object> returnVal = chatbotSurveyMgmtApiService.pushSurveyQues(params, request);

		return ResponseEntity.ok(returnVal);
	}
}
