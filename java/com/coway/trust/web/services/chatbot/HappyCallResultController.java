package com.coway.trust.web.services.chatbot;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.services.chatbot.HappyCallResultService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.commission.CommissionConstants;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/chatbot")
public class HappyCallResultController {
	private static final Logger LOGGER = LoggerFactory.getLogger(HappyCallResultController.class);

	@Resource(name = "happyCallResultService")
	private HappyCallResultService happyCallResultService;

	@RequestMapping(value = "/happyCallResult.do")
	  public String happyCallResult(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		List<EgovMap> callType = happyCallResultService.selectHappyCallType();
	    model.addAttribute("callType", callType);

	    params.put("userId", sessionVO.getUserId());
		if( sessionVO.getUserTypeId() == 1 || sessionVO.getUserTypeId() == 2 || sessionVO.getUserTypeId() == 3 || sessionVO.getUserTypeId() == 7){

			EgovMap result =  happyCallResultService.getUserInfo(params);

			model.put("orgCode", result.get("orgCode"));
			model.put("grpCode", result.get("grpCode"));
			model.put("deptCode", result.get("deptCode"));
			model.put("memCode", result.get("memCode"));
			model.put("isAc", result.get("isAc"));
		}

		return "services/chatbot/happyCallResult";
	  }

	@RequestMapping(value = "/selectHappyCallResultList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectHappyCallResultList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        LOGGER.debug("=============== selectHappyCallResultList.do ===============");
        LOGGER.debug("params ==============================>> " + params);

//        String costCentr = CommonUtils.isEmpty(sessionVO.getCostCentr()) ? "0" : sessionVO.getCostCentr();
//        params.put("userId", sessionVO.getUserId());

        List<EgovMap> list = happyCallResultService.selectHappyCallResultList(params);

        return ResponseEntity.ok(list);
    }

	@RequestMapping(value = "/selectHappyCallResultHistList.do")
	public String selectHappyCallResultHistList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("=============== selectHappyCallResultHistList.do ===============");
        LOGGER.debug("params ==============================>> " + params);

		List<EgovMap> happyCallResultHistoryList = happyCallResultService.selectHappyCallResultHistList(params);

		model.addAttribute("happyCallResultHistoryList", new Gson().toJson(happyCallResultHistoryList));
		model.addAttribute("userDefine1", params.get("userDefine1").toString());
		model.addAttribute("userPrint", params.get("userPrint").toString());

		return "services/chatbot/happyCallResultHistoryPop";
	}
}
